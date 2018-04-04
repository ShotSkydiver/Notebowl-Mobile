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
import Disk
import FaceAware
import TLPhotoPicker

protocol ContainerToMaster {
    func uploadImage(image:UIImage)
}

class AccountModalViewController: UIViewController, ContainerToMaster {
    var currentUser: User!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    var containerViewController: AccountModalTableViewController?
    var newImage: UIImage!
    var menu: UIAlertController!
    var dismissWithUpdate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
   
        currentUser = NBClient.shared.getCurrentUser()
        updateInfo()
        
        profilePicture.completedBlock = {
            print("completedblock")
            self.dismissWithUpdate = true
            
            NBClient.shared.updateUserAvatar(image: self.newImage)
            
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
            let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
            let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
            
            homeViewController.navbarImageView.image = self.newImage
            
        }
        profilePicture.failBlock = {
            print("failed")
        }
        profilePicture.style = .sector
        profilePicture.autoCompleted = true
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalEmbedSegue" {
            containerViewController = segue.destination as? AccountModalTableViewController
            containerViewController!.containerToMaster = self
        }
    }
    
    func updateInfo() {
        profilePicture.layer.cornerRadius = profilePicture.frame.width*0.5
        profilePicture.clipsToBounds = true
        profilePicture.layer.masksToBounds = true

        profilePicture.image = NBClient.shared.currentUserPic
        profilePicture.focusOnFaces = true

        userName.text = currentUser.fullName
        userEmail.text = currentUser.email
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func done(_ sender: Any) {
        if dismissWithUpdate {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            let tabbarViewController = rootViewController.presentedViewController as! MainTabBarViewController
            let homeNavViewController = tabbarViewController.selectedViewController as! UINavigationController
            let homeViewController = homeNavViewController.viewControllers[0] as! HomeFeedViewController
            
            self.dismiss(animated: true, completion: {
                homeViewController.getPosts()
            })
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    public func uploadImage(image: UIImage) {
        self.newImage = image
        
        let postUrl = ("https://\(NBClient.shared.baseUrl)/rpc/v1.0/users/" + self.currentUser.resourceKey + "/changeProfilePicture")
        _ = Just.post(
            postUrl,
            params: ["uuid": UIDevice().uuid],
            files:["files[]":.data("profile.jpg", image.compressedData()!, "image/jpeg")],
            asyncProgressHandler: { p in
                print("progress: ", p.percent)
                
                self.profilePicture.uploadImage(image: image, progress: p.percent)
                
        }
        ) { r in
            if r.ok {
                print("OK!")
                // self.profilePicture.uploadCompleted()
            }
            else {
                // self.profilePicture.uploadImageFail()
            }
        }
    }
}

class AccountModalTableViewController: UITableViewController, TLPhotosPickerViewControllerDelegate {
    var selectedAssets = [TLPHAsset]()
    var containerToMaster: ContainerToMaster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupMenuForAlert() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        PHPhotoLibrary.requestAuthorization({ (auth) in
            print("authstatus: ", auth)
        })
        
        // let imagePicker = UIImagePickerController()
        // imagePicker.delegate = self
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            /*
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
            */
            
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            /*
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            */
            
        }
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        menu.addAction(takePhoto)
        menu.addAction(choosePhoto)
        // menu.addAction(removePhoto)
        menu.addAction(cancel)
        
        self.present(menu, animated: true, completion: nil)
    }
    
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "No camera permissions!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Denied album permissions!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        self.selectedAssets = withTLPHAssets
        
        if let asset = self.selectedAssets.first {
            if let image = asset.fullResolutionImage {
                self.containerToMaster?.uploadImage(image: image)
            }
            else {
                asset.cloudImageDownload(progressBlock: { (progress) in
                    print("download from cloud progress: ", progress)
                    
                }, completionBlock: { (image) in
                    if let image = image {
                        self.containerToMaster?.uploadImage(image: image)
                    }
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cell.reuseIdentifier == "changeProfileCell" {
            // setupMenuForAlert()
            let vc = TLPhotosPickerViewController()
            vc.delegate = self
            var config = TLPhotosPickerConfigure()
            if #available(iOS 10.2, *) {
                config.cameraCellNibSet = (nibName: "CustomCameraCell", bundle: Bundle.main)
            }
            config.allowedLivePhotos = false
            
            config.numberOfColumn = 3
            config.allowedVideo = false
            config.allowedVideoRecording = false
            config.singleSelectedMode = true
            config.maxSelectedAssets = 1
            config.selectedColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
            vc.configure = config
            self.present(vc, animated: true, completion: nil)
        }
        else if cell.reuseIdentifier == "logoutCell" {
            NBClient.shared.logoutUser()
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            rootViewController.dismiss(animated: true, completion: nil)
        }
        else {
            self.present(UIAlertController(title: "Under Construction", message: "This view hasn't been implemented yet!", preferredStyle: .alert), animated: true, completion: nil)
        }
    }
}

