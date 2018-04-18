//
//  HomeFeedPostViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/15/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import AyLoading
import InputBarAccessoryView
import ObjectMapper

class HomeFeedPostViewController: UITableViewController, InputBarAccessoryViewDelegate {

    var post: Post!
    var currentIndex: IndexPath!
    var comments: [Comment]!
    var anonymousToggle: Bool = false
    var viewIsLoaded = false
    var attachmentFileId: String!
    
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
        
        // self.comments = self.post.postComments
        self.comments = NBClient.shared.storedTypes[Comment.classIdentifier]?.filter({ ($0 as! Comment).parent == self.post.url }) as! [Comment]
        
        for comment in self.comments {
            if !comment.updatedOnce {
                print("comment not updated once")
                comment.getAttachments()
                comment.updateLikes()
                //comment.updatedOnce = true
            }
            else {
                print("comment updatedonce")
            }
        }
        
        HomeFeedPostCell.register(in: self.tableView)
        HomeFeedCommentCell.register(in: self.tableView)
        
        setupInputBar()
        
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        viewIsLoaded = true
    }
    
    func setupInputBar() {
        resetInput()
        
        let items = [
            makeButton(named: "camera").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
                }.onSelected {
                    $0.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            },
            makeButton(named: "picture")
                .onSelected {
                    $0.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            },
            .flexibleSpace,
            makeButton(named: "invisible")
                .onTouchUpInside { _ in
                    self.anonymousToggle.toggle()
                }.onSelected {
                    $0.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                }.onDeselected {
                    $0.tintColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
                }.onKeyboardEditingBegins { (button) in
                    TTLog.debug("keyboardediting began")
                
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
                    $0.backgroundColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
    
        ]
        items.forEach { $0.tintColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1) }
        
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // expand button
        
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)
    }
    
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 26, height: 26), animated: viewIsLoaded)
            }.onSelected {
                $0.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            }.onDeselected {
                $0.tintColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            }.onTouchUpInside { _ in
                TTLog.debug("tapped")
        }
    }
    
    

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let jsonPayload: Any? = ["text": text, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.post.owner!.url.absoluteString)", "_parent": "\(self.post.url.absoluteString)", "isAnonymous": self.anonymousToggle]
        let post = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/comments", params: ["uuid": UIDevice().uuid], json: jsonPayload)
        
        let finalmap = Mapper<Comment>().map(JSONObject: (post.json as AnyObject).value(forKeyPath: "result")!)!
        NBClient.shared.storedTypes[Comment.classIdentifier]?.append(finalmap)
        
        let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
        let attachment = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/attachments", params: ["uuid": UIDevice().uuid], json: jsonAttPayload)
        
        let finalmapAtt = Mapper<Attachment>().map(JSONObject: (attachment.json as AnyObject).value(forKeyPath: "result")!)!
        NBClient.shared.storedTypes[Attachment.classIdentifier]?.append(finalmapAtt)
        
        finalmap.getAttachments()
        finalmap.updateLikes()
        
        // self.comments.append(finalmap)
        self.post.refresh()
        self.comments = self.post.postComments
    
        inputBar.inputTextView.text = String()
        if #available(iOS 11.0, *) {
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 1)], with: .fade)
            }) { (_) in
                TTLog.debug("updates complete")
            }
        }
        else {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 1)], with: .fade)
            tableView.endUpdates()
        }
        
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
        return section == 0 ? 1 : self.comments.count
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
            cell.configure(comment: self.comments[indexPath.row])
            return cell
        }
        
    }
}

extension HomeFeedPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
