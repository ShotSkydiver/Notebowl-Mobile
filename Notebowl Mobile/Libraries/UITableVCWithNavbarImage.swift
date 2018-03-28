//
//  UITableVCWithNavbarImage.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 1/27/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class UITableVCWithNavbarImage: UIViewController {
    
    public let navbarImageView = UIImageView(image: UIImage(named: "male-user"))
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 12
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 30
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        navbarImageView.isUserInteractionEnabled = true
        navbarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        setupUI()
        let placeholderimg = UIImage(named: "male-user")
        self.navbarImageView.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl, placeholder: placeholderimg, options: [.transition(.fade(0.3))])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let menu = UIAlertController(title: "Options", message: "Manage your profile and other app settings.", preferredStyle: .actionSheet)
        
        let editProfilePic = UIAlertAction(title: "Change Profile Picture", style: .default) { (action) in
            
        }
        let logoutUser = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            print("logout")
            NBClient.shared.logoutUser()
            
            self.dismiss(animated: true, completion: nil)
        }
        let dismiss = UIAlertAction(title: "Close", style: .cancel) { (action) in
            
        }
        menu.addAction(editProfilePic)
        menu.addAction(logoutUser)
        menu.addAction(dismiss)
        self.present(menu, animated: true, completion: nil)
    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    func setupUI() {
        if #available(iOS 11.0, *) { navigationController?.navigationBar.prefersLargeTitles = false }
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(navbarImageView)
        navbarImageView.layer.cornerRadius = Const.ImageSizeForLargeState/2
        navbarImageView.layer.borderWidth = 1.0
        navbarImageView.layer.borderColor = UIColor.lightGray.cgColor
        navbarImageView.clipsToBounds = true
        navbarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navbarImageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            navbarImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            navbarImageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            navbarImageView.widthAnchor.constraint(equalTo: navbarImageView.heightAnchor)
            ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor)
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        navbarImageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }

}
