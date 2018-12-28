//
//  IndexedCollectionViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/8/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import UIKit
import Kingfisher

class IndexedCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "indexCollectionCell"

    @IBOutlet weak var attachment: ProfileImageView!
    @IBOutlet weak var attachmentOverlay: UIView!
    @IBOutlet weak var attachmentCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        attachmentOverlay.layer.cornerRadius = 4.0
        attachmentOverlay.layer.masksToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }

    func initSetup() {

    }

    func cellDisplaysOverlay(count: String, forceUpdate: Bool) {

        if ((attachmentCount.text?.count)! < 2) || (attachmentOverlay.alpha == 0.0) || (forceUpdate) || (attachmentCount.text != count) {
            attachmentCount.text = count
            attachmentOverlay.showViewAnimated(true, alpha: 0.7)
        }

    }
}
