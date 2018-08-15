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
import SwipeCellKit
import PKHUD

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, UpdateVC, CellActionsVC {
    var indexes: Paths = Paths()
    
    var viewIsLoaded = false
    var post: Post!
    var staticComments: [Comment]!
    
    var attachmentIDs = [String]()
    var anonymousToggle: Bool = false
    var showingPhotoPicker: Bool = false
    
    var editingExistingComment = false
    var existingCommentToEdit: Comment!
    var existingCell: HomeFeedCommentCell!
    
    var reloadSection = false
    
    lazy var inputBar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        return bar
    }()

    lazy var attachmentManager: AttachmentMan = { [weak self] in
        let manager = AttachmentMan()
        manager.delegate = self
        manager.dataSource = self
        return manager
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeFeedPostCell.register(in: self.tableView)
        HomeFeedCommentCell.register(in: self.tableView)
        
        attachmentManager.isPersistent = false
        attachmentManager.showAddAttachmentCell = false
        attachmentManager.attachmentView.register(UploadImageAttachmentCell.self, forCellWithReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier)
        
        inputBar.inputPlugins = [attachmentManager]
        setupInputBar()

        tableView.contentInset = UIEdgeInsetsMake(-36, 0, -36, 0)
        viewIsLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupInputBar() {
        let items = [
            
            makeButton(named: "add_photo-vector")
                .configure {
                    $0.accessibilityIdentifier = "photoLibraryButton"
                }
                .onSelected { libraryButton in
                    self.showingPhotoPicker = true
                    var config = YPImagePickerConfiguration()
                    config.library.numberOfItemsInRow = 3
                    config.library.spacingBetweenItems = 4.0
                    config.targetImageSize = .cappedTo(size: 1024)
                    config.library.maxNumberOfItems = 10
                    config.library.skipSelectionsGallery = true
                    config.albumName = "Notebowl Photos"
                    config.startOnScreen = .library
                    config.showsCrop = .none
                    config.wordings.libraryTitle = "Gallery"
                    config.hidesStatusBar = false
                    config.showsFilters = false
                    config.icons.capturePhotoImage = UIImage(named: "open_camera-vector")!
                    config.colors.tintColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
                    config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
                    
                    let picker = YPImagePicker(configuration: config)
                    
                    picker.didFinishPicking(completion: { (items, cancelled) in
                        if cancelled {
                            TTLog.debug("cancelled")
                            picker.dismiss(animated: true, completion: nil)
                        }
                        else if !cancelled {
                            self.showingPhotoPicker = false
                            picker.dismiss(animated: true, completion: {
                                for item in items {
                                    if case .photo(let photo) = item {
                                        self.attachmentManager.handleInput(of: photo.image)
                                    }
                                }
                            })
                        }
                    })
                    
                    if let popoverController = picker.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    self.present(picker, animated: true, completion: nil)
                    
            },
            
            makeButton(named: "visibility_on-vector")
                .onKeyboardEditingEnds({ (anonButton) in
                    self.anonymousToggle = false
                    anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
                })
                .configure {
                    $0.accessibilityIdentifier = "anonymousButton"
                    $0.isEnabled = !self.editingExistingComment
                    $0.image = $0.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
                }
                .onSelected { anonButton in
                    self.anonymousToggle.toggleValue()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        if self.anonymousToggle {
                            self.inputBar.sendButton.setTitle("Anonymous Reply", for: .normal)
                        }
                        else if !self.anonymousToggle {
                            self.inputBar.sendButton.setTitle("Reply", for: .normal)
                        }
                    })
                    anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
            },
            .flexibleSpace,
            inputBar.sendButton.configure {
                $0.accessibilityIdentifier = "postButton"
                $0.layer.cornerRadius = 8
                $0.layer.borderWidth = 1.5
                $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                $0.title = "Reply"
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
                $0.titleLabel?.minimumScaleFactor = 0.2
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
                $0.setTitleColor(.groupTableViewBackground, for: .normal)
                $0.setTitleColor(.groupTableViewBackground, for: .highlighted)
                $0.setSize(CGSize(width: 92, height: 36), animated: viewIsLoaded)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = UIColor.groupTableViewBackground
                }.onEnabled {
                    $0.backgroundColor = UIColor(patternImage: (UIImage().createGradientImage(size: 200)))
                    $0.layer.borderColor = UIColor.clear.cgColor
            }
        ]
        inputBar.inputTextView.accessibilityIdentifier = "newCommentTextView"
        inputBar.inputTextView.placeholder = "Write a comment..."
        inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        inputBar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        inputBar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)

    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 36), animated: viewIsLoaded)
            }
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.sendButton.isEnabled = false
        inputBar.sendButton.setTitle("Reply", for: .normal)
        
        DispatchQueue.main.async {
            var jsonPayload: Any?
            if self.editingExistingComment {
                jsonPayload = ["text": text]
                _ = NBNetworking.shared.request(.put, url: self.existingCommentToEdit.url.absoluteString, json: jsonPayload)
            }
            else {
                jsonPayload = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
                let postReq = NBNetworking.shared.request(.post, url: Comment.endpoint, json: jsonPayload)
                let keyPath = (postReq.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
                NBSocket.shared.updateHandler(itemType: "\(ItemType.fromURL((keyPath["url"] as! String)))", updateUrl: (keyPath["url"] as! String), action: "updated", updatedAt: (keyPath["updatedAt"] as! String))
                
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    TTLog.debug("attachment count: ", self.attachmentIDs.count)
                    for file in self.attachmentIDs {
                        TTLog.debug("uploading attachment: ", file)
                        let jsonAttPayload: Any? = ["fileId": file, "_parent": "\((keyPath["url"] as! String))", "attachmentType": "S3", "attachmentName": "image.jpg"]
                        let attReq = NBNetworking.shared.request(.post, url: Attachment.endpoint, json: jsonAttPayload)
                        let attKeyPath = (attReq.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
                        NBSocket.shared.updateHandler(itemType: "\(ItemType.fromURL((attKeyPath["url"] as! String)))", updateUrl: (attKeyPath["url"] as! String), action: "updated", updatedAt: (attKeyPath["updatedAt"] as! String))
                    }
                }
            }
            DispatchQueue.main.async {
                inputBar.inputTextView.resignFirstResponder()
                inputBar.inputTextView.text = String()
                inputBar.invalidatePlugins()
                self.attachmentIDs = []
                self.anonymousToggle = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func resetInput() {
        attachmentIDs = []
        anonymousToggle = false
        
        inputBar.inputTextView.resignFirstResponder()
        inputBar.inputPlugins.removeAll()
        resignFirstResponder()
        reloadInputViews()
        becomeFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.post.postComments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = HomeFeedPostCell.dequeue(from: tableView)!
            cell.configure(post: self.post)
            return cell
        }
        else {
            let cell = HomeFeedCommentCell.dequeue(from: tableView)!
            let comment = self.post.postComments[indexPath.row]
            cell.configure(comment: comment)
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setCollectionView(dataSource: cell, delegate: cell, indexPath: indexPath)
            return cell
        }
    }
}

extension HomeFeedPostViewController {
    
    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "Post" {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
        else if newObject.itemType == "Comment" {
            let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == newObject.resourceKey })
            let existingComment = tableView.numberOfRows(inSection: 1) < self.post.postComments.count ? false : true
            
            if indexOfComment != nil {
                existingComment == false ? tableView.insertRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .automatic) : tableView.reloadRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .fade)
                
                self.tableView.scrollToRow(at: IndexPath(row: indexOfComment!, section: 1), at: .bottom, animated: true)
            }
            else {
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            
        }
        else if ["Like","AttachmentS3"].contains(newObject.itemType) {
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == newObject.parent!.resourceKey }) {
                let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == parentComment.resourceKey })
                parentComment.refresh()
                if indexOfComment != nil { tableView.reloadRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .fade) }
            }

        }
        else if newObject.itemType == "User" {
            if newObject.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                let commentsForUser = self.post.postComments.filter({ $0.creator!.resourceKey == newObject.resourceKey })
                var indexPaths = [IndexPath]()
                for comment in commentsForUser {
                    if let index = self.post.postComments.index(of: comment) {
                        indexPaths.append(IndexPath(row: index, section: 1))
                    }
                }
                tableView.reloadRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if deletedObject.itemType == "Post" {
            if deletedObject.resourceKey == self.post.resourceKey {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if deletedObject.itemType == "Comment" {
            let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == deletedObject.resourceKey })
            if indexOfComment != nil {
                tableView.deleteRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .right)
            }
        }
        else if ["Like","AttachmentS3"].contains(deletedObject.itemType) {
            
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == deletedObject.parent!.resourceKey }) {
                let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == parentComment.resourceKey })
                parentComment.refresh()
                if indexOfComment != nil { tableView.reloadRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .fade) }
            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {}
    
    func reloadTableViews() {}
}


