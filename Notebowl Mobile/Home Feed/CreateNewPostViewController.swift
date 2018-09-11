//
//  CreateNewPostViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 4/6/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import InputBarAccessoryView
import FaceAware
import ButtonProgressBar_iOS
import ObjectMapper
import Kingfisher
import YPImagePicker
import MMUploadImage
import SocketIO
import PKHUD

class CreateNewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postTextView: PlaceholderTextView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var pickedCourseGroup: UILabel!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var fakeNavBar: UINavigationBar!
    @IBOutlet weak var fakeNavTitle: UINavigationItem!
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        return bar
    }()
    
    lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.attachmentView.accessibilityIdentifier = "AttachmentsCollectionView"
        manager.delegate = self
        manager.dataSource = self
        manager.isPersistent = true
        manager.showAddAttachmentCell = false
        manager.attachmentView.register(UploadImageAttachmentCell.self, forCellWithReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier)
        return manager
    }()
    
    var photoLibraryButton: InputBarButtonItem!
    var coursePickerButton: InputBarButtonItem!
    var anonymousButton: InputBarButtonItem!
    var pinnedButton: InputBarButtonItem!

    override var canBecomeFirstResponder: Bool {
        return true
    }

    var viewIsLoaded = false
    
    var objectsForPicker: [NBModel]!
    var selectedIndex: Int = 0
    var pickerViewValues = [[String]]()
    var pickerAlert: UIAlertController!

    var attachmentsToDelete = [String]()
    var attachmentIDs = [String]()
    var anonymousToggle: Bool = false
    var pinnedToggle: Bool = false

    var editingExisting: Bool = false
    var existingObjectToEdit: PostsComments!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        becomeFirstResponder()
        postTextView.inputAccessoryView = bar
        setupPickerValues()
        setupViews()
        setupInputBar()
        viewIsLoaded = true
    }
    
    func setupPickerValues() {
        let itemTitles = objectsForPicker.compactMap({($0 as! WithName).fullName})
        pickerViewValues = [itemTitles.map { $0 }]
    }
    
    func setupViews() {
        fakeNavBar.shadowImage = UIImage.init()
  
        userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                               options: [
                                .transition(ImageTransition.fade(0.3)),
                                .forceTransition,
                                .keepCurrentImageWhileLoading
            ]
        )
        dismissButton.image = dismissButton.image!.filled(withColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)).withRenderingMode(.alwaysOriginal)

        postTextView.delegate = self
        if editingExisting {
            postTextView.text = existingObjectToEdit.text
            postButton.title = "Edit"
            for attachment in existingObjectToEdit.attachments {
                if attachment.type.contains("image") {
                    self.attachmentIDs.append(attachment.url.absoluteString)
                    KingfisherManager.shared.retrieveImage(with: attachment.getUrlForAvatar()!.absoluteURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                        if let retrievedImage = image {
                            self.attachmentManager.handleInput(of: retrievedImage)
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postTextView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty || attachmentManager.attachments.count > 0 {
            postButton.isEnabled = true
        }
        else {
            postButton.isEnabled = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setupInputBar() {
        resetBar()
        photoLibraryButton = makeButton(image: "add_photo-vector")
        photoLibraryButton.accessibilityIdentifier = "photoLibraryButton"
        photoLibraryButton.onSelected { libButton in
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
            config.colors.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    picker.dismiss(animated: true, completion: nil)
                }
                else if !cancelled {
                    picker.dismiss(animated: true, completion: {
                    for item in items {
                        if case .photo(let photo) = item {
                            self.attachmentManager.handleInput(of: photo.image)
                        }
                    }
                    })
                }
            }
            
            if let popoverController = picker.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(picker, animated: true, completion: nil)
        }
        coursePickerButton = makeButton(image: "school-vector")
        coursePickerButton.accessibilityIdentifier = "coursePickerButton"
        coursePickerButton.configure {
            $0.isEnabled = !self.editingExisting
        }
        coursePickerButton.onSelected { courseButton in
            self.pickerAlert = UIAlertController(title: "Select a Course or Group", message: "Your post will be created in the course or group you select, and only users enrolled in that course/group will be able to see it.", preferredStyle: .actionSheet)
            
            let demoSelectedValue: PickerViewViewController.Index = (column: 0, row: self.selectedIndex)
            
            self.pickerAlert.addPickerView(values: self.pickerViewValues, initialSelection: demoSelectedValue) { vc, picker, index, values in
                self.selectedIndex = index.row
                self.pinnedButton.isHidden = (self.objectsForPicker[self.selectedIndex] is Course ? !(self.objectsForPicker[self.selectedIndex].enrollmentForUser?.role == .professor) : !(self.objectsForPicker[self.selectedIndex].enrollmentForUser?.role == .admin))
                self.pickedCourseGroup.text = ("Posting to " + (self.objectsForPicker[self.selectedIndex] as! WithName).fullName)
            }
            self.pickerAlert.addAction(title: "Done", style: .cancel)
            
            if let popoverController = self.pickerAlert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(self.pickerAlert, animated: true, completion: nil)
        }
        
        anonymousButton = makeButton(image: "visibility_on-vector")
        anonymousButton.accessibilityIdentifier = "anonymousButton"
        anonymousButton.configure {
            $0.isEnabled = !self.editingExisting
            $0.image = $0.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
        }
        anonymousButton.onSelected { anonButton in
            self.anonymousToggle.toggleValue()
            if self.anonymousToggle {
                self.postButton.width = 170
                self.postButton.title = "Post as Anonymous"
            }
            else if !self.anonymousToggle {
                self.postButton.width = 48
                self.postButton.title = "Post"
            }
            anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton = makeButton(image: "not_pinned-vector")
        pinnedButton.accessibilityIdentifier = "pinnedButton"
        pinnedButton.onSelected { pinButton in
            self.pinnedToggle.toggleValue()
            pinButton.image = self.pinnedToggle ? UIImage(named: "pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "not_pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }



        
        if editingExisting {
            self.pickedCourseGroup.isHidden = true
            self.pickedCourseGroup.text = ""

            
        }
        else {
            self.pickedCourseGroup.text = ("Posting to " + (self.objectsForPicker[self.selectedIndex] as! WithName).fullName)

            self.pinnedButton.isHidden = (self.objectsForPicker[self.selectedIndex] is Course ? !(self.objectsForPicker[self.selectedIndex].enrollmentForUser?.role == .professor) : !(self.objectsForPicker[self.selectedIndex].enrollmentForUser?.role == .admin))
        }

        bar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        if existingObjectToEdit is Post {
            bar.setStackViewItems([photoLibraryButton,coursePickerButton,InputBarButtonItem.flexibleSpace,anonymousButton,pinnedButton], forStack: .left, animated: viewIsLoaded)
        }
        else if existingObjectToEdit is Comment {
            bar.setStackViewItems([photoLibraryButton,InputBarButtonItem.flexibleSpace,anonymousButton], forStack: .left, animated: viewIsLoaded)
        }
        bar.isTranslucent = true
    }
    
    func resetBar() {
        bar.inputPlugins = [self.attachmentManager]
        
        let inputTextViewWidth = NSLayoutConstraint(item: bar.inputTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        bar.addConstraint(inputTextViewWidth)
        bar.setLeftStackViewWidthConstant(to: UIScreen.main.bounds.width, animated: false)
        bar.setRightStackViewWidthConstant(to: 0, animated: false)
        bar.textViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.topStackViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        bar.invalidateIntrinsicContentSize()
    }
    
    func makeButton(image: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: image)!.filled(withColor: (UIImage().createGradientImage(size: 70).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 36), animated: viewIsLoaded)
        }
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        self.postTextView.resignFirstResponder()
        
        HUD.show(.progress)
        NBClient.shared.delay(1.0) {
            let postText = self.postTextView.text
            if self.editingExisting {
                self.existingObjectToEdit.saveEditedObjectWithText(newText: postText!)
                
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    for file in self.attachmentIDs {
                        if !file.contains("https://") {
                            let newAttach = Attachment(file: file, parent: (self.existingObjectToEdit as! NBModel))
                            newAttach.save()
                        }
                    }
                }
                if self.attachmentsToDelete.count > 0 || !self.attachmentsToDelete.isEmpty {
                    for attach in self.attachmentsToDelete {
                        if let attachDel = self.existingObjectToEdit.attachments.first(where: {$0.url.absoluteString == attach}) {
                            self.existingObjectToEdit.attachments.removeAll(attachDel)
                            attachDel.deleteSelf()
                        }
                    }
                }
            }
            else {
                let newPost = Post(text: postText!, owner: self.objectsForPicker[self.selectedIndex], parent: self.objectsForPicker[self.selectedIndex], isAnonymous: self.anonymousToggle, pinned: (!(self.pinnedButton.isHidden) ? self.pinnedToggle : false))
                let posted = newPost.save()
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    TTLog.debug("attachment count: ", self.attachmentIDs.count)
                    for file in self.attachmentIDs {
                        if file.count > 1 {
                            TTLog.debug("uploading attachment: ", file)
                            let newAttach = Attachment(file: file, parent: posted)
                            newAttach.save()
                        }
                    }
                }
            }
            
            HUD.flash(.success, delay: 0.5)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        postTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateNewPostViewController: AttachmentManagerDelegate, AttachmentManagerDataSource {
    
    func attachmentManager(_ manager: AttachmentManager, cellFor attachment: AttachmentManager.Attachment, at index: Int) -> AttachmentCell {
        let indexPath = IndexPath(row: index, section: 0)
        let attachment = manager.attachments[indexPath.row]
    
        if case .image(let image) = attachment {
            if self.editingExisting {
                if indexPath.row < (self.existingObjectToEdit.attachments.count-self.attachmentsToDelete.count) {
                    guard let cell = self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: "ImageAttachmentCell", for: indexPath) as? ImageAttachmentCell else {
                        fatalError()
                    }
                    TTLog.debug("this is an existing attachment!")
                    cell.accessibilityIdentifier = String(format: "ImageAttachmentCell-%d", indexPath.row)
                    
                    cell.attachment = attachment
                    cell.indexPath = indexPath
                    cell.manager = manager
                    cell.imageView.image = image

                    return cell
                }
            }
            
            guard let cell = self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier, for: indexPath) as? UploadImageAttachmentCell else {
                fatalError()
            }
            cell.accessibilityIdentifier = String(format: "UploadImageAttachmentCell-%d", indexPath.row)
            
            cell.attachment = attachment
            cell.indexPath = indexPath
            cell.manager = manager
            cell.imageView.image = image

            if !cell.uploadStarted || cell.attachmentFileID == "" {
                cell.uploadStarted = true
                let upload = NBNetworking.shared.request(.post, url: ("https://\(baseUrl)/rpc/v1.0/files/upload"),
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
        if !postButton.isEnabled { postButton.isEnabled = true }
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        if manager.attachments.count == 0 && self.postTextView.isEmpty { postButton.isEnabled = false }
        
        if self.editingExisting {
            self.attachmentsToDelete.append(self.attachmentIDs[index])
        }
        if self.attachmentIDs.count >= manager.attachments.count {
            self.attachmentIDs.remove(at: index)
        }
    }
}

class UploadImageAttachmentCell: AttachmentCell {
    class var reuseIdentifier: String {
        return "UploadImageAttachmentCell"
    }
    public var attachmentFileID: String!
    public var uploadStarted: Bool = false
    public var isExistingAttachment: Bool = false
    
    open let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        attachmentFileID = ""
    }

    private func setup() {
        containerView.addSubview(imageView)
        imageView.fillSuperview()
        imageView.style = .sector
    }
}

private extension UIView {
    func fillSuperview() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
