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
import ImageViewer

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate, CellActionsVC {
    var viewIsLoaded = false
    var displayedPost: PostsComments!
    var attachmentIDs = [String]()
    var anonymousToggle: Bool = false

    var postCommentToReplyTo: PostsComments!
    var currentWorkingIndexPath: IndexPath!

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
    var cancelReplyButton: InputBarButtonItem!

    let replyUserNameString: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(hexString: "#9197A1")
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.accessibilityIdentifier = "replyingToUserText"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var replyUserStackView: UIStackView = {
        let userStackView = UIStackView()
        userStackView.axis = .horizontal
        userStackView.alignment = .fill
        userStackView.distribution = .fill
        return userStackView
    }()

    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? { return inputBar }

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

        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        self.postCommentToReplyTo = self.displayedPost

        setupObservers()
        viewIsLoaded = true
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willDeleteComment(_:)), name: NSNotification.Name("ModelWillDeleteComment"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingPost(_:)), name: NSNotification.Name("ModelDidFinishUpdatingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingComment(_:)), name: NSNotification.Name("ModelDidFinishUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAttachment"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingPost(_:)), name: NSNotification.Name("ModelDidFinishDeletingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingComment(_:)), name: NSNotification.Name("ModelDidFinishDeletingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishDeletingLike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingLikesAttachments(_:)), name: NSNotification.Name("ModelDidFinishDeletingAttachment"), object: nil)
    }

    @objc func finishUpdatingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newPost = dict["object"] as? Post else {
            return
        }
        if !isDisplayedPost(object: newPost) {
            return
        }

        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }

    @objc func finishUpdatingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newComment = dict["object"] as? Comment else {
            return
        }
        if !isDisplayedPost(object: newComment) {
            return
        }

        guard let index = self.getIndexOfComment(comment: newComment) else {
            return
        }

        var isExistingComment = tableView.numberOfSections > self.displayedPost.comments.count
        if newComment.isCommentReply {
            isExistingComment = tableView.numberOfRows(inSection: index.section) >= self.displayedPost.comments[index.section - 1].comments.count + 1
        }

        tableView.beginUpdates()

        if isExistingComment {
            tableView.reloadRows(at: [index], with: .automatic)
        } else {
            if !newComment.isCommentReply {
                tableView.insertSections(IndexSet(integer: index.section), with: .automatic)
            }
            tableView.insertRows(at: [index], with: .automatic)
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }

        tableView.endUpdates()
        tableView.scrollToRow(at: index, at: .none, animated: true)
    }

    @objc func finishUpdatingLikesAttachments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }
        if !isDisplayedPost(object: newObject) {
            return
        }

        if newObject.parent is Post {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            return
        }

        guard let commentIndex = self.getIndexOfComment(comment: newObject.parent as! Comment) else {
            return
        }

        tableView.reloadRows(at: [commentIndex], with: .automatic)
    }

    @objc func willDeleteComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletingComment = dict["object"] as? Comment else {
            return
        }
        if !isDisplayedPost(object: deletingComment) {
            return
        }

        guard let index = self.getIndexOfComment(comment: deletingComment) else {
            return
        }

        currentWorkingIndexPath = index
    }

    @objc func finishDeletingPost(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedPost = dict["object"] as? Post else {
            return
        }

        if !isDisplayedPost(object: deletedPost) {
            return
        }

        self.navigationController?.popViewController(animated: true)
    }

    @objc func finishDeletingComment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedComment = dict["object"] as? Comment else {
            return
        }

        if !isDisplayedPost(object: deletedComment) {
            return
        }

        guard let index = currentWorkingIndexPath else {
            return
        }

        tableView.beginUpdates()

        if deletedComment.isCommentReply {
            tableView.deleteRows(at: [index], with: .fade)
        } else {
            tableView.deleteSections(IndexSet(integer: index.section), with: .fade)
        }

        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()

        currentWorkingIndexPath = nil
    }

    @objc func finishDeletingLikesAttachments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedObject = dict["object"] as? NBModel else {
            return
        }

        if !isDisplayedPost(object: deletedObject) {
            return
        }

        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        if deletedObject.parent is Comment, let commentIndex = self.getIndexOfComment(comment: deletedObject.parent as! Comment) {
            tableView.reloadRows(at: [commentIndex], with: .none)
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPostDetailSegue" {
            let destVC = segue.destination as! CreateNewPostViewController
            if sender is HomeFeedPostCell {
                var courseForPicker: [Course] = Course.getCache().filter({ $0.isAvailable })
                courseForPicker.sort() { $0.fullName < $1.fullName }
                var pickerItems = courseForPicker as [NBModel]

                var groupsForPicker: [Group] = Group.getCache()
                groupsForPicker.sort() { $0.fullName < $1.fullName }
                pickerItems += groupsForPicker as [NBModel]

                destVC.objectsForPicker = pickerItems
                destVC.existingObjectToEdit = (sender as! HomeFeedPostCell).postForCell
            } else if sender is HomeFeedCommentCell {
                destVC.objectsForPicker = []
                destVC.existingObjectToEdit = (sender as! HomeFeedCommentCell).commentForCell
            }
            destVC.editingExisting = true
        }
    }

    func setupInputBar() {
        inputBar.isTranslucent = true
        inputBar.inputTextView.keyboardType = .twitter
        inputBar.inputTextView.isImagePasteEnabled = true
        inputBar.inputTextView.accessibilityIdentifier = "newCommentTextView"
        inputBar.inputTextView.placeholder = "Write a comment..."
        inputBar.inputTextView.backgroundColor = UIColor(hexString: "#F6F6F8")
        inputBar.inputTextView.placeholderTextColor = UIColor(hexString: "#60666F")
        inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 36)
        inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 11.5, left: 16, bottom: 11.5, right: 36)
        inputBar.inputTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 14.0)
        inputBar.inputTextView.layer.borderColor = UIColor(hexString: "#CCD0D4").cgColor
        inputBar.inputTextView.layer.borderWidth = 1.5
        inputBar.inputTextView.layer.cornerRadius = 20.0
        inputBar.inputTextView.layer.masksToBounds = true
        inputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputBar.separatorLine.backgroundColor = UIColor.groupTableViewBackground

        photoLibraryButton = makeButton(named: "add_photo-vector")
            .configure {
                $0.accessibilityIdentifier = "photoLibraryButton"
            }
            .onSelected { libraryButton in
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
                        picker.dismiss(animated: true, completion: nil)
                    } else if !cancelled {
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
            .onKeyboardEditingBegins { item in
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 42, animated: true)
            }
            .onKeyboardEditingEnds { item in
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
        }

        anonymousButton = makeButton(named: "visibility_on-vector")
            .configure {
                $0.accessibilityIdentifier = "anonymousButton"
            }
            .onSelected { anonButton in
                self.anonymousToggle.toggleValue()
                anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: UIColor(hexString: "#91949C")).withRenderingMode(.alwaysOriginal)
        }

        cancelReplyButton = makeButton(named: "dismiss-vector")
            .configure {
                $0.accessibilityIdentifier = "removeReplyButton"
                $0.setSize(CGSize(width: 36, height: 36), animated: false)
                $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            }
            .onSelected { cancelButton in
                self.replyUserNameString.attributedText = nil
                cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cancelButton.setSize(CGSize(width: 0, height: 0), animated: true)
                self.setUserReplyStatus(makeVisible: false)

                self.inputBar.inputTextView.placeholder = "Write a comment..."
                self.postCommentToReplyTo = self.displayedPost
        }

        inputBar.sendButton.configure {
            $0.accessibilityIdentifier = "postButton"
            $0.title = "Reply"
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            $0.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), for: .normal)
            $0.setSize(CGSize(width: 52, height: 40), animated: false)
            }.onTouchUpInside {
                self.anonymousButton.image = self.anonymousButton.image!.filled(withColor: UIColor(hexString: "#91949C")).withRenderingMode(.alwaysOriginal)
                $0.isEnabled = false
                $0.inputBarAccessoryView?.didSelectSendButton()
        }

        inputBar.setStackViewItems([photoLibraryButton, InputBarButtonItem.fixedSpace(4)], forStack: .left, animated: false)
        inputBar.setLeftStackViewWidthConstant(to: 0, animated: false)

        inputBar.setRightStackViewWidthConstant(to: 98, animated: false)
        inputBar.setStackViewItems([anonymousButton, InputBarButtonItem.fixedSpace(4), inputBar.sendButton], forStack: .right, animated: false)

        inputBar.middleContentViewPadding.right = -42
        inputBar.topStackViewPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        replyUserStackView.addArrangedSubview(replyUserNameString)
        replyUserStackView.addArrangedSubview(InputBarButtonItem.flexibleSpace)
        replyUserStackView.addArrangedSubview(cancelReplyButton)
    }

    func setUserReplyStatus(makeVisible: Bool) {
        let topStackView = inputBar.topStackView
        if makeVisible && !topStackView.arrangedSubviews.contains(replyUserStackView) {
            topStackView.insertArrangedSubview(replyUserStackView, at: 0)
            inputBar.layoutStackViews([.top])
        } else if !makeVisible && topStackView.arrangedSubviews.contains(replyUserStackView) {
            topStackView.removeArrangedSubview(replyUserStackView)
            inputBar.layoutStackViews([.top])
        }
        inputBar.invalidateIntrinsicContentSize()
    }

    func setReplyToComment(comment: Comment) {
        if !inputBar.inputTextView.isFirstResponder {
            inputBar.inputTextView.becomeFirstResponder()
        }

        inputBar.inputTextView.placeholder = "Write a reply..."

        let userNameString = comment.isAnonymous ? "Anonymous" : comment.creator!.fullName
        replyUserNameString.attributedText = attributedText(withString: "Replying to \(userNameString)", boldString: userNameString, font: replyUserNameString.font)
        cancelReplyButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cancelReplyButton.setSize(CGSize(width: 36, height: 36), animated: true)

        self.postCommentToReplyTo = comment.isCommentReply ? (comment.parent! as! Comment) : comment

        setUserReplyStatus(makeVisible: true)

        tableView.scrollToRow(at: getIndexOfComment(comment: comment), at: .bottom, animated: true)
    }

    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.image = UIImage(named: named)!.filled(withColor: UIColor(hexString: "#91949C")).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 40, height: 40), animated: false)
        }
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()

        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.isUserInteractionEnabled = false

        NBClient.shared.delay(1.0) {
            let newComment = Comment(text: text, owner: (self.postCommentToReplyTo as! NBModel).parent, parent: (self.postCommentToReplyTo as! NBModel), related: (self.postCommentToReplyTo as! NBModel).owner, isAnonymous: self.anonymousToggle).save()
            if newComment == nil {
                HUD.flash(.labeledError(title: "Server Error!", subtitle: "Well, this is embarrassing, something's wrong on our end."), delay: 0.5)
                return
            }
            if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                for file in self.attachmentIDs {
                    _ = Attachment(file: file, parent: newComment).save()
                }
            }

            self.attachmentIDs = []
            self.anonymousToggle = false
            self.postCommentToReplyTo = self.displayedPost
            self.cancelReplyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.cancelReplyButton.setSize(CGSize(width: 0, height: 0), animated: true)
            self.replyUserNameString.attributedText = nil
            self.setUserReplyStatus(makeVisible: false)
            inputBar.sendButton.stopAnimating()
            inputBar.inputTextView.placeholder = "Write a comment..."
            inputBar.inputTextView.isUserInteractionEnabled = true
        }
    }

    func getIndexOfComment(comment: Comment) -> IndexPath! {
        if comment.isCommentReply {
            guard let section = displayedPost.comments.index(of: comment.parent as! Comment), let row = displayedPost.comments[section].comments.index(of: comment) else {
                return nil
            }
            return IndexPath(row: row + 1, section: section + 1)
        } else {
            guard let section = self.displayedPost.comments.index(of: comment) else {
                return nil
            }
            return IndexPath(row: 0, section: section + 1)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.displayedPost.comments.count + 1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.displayedPost.comments[section-1].comments.count+1)
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

            cell.configure(post: (self.displayedPost as! Post))
            cell.delegate = self
            return cell
        } else {
            let cell = HomeFeedCommentCell.dequeue(from: tableView)!

            cell.isAccessibilityElement = false
            if indexPath.row > 0 {
                cell.accessibilityIdentifier = String(format: "HomeFeedCommentCell-Reply-DetailView-%d-%d", indexPath.section, indexPath.row)
            } else {
                cell.accessibilityIdentifier = String(format: "HomeFeedCommentCell-DetailView-%d-%d", indexPath.section, indexPath.row)
            }
            cell.accessibilityLabel = cell.accessibilityIdentifier
            cell.contentView.isAccessibilityElement = false
            cell.contentView.accessibilityIdentifier = String(format: "CommentCellContentView-DetailView-%d-%d", indexPath.section, indexPath.row)
            cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier

            let comment = indexPath.row > 0 ? self.displayedPost.comments[indexPath.section-1].comments[indexPath.row-1] : self.displayedPost.comments[indexPath.section-1]
            cell.configure(comment: comment)
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setCollectionView(dataSource: cell, delegate: cell, indexPath: indexPath)
            return cell
        }
    }
}

