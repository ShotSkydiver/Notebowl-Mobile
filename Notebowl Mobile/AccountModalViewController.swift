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
import YPImagePicker

protocol ContainerToMaster {
    func startUpload(image:UIImage)
    func uploadingImage()
}

class AccountModalViewController: UIViewController, ContainerToMaster {
    
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
        
        updateInfo()
        profilePicture.style = .sector
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalEmbedSegue" {
            containerViewController = segue.destination as? AccountModalTableViewController
            containerViewController!.containerToMaster = self
        }
    }
    
    func updateInfo() {
        doneButton.tintColor = UIImage().createGradientImage(size: 50).gradientColor
        profilePicture.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .forceTransition,
                                    .keepCurrentImageWhileLoading
            ]
        )
        profilePicture.contentMode = .scaleAspectFill

        userName.text = NBClient.shared.getCurrentUser().fullName
        userEmail.text = NBClient.shared.getCurrentUser().email
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startUpload(image: UIImage) {
        self.progress = 0.1
        self.selectedImage = image
        self.profilePicture.uploadImage(image: selectedImage, progress: progress)
    }
    
    public func uploadingImage() {
        let upload = NBNetworking.shared.request(.post, url: ("https://\(NBClient.baseUrl)/rpc/v1.0/users/" + NBClient.shared.getCurrentUser().resourceKey + "/changeProfilePicture"),
                                                 params: ["uuid": UIDevice().uuid],
                                                 files: ["files[]":.data("profile.jpg", self.selectedImage.compressedData()!, "image/jpeg")],
                                                 loadImmediately: false,
                                                 asyncProgressHandler: { p in
                                                    DispatchQueue.main.async(execute: {
                                                        TTLog.debug("prgoress: ", p.percentageUpload)
                                                        self.profilePicture.uploadImage(image: self.selectedImage, progress: Float(p.percentageUpload))
                                                    })
        }, asyncCompletionHandler: { r in
            DispatchQueue.main.async(execute: {
                self.profilePicture.uploadCompleted()
            })
        })
        
        upload.task?.resume()
    }
}

class AccountModalTableViewController: UITableViewController {
    var containerToMaster: ContainerToMaster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupMenuForAlert() {
        var config = YPImagePickerConfiguration()
        config.targetImageSize = .cappedTo(size: 1024)
        config.albumName = "Notebowl Photos"
        config.startOnScreen = .library
        config.showsCrop = .none
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
                    self.containerToMaster?.startUpload(image: photo.image)
                    picker.dismiss(animated: true, completion: {
                        self.containerToMaster?.uploadingImage()
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
