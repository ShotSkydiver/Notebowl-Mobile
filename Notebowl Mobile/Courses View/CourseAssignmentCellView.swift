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
    @IBOutlet weak var gradeHeader: UILabel!
    @IBOutlet weak var pointsHeader: UILabel!
    @IBOutlet weak var statusHeader: UILabel!
    
    var assignmentForCell: AssignmentAssessment!

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }

    func initSetup() { }

    func configure(assignment: AssignmentAssessment) {
        assignmentName.text = assignment.title
        assignmentDesc.text = assignment.desc

        dueDate.text = assignment.dueDate.relativeFormat

        if (assignment as! NBModel).parent?.enrollmentForUser?.role == .professor || (assignment as! NBModel).parent?.enrollmentForUser?.role == .admin {
            assignmentGrade.text = ("\(assignment.points ?? 0)")
            gradeHeader.text = "POINTS"
            
            assignmentPoints.text = ""
            pointsHeader.text = ""
            
            assignmentStatus.text = ""
            statusHeader.text = ""
        }
        else {
            assignmentGrade.text = assignment.gradeString
            gradeHeader.text = "GRADE"
            
            assignmentPoints.text = ("\(assignment.points ?? 0)")
            pointsHeader.text = "POINTS"
            
            assignmentStatus.text = assignment.status
            statusHeader.text = "STATUS"
        }
        self.assignmentForCell = assignment
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
