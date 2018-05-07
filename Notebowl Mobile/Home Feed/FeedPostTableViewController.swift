//
//  HomeFeedPostViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/15/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import InputBarAccessoryView
import ObjectMapper
import SocketIO
import YPImagePicker
import ButtonProgressBar_iOS
import NVActivityIndicatorView

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, UpdateVC, NVActivityIndicatorViewable {

    var post: Post!
    var currentIndex: IndexPath!
    var staticComments: [Comment]!
    var anonymousToggle: Bool = false
    var viewIsLoaded = false
    var attachmentFileId: String!
    var indicatorView: NVActivityIndicatorView!
    var showingPhotoPicker: Bool = false
    var idForHandler: UUID!
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        return bar
    }()
    
    open lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.delegate = self
        manager.isPersistent = false
        manager.showAddAttachmentCell = false
        return manager
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return bar
    }
    
    override func loadView() {
        super.loadView()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeFeedPostCell.register(in: self.tableView)
        HomeFeedCommentCell.register(in: self.tableView)
        
        setupInputBar()
        registerHandler()
        
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        viewIsLoaded = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !showingPhotoPicker {
            NBSocket.shared.manager.defaultSocket.off(id: idForHandler)
        }
        else {
            TTLog.debug("showing photo picker! don't deregister!")
        }
    }
    
    func handleUpdate(mapped: Generic, updateUI: Bool) {
        if mapped.itemType!.contains("Comment") || mapped.itemType!.contains("Like") || mapped.itemType!.contains("AttachmentS3") || mapped.itemType!.contains("User") {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func registerHandler() {
        idForHandler = NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.info("feedpost socket: on response: ", data)
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    self.handleUpdate(mapped: mapped, updateUI: true)
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        Just.post(("https://\(NBClient.baseUrl)/rpc/v1.0/files/upload"),
                  params: ["uuid": UIDevice().uuid],
                  files:["files[]":.data("attachment.jpg", image.compressedData()!, "image/jpeg")],
                  asyncProgressHandler:{ p in
                    print(p.percent)
                    DispatchQueue.main.async(execute: {
                        
                        // self.profilePicture.uploadImage(image: self.selectedImage, progress: p.percent)
                    })
        }){ r in
            print(r.ok)
            let res = (r.json as AnyObject).value(forKeyPath: "result")
            let fileid = (res as AnyObject).value(forKeyPath: "fileId") as! String
            self.attachmentFileId = fileid
            DispatchQueue.main.async(execute: {
                self.indicatorView.stopAnimating()
                self.bar.sendButton.showViewAnimated(true)
            })
        }
    }
    
    func setupInputBar() {
        resetInput()
        
        let items = [
            makeButton(named: "add_photo-vector")
                .onSelected { libraryButton in
                    self.showingPhotoPicker = true
                    var config = YPImagePickerConfiguration()
                    config.libraryTargetImageSize = .cappedTo(size: 1024)
                    config.albumName = "Notebowl Photos"
                    config.startOnScreen = .library
                    config.showsCrop = .none
                    config.wordings.libraryTitle = "Gallery"
                    config.hidesStatusBar = false
                    config.showsFilters = false
                    config.maxNumberOfItems = 1
                    config.icons.capturePhotoImage = UIImage(named: "open_camera-vector")!
                    config.icons.cropIcon = UIImage(named: "crop-vector")!
                    config.colors.navigationBarTextColor = .darkGray
                    config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    config.delegate = self
                    let picker = YPImagePicker(configuration: config)
                    
                    if let popoverController = picker.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    self.present(picker, animated: true, completion: nil)
                    
            },
            .flexibleSpace,
            makeButton(named: "visibility_on-vector")
                .onSelected { anonButton in
                    self.anonymousToggle.toggle()
                    anonButton.image = self.anonymousToggle ? UIImage(named: "visibility_off-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "visibility_on-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
            },
          
            bar.sendButton.configure {
                $0.layer.cornerRadius = 8
                $0.layer.borderWidth = 1.5
                $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                $0.title = "Post"
                $0.setTitleColor(.groupTableViewBackground, for: .normal)
                $0.setTitleColor(.groupTableViewBackground, for: .highlighted)
                $0.setSize(CGSize(width: 52, height: 30), animated: viewIsLoaded)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = UIColor.groupTableViewBackground
                }.onEnabled {
                    $0.backgroundColor = UIColor(patternImage: (UIImage().createGradientImage(size: 90)))
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        bar.inputTextView.placeholder = "Write a comment..."
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        bar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)
        
        indicatorView = NVActivityIndicatorView(frame: self.bar.sendButton.frame, type: NVActivityIndicatorType.ballPulseSync, color: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1))
        bar.bottomStackView.addSubview(indicatorView)
    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 30), animated: viewIsLoaded)
            }
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let jsonPayload: Any? = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
        let post = Just.post("https://\(NBClient.baseUrl)/api/v1.0/comments", params: ["uuid": UIDevice().uuid], json: jsonPayload)
        let finalmap = Mapper<Comment>().map(JSONObject: (post.json as AnyObject).value(forKeyPath: "result")!)!
        
        if attachmentManager.attachments.count > 0 {
            let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
            let attachment = Just.post("https://\(NBClient.baseUrl)/api/v1.0/attachments", params: ["uuid": UIDevice().uuid], json: jsonAttPayload)
        }

        inputBar.inputTextView.text = String()
        setupInputBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func resetInput() {
        self.attachmentFileId = ""
        self.anonymousToggle = false
        bar.inputTextView.resignFirstResponder()
        bar.inputManagers.removeAll()
        let newBar = InputBarAccessoryView()
        newBar.delegate = self
        newBar.inputManagers = [attachmentManager]
        
        bar = newBar
        reloadInputViews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.post.postComments.count
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 220.0 : 120.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = HomeFeedPostCell.dequeue(from: tableView)!
            cell.configure(post: self.post)
            return cell
        }
        else {
            let cell = HomeFeedCommentCell.dequeue(from: tableView)!
            cell.configure(comment: self.post.postComments[indexPath.row])
            return cell
        }
    }
}

extension HomeFeedPostViewController: YPImagePickerDelegate {
    func imagePicker(_ imagePicker: YPImagePicker, didSelect items: [YPMediaItem]) {
        let item = items.first!
        switch item {
        case .photo(let photo):
            self.showingPhotoPicker = false
            self.attachmentManager.handleInput(of: photo.image)
            imagePicker.dismiss(animated: true, completion: {
                
                self.bar.sendButton.showViewAnimated(false)
                self.indicatorView.startAnimating()
                self.uploadImage(image: photo.image)
            })
        default:
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerDidCancel(_ imagePicker: YPImagePicker) {
        TTLog.debug("canceled")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension HomeFeedPostViewController: AttachmentManagerDelegate {
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        //bar.sendButton.isEnabled = attachments.count > 0
    }
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        //bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        /*
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        */
    }
    
    func setAttachmentManager(active: Bool) {
        let topStackView = bar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

