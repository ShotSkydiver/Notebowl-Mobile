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
    @IBOutlet weak var assignmentDesc: UILabel!
    @IBOutlet weak var assignmentGrade: UILabel!
    @IBOutlet weak var assignmentPoints: UILabel!
    @IBOutlet weak var assignmentStatus: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    var assignmentForCell: Assignment!

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }

    func initSetup() {


    }

    func configure(assignment: Assignment) {
        assignmentName.text = assignment.title
        assignmentDesc.text = (assignment.gradeOnly ? "" : assignment.desc)

        assignmentPoints.text = ("\(assignment.points ?? 0)")
        dueDate.text = assignment.dueDate.relativeFormat

        assignmentGrade.text = assignment.gradeString
        assignmentStatus.text = assignment.getStatus

        self.assignmentForCell = assignment
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
