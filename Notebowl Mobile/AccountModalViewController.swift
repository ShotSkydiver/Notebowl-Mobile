//
//  AccountModalViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Photos
import DeckTransition
import Kingfisher
import MMUploadImage
import FaceAware

protocol ContainerToMaster {
    func startUpload(image:UIImage)
    func uploadingImage()
}

class AccountModalViewController: UIViewController, ContainerToMaster {
    //var currentUser: User!
    
    @IBOutlet weak var profilePicture: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    var containerViewController: AccountModalTableViewController?
    var menu: UIAlertController!
    var dismissWithUpdate: Bool = false
    var progress: Float = 0.0
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        self.setNeedsStatusBarAppearanceUpdate()
        
        //currentUser = NBClient.shared.getCurrentUser()
        updateInfo()
 
        profilePicture.style = .wave
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalEmbedSegue" {
            containerViewController = segue.destination as? AccountModalTableViewController
            containerViewController!.containerToMaster = self
        }
    }
    
    func updateInfo() {
        doneButton.tintColor = UIImage().createGradientImage(size: 50).gradientColor
        
        //profilePicture.layer.cornerRadius = profilePicture.frame.width*0.5
        //profilePicture.clipsToBounds = true
        //profilePicture.layer.masksToBounds = true

        profilePicture.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .forceTransition,
                                    .keepCurrentImageWhileLoading
            ]
        )
        
        // profilePicture.image = NBClient.shared.currentUserPic
        ///profilePicture.focusOnFaces = true
        profilePicture.contentMode = .scaleAspectFill

        userName.text = NBClient.shared.getCurrentUser().fullName
        userEmail.text = NBClient.shared.getCurrentUser().email
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func done(_ sender: Any) {
        if dismissWithUpdate {
            /*
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
            let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
            let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
            */
            self.dismiss(animated: true, completion: {
                //homeViewController.getPosts()
            })
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func startUpload(image: UIImage) {
        self.progress = 0.1
        self.selectedImage = image
        self.profilePicture.uploadImage(image: selectedImage, progress: progress)
    }
    
    public func uploadingImage() {
        let postUrl = ("https://\(NBClient.baseUrl)/rpc/v1.0/users/" + NBClient.shared.getCurrentUser().resourceKey + "/changeProfilePicture")
        
        Just.post(postUrl,
                  params: ["uuid": UIDevice().uuid],
                  files:["files[]":.data("profile.jpg", self.selectedImage.compressedData()!, "image/jpeg")],
                  asyncProgressHandler:{ p in
                    print(p.percent)
                    DispatchQueue.main.async(execute: {
                        // self.progress = (self.progress + p.percent <= 1.0) ? self.progress + p.percent : 1.0
                        // if p.percent < 1.0 {
                            self.profilePicture.uploadImage(image: self.selectedImage, progress: p.percent)
                        // }
                        // else if p.percent == 1.0 {
                            // self.profilePicture.uploadCompleted()
                        // }
                    })
                    
        }){ r in
            print(r.ok)
            self.profilePicture.uploadCompleted()
        }
        
    }
}

class AccountModalTableViewController: UITableViewController {
    var containerToMaster: ContainerToMaster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupMenuForAlert() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //PHPhotoLibrary.requestAuthorization({ (auth) in
        //    TTLog.debug("authstatus: ", auth)
        //})
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else { return }
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        menu.addAction(takePhoto)
        menu.addAction(choosePhoto)
        menu.addAction(removePhoto)
        menu.addAction(cancel)
        
        self.present(menu, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cell.reuseIdentifier == "changeProfileCell" {
            setupMenuForAlert()
        }
        else if cell.reuseIdentifier == "logoutCell" {
            NBClient.shared.logoutUser()
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            rootViewController.dismiss(animated: true, completion: nil)
        }
        else if cell.reuseIdentifier == "appearanceCell" {
            let urlObj = NSURL.init(string:UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(urlObj! as URL, options: [ : ], completionHandler: { Success in
                })
        }
        else {
            let alert = UIAlertController(title: "Under Construction", message: "This view hasn't been implemented yet!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension AccountModalTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.containerToMaster?.startUpload(image: pickedImage)
            }
        // })
        picker.dismiss(animated: true, completion: {
            self.containerToMaster?.uploadingImage()
        })
        
    }
}
