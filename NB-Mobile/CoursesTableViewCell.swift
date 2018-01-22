//
//  CoursesTableViewCell.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/12/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var currentGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
