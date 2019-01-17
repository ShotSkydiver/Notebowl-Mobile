//
//  ProfileImageView.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/31/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

@IBDesignable class ProfileImageView: DesignableImageView {
    var forCurrentUser: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupObservers()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingUser(_:)), name: NSNotification.Name("ModelDidFinishUpdatingUser"), object: nil)
    }

    @objc func finishUpdatingUser(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newUser = dict["object"] as? User else {
            return
        }

        if !self.forCurrentUser || NBClient.shared.currentUser == nil {
            return
        }

        if newUser != NBClient.shared.getCurrentUser() {
            return
        }

        self.kf.setImage(with: newUser.profileUrl,
                         options: [
                            .transition(ImageTransition.fade(0.3)),
                            .keepCurrentImageWhileLoading
            ]
        )
    }
}
