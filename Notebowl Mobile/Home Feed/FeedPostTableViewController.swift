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

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate {

    var post: Post!
    var currentIndex: IndexPath!
    var staticComments: [Comment]!
    var anonymousToggle: Bool = false
    var viewIsLoaded = false
    var attachmentFileId: String!
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
        // staticComments = post.postComments
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
    func registerHandler() {
    
        idForHandler = NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            TTLog.info("feedpost socket: on response: ", data)
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    if mapped.itemType!.contains("Comment") || mapped.itemType!.contains("Like") || mapped.itemType!.contains("AttachmentS3") || mapped.itemType!.contains("User") {
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        self.tableView.endUpdates()
                    }
                    
                    /*
                    if (mapped.itemType?.contains("Comment"))! {
                        TTLog.testing("handling socket response for object type of comment!")
                        let mappedComment = mapped as! Response<Comment>
                        var indexOfComment: Int?
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        
                        
                        
                        if mappedComment.actionType == .updated {
                            if mappedComment.updateUrl!.parent.lastPathComponent == self.post.resourceKey {
                                indexOfComment = self.post.postComments.index(of: mappedComment.updateUrl!)
                                self.tableView.insertRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .top)
                            }
                        }
                        else if mappedComment.actionType == .deleted {
                            if let tempComment = self.staticComments.first(where: { $0.resourceKey == updateUrl.absoluteURL.lastPathComponent }) {
                                indexOfComment = self.staticComments.index(of: tempComment)
                                self.tableView.deleteRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .right)
                            }
                        }
                        
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        self.tableView.endUpdates()
                        self.staticComments = self.post.postComments
                    }
                        
                    else if (mapped.itemType?.contains("Like"))! {
                        
                        
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                        self.tableView.endUpdates()
                        self.staticComments = self.post.postComments
                    }
                    */
                }
                    
                catch let error {
                    print("Error parsing json: \(error)")
                }
            }
        }
        
    }
    
    func setupInputBar() {
        resetInput()
        
        let items = [
            makeButton(named: "add_photo-vector").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
                }.onSelected { photoButton in
                    self.showingPhotoPicker = true
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
            },
            makeButton(named: "add_library-vector")
                .onSelected { libraryButton in
                    self.showingPhotoPicker = true
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            },
            .flexibleSpace,
            makeButton(named: "public-vector")
                .onSelected { anonButton in
                    self.anonymousToggle.toggle()
                    anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal)
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
                    // $0.setBackgroundImage(UIImage().filled(withColor: .groupTableViewBackground), for: .disabled)
                }.onEnabled {
                    // $0.setBackgroundImage(UIImage().createGradientImage(size: 170), for: .normal)
                    // UIColor(patternImage: grad)
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
        // expand button
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)
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
        // bar.sendButton.ay.startLoading()
        // DispatchQueue.main.async {
        let jsonPayload: Any? = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
        let post = Just.post("https://\(NBClient.baseUrl)/api/v1.0/comments", params: ["uuid": UIDevice().uuid], json: jsonPayload)
        
        let finalmap = Mapper<Comment>().map(JSONObject: (post.json as AnyObject).value(forKeyPath: "result")!)!
        // NBClient.shared.storedTypes[Comment.classIdentifier]?.append(finalmap)
        
        if attachmentManager.attachments.count > 0 {
            let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
            let attachment = Just.post("https://\(NBClient.baseUrl)/api/v1.0/attachments", params: ["uuid": UIDevice().uuid], json: jsonAttPayload)
            
            // let finalmapAtt = Mapper<Attachment>().map(JSONObject: (attachment.json as AnyObject).value(forKeyPath: "result")!)!
            // NBClient.shared.storedTypes[Attachment.classIdentifier]?.append(finalmapAtt)
        }
        
        // finalmap.getAttachments()
        // finalmap.updateLikes()
        // self.post.refresh()
    
        inputBar.inputTextView.text = String()
        /*
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        // tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 1)], with: .fade)
        tableView.endUpdates()
        */
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
        // newBar.setStackViewItems([typingIdicator], forStack: .top, animated: false)
        
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

extension HomeFeedPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.showingPhotoPicker = false
                
                self.attachmentManager.handleInput(of: pickedImage)
                
                self.bar.sendButton.isEnabled = false
 
                self.attachmentFileId = (NBClient.shared.uploadToFiles(attachment: pickedImage))

                self.bar.sendButton.isEnabled = true
            }
        })
    }
}

extension HomeFeedPostViewController: AttachmentManagerDelegate {
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        bar.sendButton.isEnabled = attachments.count > 0
    }
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
