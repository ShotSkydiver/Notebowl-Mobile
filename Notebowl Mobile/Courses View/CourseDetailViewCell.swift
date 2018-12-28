//
//  CourseDetailViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 9/15/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import UIKit
import Foundation
import SwiftDate

class CourseDetailViewCell: UITableViewCell {

    @IBOutlet weak var assignmentName: KerningLabel!
    @IBOutlet weak var assignmentCategory: PillUILabel!
    @IBOutlet weak var dueDateNumber: UILabel!
    @IBOutlet weak var dueDateText: UILabel!
    @IBOutlet weak var totalPointsNumber: UILabel!
    @IBOutlet weak var totalPointsText: UILabel!
    @IBOutlet weak var submittedText: UILabel!
    @IBOutlet weak var userGradeText: UILabel!

    var assignmentForCell: AssignmentAssessment!

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }

    func initSetup() {
        assignmentCategory.textColor = UIColor(hexString: "#f5f5f5")
    }

    func configure(assignment: AssignmentAssessment, color: UIColor) {
        assignmentName.text = assignment.title
        assignmentCategory.text = assignment.category.title.uppercased()
        if let userRole = (assignment as! NBModel).parent?.enrollmentForUser.role, userRole == .professor || userRole == .admin || userRole == .TA {
            userGradeText.text = ""
        } else {
            userGradeText.text = assignment.getUserGrade()
        }
        submittedText.text = assignment.status.rawValue

        if assignment.dueDate != nil {
            let parsedDateString = assignment.dueDate.literalFormat
            if assignment.status == .NotAvailableYet {
                dueDateNumber.text = "opens \(parsedDateString)"
            } else {
                dueDateNumber.text = parsedDateString
            }
        } else {
            dueDateNumber.text = ""
        }
        dueDateText.text = " "

        if assignment.points.isInt {
            if let userRole = (assignment as! NBModel).parent?.enrollmentForUser.role, userRole == .professor || userRole == .admin || userRole == .TA {
                totalPointsNumber.text = ("\(Int(assignment.points!))")
            } else {
            totalPointsNumber.text = ("/ \(Int(assignment.points!))")
            }
        } else {
            if let userRole = (assignment as! NBModel).parent?.enrollmentForUser.role, userRole == .professor || userRole == .admin || userRole == .TA {
                totalPointsNumber.text = ("\(assignment.points!)")
            } else {
            totalPointsNumber.text = ("/ \(assignment.points!)")
            }
        }

        totalPointsText.text = "pts"

        assignmentCategory.backgroundColor = color
        userGradeText.textColor = color
        submittedText.textColor = color

        self.assignmentForCell = assignment
    }

    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }
}

extension CourseDetailViewCell {
    static var reuseId: String {
        return "courseDetailCell"
    }
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "CourseDetailViewCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    class func dequeue(from tableView: UITableView) -> CourseDetailViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? CourseDetailViewCell
    }
}
