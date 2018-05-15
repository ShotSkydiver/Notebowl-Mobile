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

class CreateNewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postTextView: PlaceholderTextView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var fakeNavBar: UINavigationBar!
    @IBOutlet weak var postButtonBarItem: PostButtonNavigationItem!
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        return bar
    }()
    
    lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.delegate = self
        manager.isPersistent = false
        manager.showAddAttachmentCell = false
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
    var currentAvatar: UIImage!
    var coursesForPicker: [Course]!
    var selectedCourse: Course!
    var attachmentFileId: String!
    var anonymousToggle: Bool = false
    var pinnedToggle: Bool = false
    var showingPhotoPicker: Bool = false
    
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
            
            /*
            if existingCell.postAttachments != nil || existingCell.heightConst.constant != 0 {
                attachmentManager.handleInput(of: existingCell.postAttachments.image!)
            }
            */
            //if existingPostToEdit.postAttachments.count > 0 {
                //for attachment in existingPostToEdit.postAttachments {
                    //attachmentManager.handleInput(of: )
                //}
            //}
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
    
    func uploadImage(image: UIImage) {
        Just.post(("https://\(NBClient.baseUrl)/rpc/v1.0/files/upload"),
                  params: ["uuid": UIDevice().uuid],
                  files:["files[]":.data("attachment.jpg", image.compressedData()!, "image/jpeg")],
                  asyncProgressHandler:{ p in
                    print(p.percent)
                    DispatchQueue.main.async(execute: {
                        self.postButtonBarItem.postButton.setProgress(progress: CGFloat(p.percent), true)
                    })
        }){ r in
            print(r.ok)
            
            let res = (r.json as AnyObject).value(forKeyPath: "result")
            let fileid = (res as AnyObject).value(forKeyPath: "fileId") as! String
            self.attachmentFileId = fileid
            DispatchQueue.main.async(execute: {
                self.postButtonBarItem.postButton.triggerCompletion()
                self.postButtonBarItem.postButton.resetProgress()
            })
        }
    }
    
    func setupInputBar() {
        bar.inputManagers = [attachmentManager]

        let inputTextViewWidth = NSLayoutConstraint(item: bar.inputTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        bar.addConstraint(inputTextViewWidth)
        bar.setLeftStackViewWidthConstant(to: UIScreen.main.bounds.width, animated: false)
        bar.setRightStackViewWidthConstant(to: 0, animated: false)
        bar.textViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.topStackViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        bar.invalidateIntrinsicContentSize()
        
        photoLibraryButton = makeButton(image: "add_photo-vector")
        photoLibraryButton.onSelected { libButton in
            var config = YPImagePickerConfiguration()
            config.libraryTargetImageSize = .cappedTo(size: 1024)
            config.albumName = "Notebowl Photos"
            config.startOnScreen = .library
            config.showsCrop = .none
            config.wordings.libraryTitle = "Gallery"
            config.hidesStatusBar = false
            config.showsFilters = false
            config.maxNumberOfItems = 10
            config.icons.capturePhotoImage = UIImage(named: "open_camera-vector")!
            config.icons.cropIcon = UIImage(named: "crop-vector")!
            config.colors.navigationBarTextColor = .darkGray
            config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking(completion: { (items, cancelled) in
                if cancelled {
                    TTLog.debug("cancelled")
                    picker.dismiss(animated: true, completion: nil)
                }
                else if !cancelled {
                    /*
                    for item in items {
                        if case .photo(let photo) = item {
                            self.attachmentManager.handleInput(of: photo.image)
                            
                        }
                    }
                    */
                    let item = items.first!
                    switch item {
                    case .photo(let photo):
                        self.attachmentManager.handleInput(of: photo.image)
                        picker.dismiss(animated: true, completion: {
                            self.uploadImage(image: photo.image)
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
        }
        coursePickerButton = makeButton(image: "school-vector")
        coursePickerButton.configure {
            $0.isEnabled = !self.editingExistingPost
        }
        coursePickerButton.onSelected { courseButton in
            let alert = UIAlertController(title: "Select a Course", message: "Your post will be created in the course you select, and only users enrolled in that course will be able to see it.", preferredStyle: .actionSheet)
            
            var pickerValues = [String: Course]()
            for course in self.coursesForPicker {
                pickerValues[course.courseFullName] = course
            }
            let demoValues = pickerValues.keys
            let keysArray = Array(demoValues)
            let pickerViewValues: [[String]] = [keysArray.map { $0.description }]
            let demoSelectedValue: PickerViewViewController.Index = (column: 0, row: 2)

            alert.addPickerView(values: pickerViewValues, initialSelection: demoSelectedValue) { vc, picker, index, values in
                let selectedItem = values[index.column][index.row]
                print("picker item selected: ", selectedItem)
                self.selectedCourse = pickerValues[selectedItem]
                self.pinnedButton.isEnabled = (self.selectedCourse.enrollmentForUser?.role.contains("Professor"))!
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
            //anonButton.image = self.anonymousToggle ? UIImage(named: "visibility_off-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "visibility_on-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton = makeButton(image: "not_pinned-vector")
        pinnedButton.onSelected { pinButton in
            self.pinnedToggle.toggle()
            pinButton.image = self.pinnedToggle ? UIImage(named: "pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "not_pinned-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton.isEnabled = (selectedCourse.enrollmentForUser?.role.contains("Professor"))!
        
        bar.setStackViewItems([photoLibraryButton,coursePickerButton,InputBarButtonItem.flexibleSpace,anonymousButton,pinnedButton], forStack: .left, animated: viewIsLoaded)
        
        bar.isTranslucent = true
    }
    
    func makeButton(image: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: image)!.filled(withColor: (UIImage().createGradientImage(size: 70).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 30), animated: viewIsLoaded)
        }
    }
    
    @objc func postButtonTapped() {
        self.postButtonBarItem.postButton.startIndeterminate()
        DispatchQueue.main.async {
            let postText = self.postTextView.text
            var jsonPayload: Any?
            if self.editingExistingPost {
                jsonPayload = ["text": postText!]
                let putReq = getUrl(self.existingPostToEdit.url.absoluteString, method: .put, json: jsonPayload)
                
            }
            else {
                jsonPayload = ["text": postText!, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.selectedCourse.url.absoluteString)", "_parent": "\(self.selectedCourse.url.absoluteString)", "isAnonymous": self.anonymousToggle, "availableDate": true, "pinned": ((self.selectedCourse.enrollmentForUser?.role.contains("Professor"))! ? self.pinnedToggle :  false)]
                let postReq = getUrl(Post.endpoint, method: .post, json: jsonPayload)
                let finalmap = Mapper<Post>().map(JSONObject: (postReq.json as AnyObject).value(forKeyPath: "result")!)!
                if self.attachmentManager.attachments.count > 0 {
                    let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
                    let attReq = getUrl(Attachment.endpoint, method: .post, json: jsonAttPayload)
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
/*
extension CreateNewPostViewController: YPImagePickerDelegate {
    func imagePicker(_ imagePicker: YPImagePicker, didSelect items: [YPMediaItem]) {
        let item = items.first!
        switch item {
        case .photo(let photo):
            self.attachmentManager.handleInput(of: photo.image)
            imagePicker.dismiss(animated: true, completion: {
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
*/
extension CreateNewPostViewController: AttachmentManagerDelegate {
    
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
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        /*
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        */
    }
    
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }

    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        // self.postButtonBarItem.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        self.photoLibraryButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        self.photoLibraryButton.isEnabled = manager.attachments.count > 0
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
        // postButton.setBackgroundColor(color: UIImage().createGradientImage(size: 110).gradientColor)
        postButton.setProgressColor(color: #colorLiteral(red: 0.2039999962, green: 0.2820000052, blue: 0.3650000095, alpha: 1))
        postButton.setCompletionImage(image: UIImage(named: "checkmark")!)
        
        logoContainer.addSubview(postButton)
        
        self.customView = logoContainer
    }
}

