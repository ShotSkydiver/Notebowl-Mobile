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

class CreateNewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postTextView: PlaceholderTextView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var fakeNavBar: UINavigationBar!
    @IBOutlet weak var fakeNavTitle: UINavigationItem!
    @IBOutlet weak var postButtonBarItem: PostButtonNavigationItem!
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        return bar
    }()
    
    lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.delegate = self
        manager.dataSource = self
        manager.isPersistent = true
        manager.showAddAttachmentCell = false
        manager.attachmentView.register(UploadImageAttachmentCell.self, forCellWithReuseIdentifier: UploadImageAttachmentCell.reuseIdentifier)
        return manager
    }()
    
    var photoLibraryButton: InputBarButtonItem!
    var cameraButton: InputBarButtonItem!
    var coursePickerButton: InputBarButtonItem!
    var anonymousButton: InputBarButtonItem!
    var pinnedButton: InputBarButtonItem!

    override var canBecomeFirstResponder: Bool {
        return true
    }

    var viewIsLoaded = false
    var objectsForPicker: [NBModel]!
    var selectedObject: NBModel!
    var selectedIndex: Int = 0
    var attachmentIDs = [String]()
    var anonymousToggle: Bool = false
    var pinnedToggle: Bool = false
    
    var editingExistingPost: Bool = false
    var existingPostToEdit: Post!
    var existingCell: HomeFeedPostCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        becomeFirstResponder()
        postTextView.inputAccessoryView = bar
        setupViews()
        setupInputBar()
        viewIsLoaded = true
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
        dismissButton.image = dismissButton.image!.filled(withColor: (UIImage().createGradientImage(size: 35).gradientColor)).withRenderingMode(.alwaysOriginal)

        postTextView.delegate = self
        if editingExistingPost {
            postTextView.text = existingPostToEdit.text!
            postButtonBarItem.postButton.setTitle("Edit", for: .normal)
            for attachment in existingPostToEdit.postAttachments {
                if attachment.type.contains("image") {
                    KingfisherManager.shared.retrieveImage(with: attachment.getUrlForAvatar()!.absoluteURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                        if let retrievedImage = image {
                            self.attachmentManager.handleInput(of: retrievedImage)
                        }
                    })
                    
                }
                
            }
            
        }
        
        postButtonBarItem.postButton.addTarget(nil, action: #selector(self.postButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postTextView.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setupInputBar() {
        resetBar()
        photoLibraryButton = makeButton(image: "add_photo-vector")
        photoLibraryButton.onSelected { libButton in
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
        coursePickerButton = makeButton(image: "school-vector")
        coursePickerButton.configure {
            $0.isEnabled = !self.editingExistingPost
        }
        coursePickerButton.onSelected { courseButton in
            let alert = UIAlertController(title: "Select a Course or Group", message: "Your post will be created in the course/group you select, and only users enrolled in that course/group will be able to see it.", preferredStyle: .actionSheet)
            
            var pickerValues = [String: NBModel]()
            for object in self.objectsForPicker {
                print("object: ", object.url)
                if object is Course {
                    pickerValues[(object as! Course).courseFullName] = object
                    
                }
                else if object is Group {
                    pickerValues[("Group: " + (object as! Group).name)] = object
                }
            }

            let demoValues = pickerValues.keys
            let keysArray = Array(demoValues)
            let pickerViewValues: [[String]] = [keysArray.map { $0.description }]
            
            let demoSelectedValue: PickerViewViewController.Index = (column: 0, row: self.selectedIndex)
            
            alert.addPickerView(values: pickerViewValues, initialSelection: demoSelectedValue) { vc, picker, index, values in
                let selectedItem = values[index.column][index.row]
                print("picker item selected: ", selectedItem)
                self.selectedObject = pickerValues[selectedItem]
                self.selectedIndex = index.row
                if self.selectedObject is Course {
                    self.pinnedButton.isEnabled = (self.selectedObject as! Course).enrollmentForUser?.role == .professor
                    self.fakeNavTitle.title = (self.selectedObject as! Course).courseFullName
                }
                else if self.selectedObject is Group {
                    self.pinnedButton.isEnabled = (self.selectedObject as! Group).enrollmentForUser?.role == .admin
                    self.fakeNavTitle.title = (self.selectedObject as! Group).name
                }
            }
            alert.addAction(title: "Done", style: .cancel)
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
        anonymousButton = makeButton(image: "visibility_on-vector")
        anonymousButton.configure {
            $0.isEnabled = !self.editingExistingPost
            $0.image = $0.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
        }
        anonymousButton.onSelected { anonButton in
            self.anonymousToggle.toggle()
            anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 40).gradientColor)).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton = makeButton(image: "not_pinned-vector")
        pinnedButton.onSelected { pinButton in
            self.pinnedToggle.toggle()
            pinButton.image = self.pinnedToggle ? UIImage(named: "pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "not_pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }
        if self.selectedObject is Course {
            self.pinnedButton.isEnabled = (self.selectedObject as! Course).enrollmentForUser?.role == .professor
            self.fakeNavTitle.title = (self.selectedObject as! Course).courseFullName
        }
        else if self.selectedObject is Group {
            self.pinnedButton.isEnabled = (self.selectedObject as! Group).enrollmentForUser?.role == .admin
            self.fakeNavTitle.title = (self.selectedObject as! Group).name
        }
        
        bar.separatorLine.backgroundColor = UIColor.groupTableViewBackground
        bar.setStackViewItems([photoLibraryButton,coursePickerButton,InputBarButtonItem.flexibleSpace,anonymousButton,pinnedButton], forStack: .left, animated: viewIsLoaded)
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
    
    @objc func postButtonTapped() {
        self.postButtonBarItem.postButton.startIndeterminate()
        DispatchQueue.main.async {
            let postText = self.postTextView.text
            var jsonPayload: Any?
            if self.editingExistingPost {
                jsonPayload = ["text": postText!]
                let putReq = NBNetworking.shared.request(.put, url: self.existingPostToEdit.url.absoluteString, json: jsonPayload)
                
                if self.attachmentIDs.count > 0 || !self.attachmentIDs.isEmpty {
                    TTLog.debug("attachment count: ", self.attachmentIDs.count)
                    for file in self.attachmentIDs {
                        TTLog.debug("uploading attachment: ", file)
                        let jsonAttPayload: Any? = ["fileId": file, "_parent": "\(self.existingPostToEdit.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
                        let attReq = NBNetworking.shared.request(.post, url: Attachment.endpoint, json: jsonAttPayload)
                    }
                }
            }
            else {
                
                jsonPayload = ["text": postText!, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.selectedObject.url.absoluteString)", "_parent": "\(self.selectedObject.url.absoluteString)", "_related": "\(self.selectedObject.url.absoluteString)", "isAnonymous": self.anonymousToggle, "availableDate": true, "pinned": ((self.pinnedButton.isEnabled) ? self.pinnedToggle :  false)]
                let postReq = NBNetworking.shared.request(.post, url: Post.endpoint, json: jsonPayload)
                let finalmap = Mapper<Post>().map(JSONObject: (postReq.json as AnyObject).value(forKeyPath: "result")!)!
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
                self.postButtonBarItem.postButton.triggerCompletion()
                self.postTextView.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
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
            
            if self.editingExistingPost {

                if indexPath.row < self.existingPostToEdit.postAttachments.count {
                    guard let cell = self.attachmentManager.attachmentView.dequeueReusableCell(withReuseIdentifier: "ImageAttachmentCell", for: indexPath) as? ImageAttachmentCell else {
                        fatalError()
                    }
                    TTLog.debug("this is an existing attachment!")
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
            TTLog.debug("cellfor attachment")
            cell.attachment = attachment
            cell.indexPath = indexPath
            cell.manager = manager
            cell.imageView.image = image

            if !cell.uploadStarted {

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
                    self.attachmentIDs.append(cell.attachmentFileID)
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
    }
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        TTLog.debug("manager didremove")
        if self.editingExistingPost {
            let deletedAttachment = self.existingPostToEdit.postAttachments.remove(at: index)
            let delete = NBNetworking.shared.request(.delete, url: deletedAttachment.url.absoluteString)
            TTLog.warning("delete url request: ", delete.description)
        }
        
    }
}

class PostButtonNavigationItem: UIBarButtonItem {
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 78, height: 34))
    public let postButton = ButtonProgressBar(frame: CGRect(x: 0, y: 0, width: 78, height: 34))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        postButton.setBackgroundImage(UIImage().createGradientImage(size: 170), for: .normal)
        postButton.setProgressColor(color: #colorLiteral(red: 0.2039999962, green: 0.2820000052, blue: 0.3650000095, alpha: 1))
        postButton.setCompletionImage(image: UIImage(named: "checkmark")!)
        
        logoContainer.addSubview(postButton)
        self.customView = logoContainer
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
