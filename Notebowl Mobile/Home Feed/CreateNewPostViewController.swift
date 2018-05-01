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
import Photos
import PhotosUI
import ButtonProgressBar_iOS
import RLBAlertsPickers
import ObjectMapper
import Kingfisher

class CreateNewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postTextView: PlaceholderTextView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var fakeNavBar: UINavigationBar!
    @IBOutlet weak var postButtonBarItem: PostButtonNavigationItem!
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        // bar.delegate = self
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
    
    /*
    override var inputAccessoryView: UIView? {
        return bar
    }
    */
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
        
        // userAvatar.image = currentAvatar
        // userAvatar.focusOnFaces = true
        // userAvatar.contentMode = .scaleAspectFill
        
        dismissButton.image = dismissButton.image!.filled(withColor: (UIImage().createGradientImage(size: 35).gradientColor)).withRenderingMode(.alwaysOriginal)
        
        postTextView.delegate = self
        postButtonBarItem.postButton.addTarget(nil, action: #selector(self.postButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TTLog.debug("didappear")
        super.viewDidAppear(animated)
        postTextView.becomeFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        TTLog.debug("shouldbeginediting")
        // textView.inputAccessoryView = bar
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        TTLog.debug("didbeginediting")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        TTLog.debug("didendediting")
    }
    func textViewDidChange(_ textView: UITextView) {
        TTLog.debug("didchange")
        // self.cameraButton.isEnabled = textView.text.isEmpty
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func setupInputBar() {
        TTLog.debug("setupinputbar")
        bar.inputManagers = [attachmentManager]
        // reloadInputViews()
        
        let inputTextViewWidth = NSLayoutConstraint(item: bar.inputTextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        bar.addConstraint(inputTextViewWidth)
        bar.setLeftStackViewWidthConstant(to: UIScreen.main.bounds.width, animated: false)
        bar.setRightStackViewWidthConstant(to: 0, animated: false)
        bar.textViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.topStackViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        
        bar.invalidateIntrinsicContentSize()
        
        
        photoLibraryButton = makeButton(image: "add_library-vector")
        photoLibraryButton.onSelected { libButton in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        cameraButton = makeButton(image: "add_photo-vector")
        cameraButton.onSelected { camButton in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        coursePickerButton = makeButton(image: "school-vector")
        coursePickerButton.onSelected { courseButton in
            let alert = UIAlertController(style: .actionSheet, title: "Select a Course", message: "Your post will be created in the course you select, and only users enrolled in that course will be able to see it.")
            
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
            self.present(alert, animated: true, completion: nil)
        }
        
        anonymousButton = makeButton(image: "public-vector")
        anonymousButton.onSelected { anonButton in
            self.anonymousToggle.toggle()
            anonButton.image = self.anonymousToggle ? anonButton.image!.filled(withColor: .darkGray).withRenderingMode(.alwaysOriginal) : anonButton.image!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton = makeButton(image: "pin-vector")
        pinnedButton.onSelected { pinButton in
            self.pinnedToggle.toggle()
            pinButton.image = self.pinnedToggle ? UIImage(named: "unpin-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal) : UIImage(named: "pin-vector")!.filled(withColor: (UIImage().createGradientImage(size: 50).gradientColor)).withRenderingMode(.alwaysOriginal)
        }
        pinnedButton.isEnabled = (selectedCourse.enrollmentForUser?.role.contains("Professor"))!
        
        // bar.setLeftStackViewWidthConstant(to: 58, animated: viewIsLoaded)
        // bar.setRightStackViewWidthConstant(to: 38, animated: viewIsLoaded)
        
        bar.setStackViewItems([photoLibraryButton,cameraButton,InputBarButtonItem.flexibleSpace,coursePickerButton,anonymousButton,pinnedButton], forStack: .left, animated: viewIsLoaded)
        // bar.setStackViewItems([bar.sendButton,InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: viewIsLoaded)
        
        bar.isTranslucent = true
    }
    
    func makeButton(image: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: image)!.filled(withColor: (UIImage().createGradientImage(size: 70).gradientColor)).withRenderingMode(.alwaysOriginal)
                $0.setSize(CGSize(width: 30, height: 30), animated: viewIsLoaded)
                // $0.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
                
        }
    }
    
    func imageFromAsset(asset: PHAsset) -> UIImage? {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var theImage: UIImage?
        
        options.isSynchronous = true
        // options.deliveryMode = .highQualityFormat
        options.version = .original
        
        manager.requestImageData(for: asset, options: options) { (imageData, someString, imageOrientation, imageInfo) in
            TTLog.debug("requestimagedata result: ", imageInfo)
            if let data = imageData {
                theImage = UIImage(data: data)
            }
        }
        return theImage
    }
    
    
    @objc func postButtonTapped() {
        postTextView.resignFirstResponder()
        TTLog.debug("begin postbuttontapped")
        self.postButtonBarItem.postButton.startIndeterminate()
        // self.postButtonBarItem.postButton.setProgress(progress: 0.0, true)
        DispatchQueue.main.async(qos: .background, flags: []) {
            TTLog.debug("start qos async")
        // DispatchQueue.main.async {
            let postText = self.postTextView.text
            let jsonPayload: Any? = ["text": postText!, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.selectedCourse.url.absoluteString)", "_parent": "\(self.selectedCourse.url.absoluteString)", "isAnonymous": self.anonymousToggle, "availableDate": true, "pinned": ((self.selectedCourse.enrollmentForUser?.role.contains("Professor"))! ? self.pinnedToggle :  false)]
            let post = Just.post("https://\(NBClient.baseUrl)/api/v1.0/posts", params: ["uuid": UIDevice().uuid], json: jsonPayload)
            let finalmap = Mapper<Post>().map(JSONObject: (post.json as AnyObject).value(forKeyPath: "result")!)!
            
            if self.attachmentManager.attachments.count > 0 {
                let jsonAttPayload: Any? = ["fileId": self.attachmentFileId, "_parent": "\(finalmap.url.absoluteString)", "attachmentType": "S3", "attachmentName": "image.jpg"]
                let attachment = Just.post("https://\(NBClient.baseUrl)/api/v1.0/attachments", params: ["uuid": UIDevice().uuid], json: jsonAttPayload)
            }
     
            DispatchQueue.main.async {
                TTLog.debug("start nested async")
                self.postButtonBarItem.postButton.triggerCompletion()
            }
        }
        
        TTLog.debug("do dismiss")
        /*
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
        let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
        let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
        let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
        */
        self.dismiss(animated: true, completion: {
            // self.postTextView.resignFirstResponder()
            // homeViewController.getPosts()
        })
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        postTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        TTLog.debug("finishpickingmedia")
    
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                TTLog.debug("imagepicker dismissed")
                self.attachmentManager.handleInput(of: pickedImage)
                
                
                
            }
        })
    }
}

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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
        
    }

    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        // self.postButtonBarItem.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        // self.postButtonBarItem.isEnabled = manager.attachments.count > 0
        switch attachment {
        case .image(let image):
            self.postButtonBarItem.postButton.startIndeterminate(withTimePeriod: 0.7, andTimePadding: 0.2)
            DispatchQueue.main.async {
                self.attachmentFileId = (NBClient.shared.uploadToFiles(attachment: image))
                
                // self.postButtonBarItem.postButton.setProgress(progress: 1.0, true)
                self.postButtonBarItem.postButton.triggerCompletion()
                // self.postButtonBarItem.postButton.stopIndeterminate()
                // self.postButtonBarItem.postButton.resetProgress()
            }
        default:
            print("nope")
        }
        
        
        
        
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        // self.postButtonBarItem.isEnabled = manager.attachments.count > 0
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

