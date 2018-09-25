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

    override func awakeFromNib() { super.awakeFromNib() }
    override func prepareForReuse() { super.prepareForReuse() }

    func configure(assignment: AssignmentAssessment, color: UIColor) {
        assignmentName.text = assignment.title
        assignmentCategory.text = assignment.category.title

        if assignment.dueDate == nil {
            dueDateNumber.text = "--"
            dueDateText.text = ""
            submittedText.text = "Not Published"
        }
        else if assignment.availableDate.isInFuture {
            dueDateNumber.text = "--"
            dueDateText.text = ""
            submittedText.text = "Not Available Yet"
        }

        else {
            userGradeText.text = assignment.getUserGrade()
            submittedText.text = assignment.status

            let parsedDateString = assignment.dueDate.literalFormat
            var dateStringComponents = parsedDateString.components(separatedBy: " ")
            if dateStringComponents[0] == "in" { dateStringComponents.remove(at: 0) }
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: dateStringComponents[0])) {
                dueDateNumber.text = dateStringComponents[0]
                if assignment.isAvailable && !assignment.isPastDue { dueDateText.text = (dateStringComponents[1] + " left") }
                else if assignment.isPastDue { dueDateText.text = (dateStringComponents[1] + " ago") }
            }
            else {
                dueDateNumber.text = "Due now"
                dueDateText.text = " "
            }
        }
        totalPointsNumber.text = ("\(assignment.points ?? 0)")
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