extension HomeFeedPostViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        return self.cellActions(isPost: false, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedCommentCell
        if (selectedCell.commentForCell.creator != nil) {
            if (selectedCell.commentForCell.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey) || (post.owner!.enrollmentForUser?.role == .professor) || (post.owner!.enrollmentForUser?.role == .admin) {
                options.expansionStyle = SwipeExpansionStyle.destructive(automaticallyDelete: false)
            }
        }
        else {
            options.expansionStyle = SwipeExpansionStyle.fill
        }
        options.transitionStyle = SwipeTransitionStyle.border
        options.buttonSpacing = 11
        return options
    }
    
    
}

class AttachmentMan: AttachmentManager {

}

extension HomeFeedPostViewController: AttachmentManagerDelegate, AttachmentManagerDataSource {
    
    
    func attachmentManager(_ manager: AttachmentManager, cellFor attachment: AttachmentManager.Attachment, at index: Int) -> AttachmentCell {
        let indexPath = IndexPath(row: index, section: 0)
        let attachment = manager.attachments[indexPath.row]
        
        if case .image(let image) = attachment {
            guard let cell = self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier, for: indexPath) as? UploadImageAttachmentCell else {
                fatalError()
            }
            TTLog.debug("cellfor attachment")
            cell.attachment = attachment
            cell.indexPath = indexPath
            cell.manager = self.attachmentManager
            cell.imageView.image = image
            
            
            if !cell.uploadStarted || cell.attachmentFileID == "" {
                cell.uploadStarted = true
                let upload = NBNetworking.shared.request(.post, url: ("https://\(NBClient.baseUrl)/rpc/v1.0/files/upload"),
                                                         params: ["uuid": UIDevice().uuid],
                                                         files: ["files[]":.data("attachment.jpg", image.compressedData()!, "image/jpeg")],
                                                         loadImmediately: false,
                                                         asyncProgressHandler: { p in
                                                            DispatchQueue.main.async(execute: {
                                                                TTLog.debug("prgoress: ", p.percentageUpload)
                                                                cell.imageView.uploadImage(image: image, progress: Float(p.percentageUpload))
                                                            })
                }, asyncCompletionHandler: { r in
                    let fileID = ((r.json as AnyObject).value(forKeyPath: "result") as AnyObject).value(forKeyPath: "fileId") as! String
                    
                    cell.attachmentFileID = fileID
                    TTLog.debug("fileid: ", cell.attachmentFileID)

                    if (self.attachmentIDs.count) <= index || self.attachmentIDs.isEmpty {
                        self.attachmentIDs.append(cell.attachmentFileID)
                    }
                    else {
                        self.attachmentIDs[index] = cell.attachmentFileID
                    }
                    
                    DispatchQueue.main.async(execute: {
                        cell.imageView.uploadCompleted()
                    })
                })
                upload.task?.resume()
            }
            return cell
            
        }
        
        else {
            return self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as! AttachmentCell
        }
    }
    
    func setAttachmentManager(active: Bool) {
        TTLog.debug("setAttachmentManager")
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            TTLog.debug("setAttachmentManager active")
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
            
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            TTLog.debug("setAttachmentManager not active")
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        TTLog.debug("manager didselectaddattachment")
    }
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        TTLog.debug("manager didreloadto")

    }
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        TTLog.debug("manager didinsert")
        if !inputBar.sendButton.isEnabled && manager.attachments.count > 0 {
            inputBar.sendButton.isEnabled = true
        }
        
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        TTLog.debug("removing at ", index)

        if !inputBar.sendButton.isEnabled && manager.attachments.count > 0 {
            inputBar.sendButton.isEnabled = true
        }
        else if inputBar.sendButton.isEnabled && manager.attachments.count == 0 && inputBar.inputTextView.text.isEmpty {
            inputBar.sendButton.isEnabled = false
        }
        self.attachmentIDs[index] = ""
    }
}

