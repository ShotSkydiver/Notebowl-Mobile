//
//  CourseAssignmentCellView.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

class CourseAssignmentViewCell: UITableViewCell {
    
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var assignmentGrade: UILabel!
    @IBOutlet weak var assignmentPoints: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
