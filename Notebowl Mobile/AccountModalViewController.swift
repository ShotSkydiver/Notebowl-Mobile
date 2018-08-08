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
import AcknowList

protocol ContainerToMaster {
    func startUpload(image:UIImage)
    func uploadingImage()
}

class AccountModalViewController: UIViewController {
    @IBOutlet var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class AccountModalTableViewController: UITableViewController {
    var menu: UIAlertController!
    var dismissWithUpdate: Bool = false
    var progress: Float = 0.0
    var selectedImage: UIImage!
    
    var updatedUser: [String: AnyObject]!
    
    @IBOutlet weak var profilePicture: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
        profilePicture.style = .sector
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePic(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        profilePicture.addGestureRecognizer(tapGesture)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let keyPath = self.updatedUser {
            let data: Any = ["itemType":"\(ItemType.fromURL((keyPath["url"] as! String)))", "updateUrl":"\((keyPath["url"] as! String))", "action":"updated", "updatedAt":"\((keyPath["updatedAt"] as! String))"]
            let JSON = try? JSONSerialization.data(withJSONObject: data, options: [])
            let JSONString = String(data: JSON!, encoding: String.Encoding.utf8)
            NBSocket.shared.updateHandler(message: JSONString!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeProfilePic(_ sender: Any) {
        setupMenuForAlert()
    }
    
    func updateInfo() {
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
            self.updatedUser = (r.json as AnyObject).value(forKeyPath: "result")! as! [String : AnyObject]
            DispatchQueue.main.async(execute: {
                self.profilePicture.uploadCompleted()
            })
        })
        
        upload.task?.resume()
    }
    
    func setupMenuForAlert() {
        var config = YPImagePickerConfiguration()
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 4.0
        config.isScrollToChangeModesEnabled = false
        config.targetImageSize = .cappedTo(size: 1024)
        config.albumName = "Notebowl Photos"
        config.startOnScreen = .library
        config.showsCrop = .none
        config.hidesStatusBar = false
        config.showsFilters = false
        config.library.maxNumberOfItems = 1
        config.icons.capturePhotoImage = UIImage(named: "open_camera-vector")!
        config.colors.tintColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
        config.colors.multipleItemsSelectedCircleColor = #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)
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
                    self.startUpload(image: photo.image)
                    picker.dismiss(animated: true, completion: {
                        self.uploadingImage()
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
        tableView.deselectRow(at: indexPath, animated: true)
        if cell.reuseIdentifier == "changeProfileCell" {
            setupMenuForAlert()
        }
        else if cell.reuseIdentifier == "emailSettingsCell" {
            TTLog.debug("email settings!")
        }
        else if cell.reuseIdentifier == "pushSettingsCell" {
            TTLog.debug("push settings!")
        }
        else if cell.reuseIdentifier == "appInfoCell" {
            //let ackViewController = AcknowListViewController()
            //navigationController?.pushViewController(ackViewController, animated: true)
        }
        else if cell.reuseIdentifier == "logoutCell" {
            NBClient.shared.logoutUser()
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}