extension HomeFeedPostViewController {
    func isDisplayedPost(object: NBModel) -> Bool {
        if let postParent = object.getParentByType(Post.self, withSelf: true) {
            if (postParent.parent is Assignment) || (postParent.parent is Submission) || (postParent != (self.displayedPost as! NBModel)) {
                return false
            }
        }
        return true
    }
}

extension HomeFeedPostViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.section == 0 {
            return self.cellActions(isPost: (self.displayedPost is Post), vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        } else {
            return self.cellActions(isPost: false, vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        }
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        if indexPath.section == 0 {
            return self.cellActionOptions(isPost: (self.displayedPost is Post), vc: self, tableView: tableView, indexPath: indexPath, orientation: orientation)
        } else {
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
            cell.attachment = attachment
            cell.indexPath = indexPath
            cell.manager = self.attachmentManager
            cell.imageView.image = image

            if !cell.uploadStarted || cell.attachmentFileID == "" {
                cell.uploadStarted = true
                let upload = NBNetworking.shared.request(.post, url: ("https://\(baseUrl)/rpc/v1.0/files/upload"),
                                                         params: ["uuid": UIDevice().uuid],
                                                         files: ["files[]": .data("attachment.jpg", image.compressedData()!, "image/jpeg")],
                                                         loadImmediately: false,
                                                         asyncProgressHandler: { p in
                                                            DispatchQueue.main.async(execute: {
                                                                cell.imageView.uploadImage(image: image, progress: Float(p.percentageUpload))
                                                            })
                }, asyncCompletionHandler: { r in
                    let fileID = ((r.json as AnyObject).value(forKeyPath: "result") as AnyObject).value(forKeyPath: "fileId") as! String

                    cell.attachmentFileID = fileID

                    if (self.attachmentIDs.count) <= index || self.attachmentIDs.isEmpty {
                        self.attachmentIDs.append(cell.attachmentFileID)
                    } else {
                        self.attachmentIDs[index] = cell.attachmentFileID
                    }

                    DispatchQueue.main.async(execute: {
                        cell.imageView.uploadCompleted()
                    })
                })
                upload.task?.resume()
            }
            return cell
        } else {
            return self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as! AttachmentCell
        }
    }

    func setAttachmentManager(active: Bool) {
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            inputBar.layoutStackViews([.top])
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            inputBar.layoutStackViews([.top])
        }
        inputBar.invalidateIntrinsicContentSize()
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
        } else if inputBar.sendButton.isEnabled && manager.attachments.count == 0 && inputBar.inputTextView.text.isEmpty {
            inputBar.sendButton.isEnabled = false
        }
        self.attachmentIDs[index] = ""
    }
}

