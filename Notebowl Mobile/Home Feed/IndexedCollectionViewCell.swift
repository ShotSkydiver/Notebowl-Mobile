//
//  IndexedCollectionViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 5/8/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import UIKit

class IndexedCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "indexCollectionCell"
    
    @IBOutlet weak var attachment: ProfileImageView!
    @IBOutlet weak var attachmentOverlay: UIView!
    @IBOutlet weak var attachmentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        attachmentOverlay.layer.cornerRadius = 4.0
        attachmentOverlay.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        
    }
}
