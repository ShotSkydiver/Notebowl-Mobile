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
import SwipeCellKit
import PKHUD

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, UpdateVC, CellActionsVC {
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
    
    var photoLibraryButton: InputBarButtonItem!
    var anonymousButton: InputBarButtonItem!

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

        refreshAllComments()
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        viewIsLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshAllComments() {
        for comment in self.post.postComments { comment.refresh() }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPostDetailSegue" {
            let destVC = segue.destination as! CreateNewPostViewController

            if sender is HomeFeedPostCell {
                var courseForPicker = (NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]).filter({ $0.isAvailable })
                courseForPicker.sort() { $0.fullName < $1.fullName }
                var pickerItems = courseForPicker as [NBModel]

                var groups = (NBClient.shared.storedTypes.has(key: Group.classIdentifier) ? NBClient.shared.storedTypes[Group.classIdentifier]! as! [Group] : [])
                groups.sort() { $0.fullName < $1.fullName }
                pickerItems += groups as [NBModel]

                destVC.objectsForPicker = pickerItems
                destVC.existingObjectToEdit = (sender as! HomeFeedPostCell).postForCell
            }
            else if sender is HomeFeedCommentCell {
                destVC.objectsForPicker = []
                destVC.existingObjectToEdit = (sender as! HomeFeedCommentCell).commentForCell
            }
            destVC.editingExisting = true
        }
    }
    
    func handleDeleteAction(objectToDelete: NBModel) {
        if (objectToDelete is Post) {
            self.navigationController?.popViewController(animated: true)
        }
        else if (objectToDelete is Comment) {
            self.post.postComments.removeAll(objectToDelete as! Comment)
        }
    }

    func setupInputBar() {
        photoLibraryButton = makeButton(named: "add_photo-vector")
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
                        log.debug("cancelled")
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
                
        }
        
        anonymousButton = makeButton(named: "visibility_on-vector")
            .configure {
                $0.accessibilityIdentifier = "anonymousButton"
                $0.isEnabled = !self.editingExistingComment
                $0.image = $0.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
            }
            .onSelected { anonButton in
                self.anonymousToggle.toggleValue()
                if self.anonymousToggle {
                    self.inputBar.sendButton.setSize(CGSize(width: 184, height: 36), animated: false)
                    self.inputBar.sendButton.setTitle("Reply as Anonymous", for: .normal)
                }
                else if !self.anonymousToggle {
                    self.inputBar.sendButton.setSize(CGSize(width: 52, height: 36), animated: false)
                    self.inputBar.sendButton.setTitle("Reply", for: .normal)
                }
                anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
        }
        
        let items = [
            photoLibraryButton,
            anonymousButton,
            InputBarButtonItem.flexibleSpace,
            inputBar.sendButton.configure {
                $0.accessibilityIdentifier = "postButton"
                $0.title = "Reply"
                $0.titleLabel?.textAlignment = .left
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
                $0.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), for: .normal)
                $0.setSize(CGSize(width: 52, height: 36), animated: false)
                }.onTouchUpInside {
                    self.anonymousButton.image = self.anonymousButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
                    $0.setSize(CGSize(width: 52, height: 36), animated: false)
                    $0.setTitle("Reply", for: .normal)
                    $0.isEnabled = false
                    $0.inputBarAccessoryView?.didSelectSendButton()
            }
        ]
        inputBar.inputTextView.accessibilityIdentifier = "newCommentTextView"
        inputBar.inputTextView.placeholder = "Write a comment..."
        inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        inputBar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        inputBar.setStackViewItems(items as! [InputItem], forStack: .bottom, animated: false)
    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(4)
                $0.image = UIImage(named: named)!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 36), animated: false)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.resignFirstResponder()
        
        HUD.show(.progress)
        NBClient.shared.delay(1.0) {
            if self.editingExistingComment {
                self.existingCommentToEdit.text = text
                _ = self.existingCommentToEdit.save()
            }
            else {
                let newComment = Comment(text: text, owner: self.post.parent, parent: self.post, related: self.post.parent, isAnonymous: self.anonymousToggle)
                let finalComment = newComment.save()
                if finalComment == nil {
                    HUD.flash(.labeledError(title: "Server Error!", subtitle: "Well, this is embarrassing, something's wrong on our end."), delay: 0.5)
                    return
                }
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    log.debug("attachment count: \(self.attachmentIDs.count)")
                    for file in self.attachmentIDs {
                        log.debug("uploading attachment: \(file)")
                        let newAttach = Attachment(file: file, parent: finalComment)
                        _ = newAttach.save()
                    }
                }
            }
            inputBar.inputTextView.text = String()
            inputBar.invalidatePlugins()
            self.attachmentIDs = []
            self.anonymousToggle = false
            HUD.flash(.success, delay: 0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = String(format: "HomeFeedPostCell-DetailView-%d-%d", indexPath.section, indexPath.row)
            cell.accessibilityLabel = cell.accessibilityIdentifier
            cell.contentView.isAccessibilityElement = false
            cell.contentView.accessibilityIdentifier = String(format: "PostCellContentView-DetailView-%d-%d", indexPath.section, indexPath.row)
            cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier
            
            cell.configure(post: self.post)
            cell.delegate = self
            return cell
        }
        else {
            let cell = HomeFeedCommentCell.dequeue(from: tableView)!
            
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = String(format: "HomeFeedCommentCell-DetailView-%d-%d", indexPath.section, indexPath.row)
            cell.accessibilityLabel = cell.accessibilityIdentifier
            cell.contentView.isAccessibilityElement = false
            cell.contentView.accessibilityIdentifier = String(format: "CommentCellContentView-DetailView-%d-%d", indexPath.section, indexPath.row)
            cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier
            
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
        if let newPost = newObject as? Post {
            if newPost.parent is Assignment {
                return
            }
            if newPost == self.post {
                self.post = newPost
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
            
        else if let newComment = newObject as? Comment {
            if newComment.related is Assignment {
                return
            }
            let indexOfComment = self.post.postComments.index(of: newComment)
            let existingComment = tableView.numberOfRows(inSection: 1) < self.post.postComments.count ? false : true
            
            tableView.beginUpdates()
            if indexOfComment != nil {
                if existingComment {
                    self.post.postComments[indexOfComment!].refresh()
                    tableView.reloadRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .fade)
                }
                else { tableView.insertRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .automatic) }
            }
            else { tableView.reloadSections(IndexSet(integer: 1), with: .automatic) }
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: indexOfComment!, section: 1), at: .none, animated: true)
        }

        else if ["Like","AttachmentS3"].contains(newObject.itemType) {
            if newObject.parent is Comment, !(newObject.parent!.related is Assignment) {
                if let indexOfComment = self.post.postComments.index(of: newObject.parent! as! Comment) {
                    self.post.postComments[indexOfComment].refresh()
                    tableView.reloadRows(at: [IndexPath(row: indexOfComment, section: 1)], with: .fade)
                    tableView.scrollToRow(at: IndexPath(row: indexOfComment, section: 1), at: .none, animated: true)
                }
            }
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
        else if let newUser = newObject as? User {
            if newUser == NBClient.shared.getCurrentUser() {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                let commentsForUser = self.post.postComments.filter({ $0.creator! == newUser })
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
        if let deletePost = deletedObject as? Post, !(deletePost.parent is Assignment) {
            if deletePost == self.post {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if let deleteComment = deletedObject as? Comment, !(deleteComment.related is Assignment) {
            guard let indexOfComment = self.post.postComments.index(of: deleteComment) else {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                (self.parent?.children[0] as! HomeFeedViewController).handleDeleted(deletedObject: deleteComment)
                return
            }
            let deleted = self.post.postComments.remove(at: indexOfComment)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(row: indexOfComment, section: 1)], with: .fade)
            self.post.refresh()
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            self.tableView.endUpdates()
            (self.parent?.children[0] as! HomeFeedViewController).handleDeleted(deletedObject: deleted)
        }
        else if ["Like","AttachmentS3"].contains(deletedObject.itemType) {
            var indexOfComment: Int?
            if deletedObject.parent is Comment, !(deletedObject.parent!.related is Assignment) {
                indexOfComment = self.post.postComments.index(of: deletedObject.parent! as! Comment)
                if indexOfComment != nil { self.post.postComments[indexOfComment!].refresh() }
            }
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            if indexOfComment != nil { tableView.reloadRows(at: [IndexPath(row: indexOfComment!, section: 1)], with: .none) }
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {}
}


extension HomeFeedPostViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.section == 0 {
            return self.cellActions(isPost: true, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        }
        else {
            return self.cellActions(isPost: false, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        if indexPath.section == 0 {
            return self.cellActionOptions(isPost: true, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        }
        else {
            return self.cellActionOptions(isPost: false, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        }
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
            log.debug("cellfor attachment")
            cell.attachment = attachment
            cell.indexPath = indexPath
            cell.manager = self.attachmentManager
            cell.imageView.image = image
            
            
            if !cell.uploadStarted || cell.attachmentFileID == "" {
                cell.uploadStarted = true
                let upload = NBNetworking.shared.request(.post, url: ("https://\(baseUrl)/rpc/v1.0/files/upload"),
                                                         params: ["uuid": UIDevice().uuid],
                                                         files: ["files[]":.data("attachment.jpg", image.compressedData()!, "image/jpeg")],
                                                         loadImmediately: false,
                                                         asyncProgressHandler: { p in
                                                            DispatchQueue.main.async(execute: {
                                                                log.debug("prgoress: \(p.percentageUpload)")
                                                                cell.imageView.uploadImage(image: image, progress: Float(p.percentageUpload))
                                                            })
                }, asyncCompletionHandler: { r in
                    let fileID = ((r.json as AnyObject).value(forKeyPath: "result") as AnyObject).value(forKeyPath: "fileId") as! String
                    
                    cell.attachmentFileID = fileID
                    log.debug(cell.attachmentFileID)

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
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
            
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
    }

    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
    }
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        if !inputBar.sendButton.isEnabled && manager.attachments.count > 0 {
            inputBar.sendButton.isEnabled = true
        }
        
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        if !inputBar.sendButton.isEnabled && manager.attachments.count > 0 {
            inputBar.sendButton.isEnabled = true
        }
        else if inputBar.sendButton.isEnabled && manager.attachments.count == 0 && inputBar.inputTextView.text.isEmpty {
            inputBar.sendButton.isEnabled = false
        }
        self.attachmentIDs[index] = ""
    }
}

