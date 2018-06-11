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
import SwipeCellKit

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, UpdateVC, NVActivityIndicatorViewable {
    var indexes: Paths = Paths()
    
    var post: Post!
    var staticComments: [Comment]!
    var anonymousToggle: Bool = false
    var viewIsLoaded = false
    var attachmentFileId: String!
    var indicatorView: NVActivityIndicatorView!
    var showingPhotoPicker: Bool = false
    var idForHandler: UUID!
    var editingExistingComment = false
    
    var isPerformingUpdates = false
    var reloadSection = false
    
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
    
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        viewIsLoaded = true
        
        indicatorView = NVActivityIndicatorView(frame: bar.sendButton.frame, type: NVActivityIndicatorType.ballPulseSync, color: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1))
        bar.bottomStackView.addSubview(indicatorView)
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
                    config.library.targetImageSize = .cappedTo(size: 1024)
                    config.albumName = "Notebowl Photos"
                    config.startOnScreen = .library
                    config.showsCrop = .none
                    config.wordings.libraryTitle = "Gallery"
                    config.hidesStatusBar = false
                    config.showsFilters = false
                    config.library.maxNumberOfItems = 1
                    config.icons.capturePhotoImage = UIImage(named: "open_camera-vector")!
                    config.icons.cropIcon = UIImage(named: "crop-vector")!
                    config.colors.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    
                    let picker = YPImagePicker(configuration: config)
                    
                    picker.didFinishPicking(completion: { (items, cancelled) in
                        if cancelled {
                            TTLog.debug("cancelled")
                            picker.dismiss(animated: true, completion: nil)
                        }
                        else if !cancelled {
                            let item = items.first!
                            switch item {
                            case .photo(let photo):
                                self.showingPhotoPicker = false
                                self.attachmentManager.handleInput(of: photo.image)
                                picker.dismiss(animated: true, completion: {
                                    
                                    self.bar.sendButton.showViewAnimated(false)
                                    self.indicatorView.startAnimating()
                                    
                                })
                            default:
                                picker.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                    
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
                    anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
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
        
        let jsonPayload: Any? = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
        let postReq = NBNetworking.shared.request(.post, url: Comment.endpoint, json: jsonPayload)
        let finalmap = Mapper<Comment>().map(JSONObject: (postReq.json as AnyObject).value(forKeyPath: "result")!)!
        
        if self.attachmentManager.attachments.count > 0 {
            let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
            let attReq = NBNetworking.shared.request(.post, url: Attachment.endpoint, json: jsonAttPayload)
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
        bar.inputPlugins.removeAll()
        let newBar = InputBarAccessoryView()
        newBar.delegate = self
        newBar.inputPlugins = [attachmentManager]
        
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
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == newObject.parent!.url.absoluteURL.lastPathComponent }) {
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
            if let parentComment = NBClient.shared.storedTypes[Comment.classIdentifier]!.first(where: { $0.resourceKey == deletedObject.parent!.url.absoluteURL.lastPathComponent }) {
                let indexOfComment = self.post.postComments.index(where: { $0.resourceKey == parentComment.resourceKey })
                parentComment.refresh()
                if indexOfComment != nil { indexes.reloadIndexPaths.append(IndexPath(row: indexOfComment!, section: 1)) }
            }
        }
        
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        
    }
    
    func reloadTableViews() {
        TTLog.warning("already performing updates?? ", self.isPerformingUpdates)
        self.tableView.beginUpdates()
        self.isPerformingUpdates = true
 
        self.tableView.reloadRows(at: self.indexes.reloadIndexPaths, with: .fade)
        self.tableView.insertRows(at: self.indexes.insertIndexPaths, with: .left)
        if self.reloadSection {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            self.reloadSection = false
        }
        if !self.indexes.deleteIndexPaths.isEmpty {
            TTLog.warning("delete not isempty")
            self.tableView.deleteRows(at: self.indexes.deleteIndexPaths, with: .right)
        }
        self.tableView.endUpdates()
        self.isPerformingUpdates = false
        TTLog.warning("COMPLETED????")
        self.indexes = Paths()
 
    }
}


extension HomeFeedPostViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let selectedCell = tableView.cellForRow(at: indexPath) as! HomeFeedCommentCell
        let edit = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editingExistingComment = true
        }
        edit.image = UIImage(named: "edit-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        edit.textColor = .groupTableViewBackground
        edit.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.5137254902, blue: 0.7411764706, alpha: 1)
        edit.fulfill(with: .reset)
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.post.postComments.remove(at: indexPath.row)
            action.fulfill(with: .delete)
            NBNetworking.shared.request(.delete, url: selectedCell.commentForCell.url.absoluteString)
        }
        delete.image = UIImage(named: "trash-vector")!.filled(withColor: .groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        delete.textColor = .groupTableViewBackground
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        
        let report = SwipeAction(style: .default, title: "Report") { (action, indexPath) in
            let alert = UIAlertController(title: "Report Post", message: "What's wrong with this post?", preferredStyle: .actionSheet)
            let inappropriate = UIAlertAction(title: "It doesn't belong on Notebowl", style: .default, handler: { inappAction in
                let payload: Any? = ["reason": "inappropriate", "_parent": "\(selectedCell.commentForCell.url.absoluteString)"]
                NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
            })
            let spam = UIAlertAction(title: "It's spam", style: .default, handler: { spamAction in
                let payload: Any? = ["reason": "spam", "_parent": "\(selectedCell.commentForCell.url.absoluteString)"]
                NBNetworking.shared.request(.post, url: Abuse.endpoint, json: payload)
                alert.dismiss(animated: true, completion: nil)
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
            return [delete, edit]
        }
        else if ((post.owner as! Course).enrollmentForUser?.role == "Professor") {
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
            if (selectedCell.commentForCell.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey) || ((post.owner as! Course).enrollmentForUser?.role == "Professor") {
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

extension HomeFeedPostViewController: AttachmentManagerDelegate {
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        TTLog.debug("att did reload")
    }
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        if let libraryButton = bar.bottomStackViewItems[0] as? InputBarButtonItem {
            libraryButton.isEnabled = manager.attachments.count < 1
        }
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        if let libraryButton = bar.bottomStackViewItems[0] as? InputBarButtonItem {
            libraryButton.isEnabled = manager.attachments.count < 1
        }
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
 
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

