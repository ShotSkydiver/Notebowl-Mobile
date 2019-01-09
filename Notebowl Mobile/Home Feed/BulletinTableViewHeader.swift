//
//  HomeFeedWritePostCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 4/5/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class BulletinTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var dummyTextField: AutoSizeTextField!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }

    func initSetup() {
        dummyTextField.borderStyle = .roundedRect

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGesture)
    }

    func reloadAvatar() {
        userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .forceTransition,
                                    .keepCurrentImageWhileLoading,
                                    .forceRefresh
            ]
        )
        userAvatar.contentMode = .scaleAspectFill
    }

    @objc func singleTap(gesture: UITapGestureRecognizer) {
        if !Course.getCache().isEmpty || !Group.getCache().isEmpty {
            if let parentVC = parentViewController as? HomeFeedViewController {
                parentVC.performSegue(withIdentifier: "createPostSegue", sender: nil)
            }
        }
    }
}

class AutoSizeTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in subviews {
            if let label = subview as? UILabel {
                label.minimumScaleFactor = 0.3
                label.adjustsFontSizeToFitWidth = true
            }
        }
    }
}
