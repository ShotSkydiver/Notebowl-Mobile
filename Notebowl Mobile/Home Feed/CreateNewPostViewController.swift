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
import ButtonProgressBar_iOS

class CreateNewPostViewController: UIViewController {

    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    @IBOutlet weak var courseForPost: UIPickerView!
    @IBOutlet weak var fakeNavBar: UINavigationBar!
    @IBOutlet weak var postButtonBarItem: PostButtonNavigationItem!
    
    var shouldShowKeyboard: Bool = false
    var currentAvatar: UIImage!
    var selectedCourse: Course!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        postTextField.delegate = self
        fakeNavBar.shadowImage = UIImage.init()
        
        userAvatar.image = currentAvatar
        userAvatar.focusOnFaces = true
        userAvatar.contentMode = .scaleAspectFill
        
        postButtonBarItem.postButton.addTarget(nil, action: #selector(self.postButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postTextField.becomeFirstResponder()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func postButtonTapped() {
        postTextField.resignFirstResponder()
        
        // self.postButtonBarItem.postButton.startIndeterminate(withTimePeriod: 3.0, andTimePadding: 1.0)
        self.postButtonBarItem.postButton.setProgress(progress: 0.0, true)
        // DispatchQueue.main.async(qos: .background, flags: []) {
        DispatchQueue.main.async {
            self.selectedCourse = NBClient.shared.getMappable(Course.self, sortBy: "updatedAt:desc", limit: "1")?.first!
            let postText = self.postTextField.text
            let jsonPayload: Any? = ["text": postText!, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.selectedCourse.url.absoluteString)", "_parent": "\(self.selectedCourse.url.absoluteString)", "isAnonymous": false, "availableDate": true, "pinned": false]
            let post = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/posts", params: ["uuid": UIDevice().uuid], json: jsonPayload)
            print("stop determinate")
            // self.postButtonBarItem.postButton.setProgress(progress: 1.0, true)
            self.postButtonBarItem.postButton.triggerCompletion()
            // self.postButtonBarItem.postButton.stopIndeterminate()
        }
        print("do dismiss")
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
        let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
        let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
        let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
        
        self.dismiss(animated: true, completion: {
            homeViewController.getPosts()
        })
        
        /*
         let alert = UIAlertController(style: .actionSheet, title: "Select a Course", message: "Your post will be created in the course you select, and only users enrolled in that course will be able to see it.")
         
         let demoValues = ["Course 1", "Course 2", "Course 3", "Course 4"]
         let pickerViewValues: [[String]] = [demoValues.map { $0.description }]
         let demoSelectedValue: PickerViewViewController.Index = (column: 0, row: 2)
         
         alert.addPickerView(values: pickerViewValues, initialSelection: demoSelectedValue) { vc, picker, index, values in
         
         }
         alert.addAction(title: "Done", style: .cancel)
         self.present(alert, animated: true, completion: nil)
         */
        
        /*
         let alert = UIAlertController(style: .actionSheet)
         alert.addTelegramPicker { selection in
         switch selection {
         case .photo(let assets):
         Log(assets)
         case .contact(let contact):
         Log(contact)
         case .location(let location):
         Log(location)
         }
         }
         alert.addAction(title: "Cancel", style: .cancel)
         self.present(alert, animated: true, completion: nil)
         */
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        postTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        postTextField.resignFirstResponder()
        
        self.selectedCourse = NBClient.shared.getMappable(Course.self, sortBy: "updatedAt:desc", limit: "1")?.first!
        let postText = self.postTextField.text
        let jsonPayload: Any? = ["text": postText!, "_creator": "\(NBClient.shared.getCurrentUser().url.absoluteString)", "_owner": "\(self.selectedCourse.url.absoluteString)", "_parent": "\(self.selectedCourse.url.absoluteString)", "isAnonymous": false, "availableDate": true, "pinned": false]
        let post = Just.post("https://\(NBClient.shared.baseUrl)/api/v1.0/posts", params: ["uuid": UIDevice().uuid], json: jsonPayload)
        
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
        let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
        let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
        let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
        
        self.dismiss(animated: true, completion: {
            homeViewController.getPosts()
        })
    }
    
}

class PostButtonNavigationItem: UIBarButtonItem {
    
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 32))
    public let postButton = ButtonProgressBar(frame: CGRect(x: 0, y: 0, width: 90, height: 32))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        postButton.setTitle("Post", for: .normal)
        postButton.setCompletionImage(image: UIImage(named: "checkmark")!)
        
        logoContainer.addSubview(postButton)
        
        self.customView = logoContainer
    }
}

extension CreateNewPostViewController: UITextFieldDelegate {
    
}
