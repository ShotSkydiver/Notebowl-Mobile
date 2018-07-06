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

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, UpdateVC {
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
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        return bar
    }()
    
    lazy var attachmentManager: AttachmentMan = { [weak self] in
        let manager = AttachmentMan()
        manager.delegate = self
        manager.dataSource = self
        manager.isPersistent = false
        manager.showAddAttachmentCell = false
        manager.attachmentView.register(UploadImageAttachmentCell.self, forCellWithReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier)
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
        resetInput()
        
        let items = [
            makeButton(named: "add_photo-vector")
                .onSelected { libraryButton in
                    self.showingPhotoPicker = true
                    var config = YPImagePickerConfiguration()
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
                    config.colors.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    
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
                .configure {
                    $0.isEnabled = !self.editingExistingComment
                    $0.image = $0.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
                }
                .onSelected { anonButton in
                    self.anonymousToggle.toggle()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        if self.anonymousToggle {
                            self.bar.sendButton.setTitle("Reply as Anonymous", for: .normal)
                            self.bar.sendButton.frame = CGRect(x: (self.bar.sendButton.frame.minX-106), y: self.bar.sendButton.frame.minY, width: 168, height: 36)
                        }
                        else if !self.anonymousToggle {
                            self.bar.sendButton.setTitle("Reply", for: .normal)
                            self.bar.sendButton.frame = CGRect(x: (self.bar.sendButton.frame.minX+106), y: self.bar.sendButton.frame.minY, width: 62, height: 36)
                        }
                    })
                    anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
            },
            .flexibleSpace,
            bar.sendButton.configure {
                $0.layer.cornerRadius = 8
                $0.layer.borderWidth = 1.5
                $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                $0.title = "Reply"
                $0.setTitleColor(.groupTableViewBackground, for: .normal)
                $0.setTitleColor(.groupTableViewBackground, for: .highlighted)
                $0.setSize(CGSize(width: 62, height: 36), animated: viewIsLoaded)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = UIColor.groupTableViewBackground
                }.onEnabled {
                    $0.backgroundColor = UIColor(patternImage: (UIImage().createGradientImage(size: 200)))
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        bar.sendButton.onTextViewDidChange { (button, textView) in
            if self.attachmentManager.attachments.count > 0 {
                button.isEnabled = true
            }
        }
        bar.inputTextView.placeholder = "Write a comment..."
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        bar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)

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
        DispatchQueue.main.async {
            var jsonPayload: Any?
            if self.editingExistingComment {
                jsonPayload = ["text": text]
                _ = NBNetworking.shared.request(.put, url: self.existingCommentToEdit.url.absoluteString, json: jsonPayload)
            }
            else {
                jsonPayload = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
                let postReq = NBNetworking.shared.request(.post, url: Comment.endpoint, json: jsonPayload)
                let finalmap = Mapper<Comment>().map(JSONObject: (postReq.json as AnyObject).value(forKeyPath: "result")!)!
                
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    TTLog.debug("attachment count: ", self.attachmentIDs.count)
                    for file in self.attachmentIDs {
                        TTLog.debug("uploading attachment: ", file)
                        let jsonAttPayload: Any? = ["fileId": file, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
                        let attReq = NBNetworking.shared.request(.post, url: Attachment.endpoint, json: jsonAttPayload)
                        
                    }
                }
            }
        
            DispatchQueue.main.async {
                TTLog.debug("start nested async")
                inputBar.inputTextView.text = String()
                
                self.attachmentIDs = []
                self.anonymousToggle = false
                inputBar.invalidatePlugins()
                
                
                
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func resetInput() {
        attachmentIDs = []
        anonymousToggle = false
        
        bar.inputTextView.resignFirstResponder()
        bar.inputPlugins.removeAll()
        resignFirstResponder()
        
        let newManager = AttachmentMan()
        newManager.delegate = self
        newManager.dataSource = self
        newManager.isPersistent = false
        newManager.showAddAttachmentCell = false
        newManager.attachmentView.register(UploadImageAttachmentCell.self, forCellWithReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier)
        attachmentManager = newManager
        
        let newBar = InputBarAccessoryView()
        newBar.delegate = self
        newBar.inputPlugins = [attachmentManager]
        bar = newBar
        
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
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
        }
        else if newObject.itemType == "Comment" {
            let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == newObject.resourceKey })
            let existingComment = tableView.numberOfRows(inSection: 1) < self.post.postComments.count ? false : true
            
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
            existingComment == false ? indexes.insertIndexPaths.append(IndexPath(row: indexOfComment!, section: 1)) : indexes.reloadIndexPaths.append(IndexPath(row: indexOfComment!, section: 1))
            
        }
        else if ["Like","AttachmentS3"].contains(newObject.itemType) {
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == newObject.parent!.resourceKey }) {
                let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == parentComment.resourceKey })
                parentComment.refresh()
                if indexOfComment != nil { indexes.reloadIndexPaths.append(IndexPath(row: indexOfComment!, section: 1)) }
            }

        }
        else if newObject.itemType == "User" {
            if newObject.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
                indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
                let commentsForUser = self.post.postComments.filter({ $0.creator!.resourceKey == newObject.resourceKey })
                for comment in commentsForUser {
                    if let index = self.post.postComments.index(of: comment) {
                        indexes.reloadIndexPaths.append(IndexPath(row: index, section: 1))
                    }
                }
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if deletedObject.itemType == "Post" {
            if deletedObject.resourceKey == self.post.resourceKey {
                self.navigationController?.popViewController(animated: true)
            }

            TTLog.warning("deletedobject Post")
        }
        else if deletedObject.itemType == "Comment" {
            TTLog.warning("deletedobject comment")
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
            let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == deletedObject.resourceKey })
            if indexOfComment != nil { indexes.deleteIndexPaths.append(IndexPath(row: indexOfComment!, section: 1)) }
            
            else {
                self.reloadSection = true
            }
        }
        else if ["Like","AttachmentS3"].contains(deletedObject.itemType) {
            TTLog.warning("deletedobject like attachment")
            indexes.reloadIndexPaths.append(IndexPath(row: 0, section: 0))
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == deletedObject.parent!.resourceKey }) {
                let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == parentComment.resourceKey })
                parentComment.refresh()
                if indexOfComment != nil { indexes.reloadIndexPaths.append(IndexPath(row: indexOfComment!, section: 1)) }
            }
        }
        
    }
    
    func handleElapsed(elapsedObject: NBModel) {
    }
    
    func reloadTableViews() {
        if self.indexes.shouldReload {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: self.indexes.reloadIndexPaths, with: .fade)
            self.tableView.insertRows(at: self.indexes.insertIndexPaths, with: .left)
            
            if self.reloadSection {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                self.reloadSection = false
            }
            self.tableView.deleteRows(at: self.indexes.deleteIndexPaths, with: .right)
            self.tableView.endUpdates()
            TTLog.warning("COMPLETED????")
            if !self.indexes.insertIndexPaths.isEmpty {
                self.tableView.scrollToRow(at: self.indexes.insertIndexPaths.first!, at: .bottom, animated: true)
            }
            self.indexes = Paths()
        }
    }
}


