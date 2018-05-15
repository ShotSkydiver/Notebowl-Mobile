//
//  HomeFeedWritePostCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 4/5/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

class HomeFeedWritePostCell: UITableViewCell {

    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var dummyTextField: AutoSizeTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        dummyTextField.borderStyle = .roundedRect
    }
}

extension HomeFeedWritePostCell {
    static var reuseId: String {
        return "newPostCell"
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "HomeFeedWritePostCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> HomeFeedWritePostCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? HomeFeedWritePostCell
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