extension HomeFeedPostViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedCommentCell
        let edit = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in

        }
        edit.image = UIImage(named: "edit-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        edit.textColor = .groupTableViewBackground
        edit.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.5137254902, blue: 0.7411764706, alpha: 1)
        edit.hidesWhenSelected = true
        edit.fulfill(with: .reset)
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.post.postComments.remove(at: indexPath.row)
            action.fulfill(with: .delete)
            _ = NBNetworking.shared.request(.delete, url: selectedCell.commentForCell.url.absoluteString)
        }
        delete.image = UIImage(named: "trash-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        delete.textColor = .groupTableViewBackground
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        
        let report = SwipeAction(style: .default, title: "Report") { (action, indexPath) in
            let alert = UIAlertController(title: "Report Comment", message: "What's wrong with this comment?", preferredStyle: .actionSheet)
            let inappropriate = UIAlertAction(title: "It doesn't belong on Notebowl", style: .default, handler: { inappAction in
                let payload: Any? = ["reason": "inappropriate", "_parent": "\(selectedCell.commentForCell.url.absoluteString)"]
                _ = NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
                PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Report Sent", subtitle: nil)
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
            let spam = UIAlertAction(title: "It's spam", style: .default, handler: { spamAction in
                let payload: Any? = ["reason": "spam", "_parent": "\(selectedCell.commentForCell.url.absoluteString)"]
                _ = NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
                PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Report Sent", subtitle: nil)
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 2.0)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(inappropriate)
            alert.addAction(spam)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        report.image = UIImage(named: "report-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        report.textColor = .groupTableViewBackground
        report.backgroundColor = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        report.hidesWhenSelected = true
        
        if (selectedCell.commentForCell.creator != nil) && (selectedCell.commentForCell.creator?.resourceKey == NBClient.shared.getCurrentUser().resourceKey) {
            return [delete] //, edit]
        }
        else if (post.owner!.enrollmentForUser?.role == .professor) || (post.owner!.enrollmentForUser?.role == .admin) {
            return [delete, report] // and pin
        }
        else {
            return [report]
        }
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
        let topStackView = bar.topStackView
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
        if !bar.sendButton.isEnabled && manager.attachments.count > 0 {
            bar.sendButton.isEnabled = true
        }
        
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        TTLog.debug("removing at ", index)

        if !bar.sendButton.isEnabled && manager.attachments.count > 0 {
            bar.sendButton.isEnabled = true
        }
        else if bar.sendButton.isEnabled && manager.attachments.count == 0 && bar.inputTextView.text.isEmpty {
            bar.sendButton.isEnabled = false
        }
        self.attachmentIDs[index] = ""
    }
}

