//
//  CourseAssignmentsTableView.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import HGPlaceholders
import Tamamushi
import GSKStretchyHeaderView
import PKHUD


enum AssignmentStatus: String {
    case InProgress = "In Progress"
    case Graded = "Graded"
    case Submitted = "Submitted"
    case Open = "Open"
    case PastDue = "Past Due"
    case Closed = "Closed"
}

enum AssignmentProfStatus: String {
    case NotPublished = "Not Published"
    case NotAvailable = "Not Available Yet"
    case Grading = "Grading"
}

class CourseAssignmentsTableView: AnimatedNavBarViewController, UpdateVC {
    var assignments: [AssignmentAssessment]!
    var selectedCourse: Course!
    var gradientColors: [UIColor]!
    var gradientImage: UIImage!
    var stretchyHeaderView: AssignmentsHeaderView!
    
    var loadingView: NBLoadingView!
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.title = selectedCourse.courseCode

        gradientColors = selectedCourse.hexValuesFromGradientHeader()
        gradientImage = TMGradientNavigationBar().generateGradientImage(direction: .horizontal, startColor: gradientColors[0], endColor:  gradientColors[1], startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 0.6, y: 0.9), height: 500.0)

        stretchyHeaderView = AssignmentsHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 160))
        stretchyHeaderView.label.text = selectedCourse.name
        stretchyHeaderView.detailLabel.text = selectedCourse.term.title
        stretchyHeaderView.backgroundColor = UIColor(patternImage: gradientImage)
        stretchyHeaderView.expansionMode = GSKStretchyHeaderViewExpansionMode.topOnly
        stretchyHeaderView.manageScrollViewInsets = false
        tableView.addSubview(stretchyHeaderView)

        tableView.separatorColor = tableView.backgroundColor
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 24, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: (self.stretchyHeaderView.maximumContentHeight-self.stretchyHeaderView.minimumContentHeight)+14))

        CourseDetailViewCell.register(in: tableView)

        reloadTable()
    }

    override func setNavigationColors() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        if gradientImage != nil { navigationController?.navigationBar.barTintColor = UIColor(patternImage: gradientImage) }
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func reloadTable() {
        HUD.show(.progress)
        DispatchQueue.main.async {

            if self.selectedCourse.courseAssignments.isEmpty {
                let assigns = NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)
                _ = NBClient.shared.requireByReferences(Submission.self, property: "_parent", values: assigns)
                let assess = NBClient.shared.requireByReference(Assessment.self, property: "parent", value: self.selectedCourse)
                let assessSubs = NBClient.shared.requireByReferences(AssessmentSubmission.self, property: "_parent", values: assess)

                var combinedFilter = assigns as [NBModel]
                combinedFilter.append(contentsOf: (assess as [NBModel]))
                combinedFilter.append(contentsOf: (assessSubs as [NBModel]))

                _ = NBClient.shared.requireByReferences(AssessmentQuestion.self, property: "_parent", values: assess)
                _ = NBClient.shared.requireByReferences(Grade.self, property: "_owner", values: combinedFilter)
                
                for assign in combinedFilter {
                    assign.refresh()
                }
                self.selectedCourse.refresh()
            }

            self.assignments = self.selectedCourse.courseAssignments
            self.tableView.reloadData()
            HUD.hide(animated: true)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assignments != nil ? self.assignments.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseDetailViewCell.dequeue(from: tableView)!
        let assignment = self.assignments[indexPath.row]
        cell.configure(assignment: assignment, color: gradientColors[0])
        return cell
    }
}

extension CourseAssignmentsTableView {
    
    func handleUpdated(newObject: NBModel) {
        if let newAssignment = newObject as? AssignmentAssessment {

            var combined: [AssignmentAssessment] {
                var mutableArray: [AssignmentAssessment] = []
                if let assignsCached = NBClient.shared.storedTypes[Assignment.classIdentifier] {
                    mutableArray.append(contentsOf: (assignsCached as! [AssignmentAssessment]))
                }
                if let assessCached = NBClient.shared.storedTypes[Assessment.classIdentifier] {
                    mutableArray.append(contentsOf: (assessCached as! [AssignmentAssessment]))
                }
                return mutableArray
            }

            self.assignments = combined
            guard let indexOfAssignment = self.assignments.firstIndex(where: {($0 as! NBModel) == newObject}) else { fatalError() }
            let existingAssignment = tableView.numberOfRows(inSection: 0) < self.assignments.count ? false : true

            self.assignments[indexOfAssignment].getGradeString()
            self.selectedCourse.refresh()

            existingAssignment == false ? tableView.insertRows(at: [IndexPath(row: indexOfAssignment, section: 0)], with: .left) : tableView.reloadRows(at: [IndexPath(row: indexOfAssignment, section: 0)], with: .fade)
        }

        else if let newSubmission = newObject as? Submission {
            if newSubmission.parent is Assignment {
                if newSubmission.parent!.parent?.enrollmentForUser?.role == .professor || newSubmission.parent!.parent?.enrollmentForUser?.role == .admin {
                    return
                }
                if let indexOfAssignment = self.assignments.index(where: {($0 as! NBModel) == newSubmission.parent}) {
                    tableView.reloadRows(at: [IndexPath(row: indexOfAssignment, section: 0)], with: .fade)
                }
            }
        }

        else if let newGrade = newObject as? Grade {
            if newGrade.owner is Assessment || newGrade.owner is Assignment {
                if newGrade.owner!.parent?.enrollmentForUser?.role == .professor || newGrade.owner!.parent?.enrollmentForUser?.role == .admin {
                    return
                }
                if let indexOfAssignment = self.assignments.index(where: {($0 as! NBModel) == newGrade.owner!}) {
                    self.assignments[indexOfAssignment].getGradeString()
                    tableView.reloadRows(at: [IndexPath(row: indexOfAssignment, section: 0)], with: .fade)
                }
            }
        }
        else if newObject is Course {
            reloadTable()
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if let deleteAssignment = deletedObject as? AssignmentAssessment {
            guard let indexOfAssignment = self.assignments.firstIndex(where: {($0 as! NBModel) == deletedObject}) else { fatalError() }
            self.selectedCourse.refresh()
            self.assignments = self.selectedCourse.courseAssignments

            tableView.deleteRows(at: [IndexPath(row: indexOfAssignment, section: 0)], with: .left)
        }

        else if let deleteCourse = deletedObject as? Enrollment {
            if deleteCourse.parent is Course {
                if (deleteCourse.parent as! Course) == self.selectedCourse {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {}
}

class AssignmentsHeaderView: GSKStretchyHeaderView {
    let maxFontSize: CGFloat = 22
    let minFontSize: CGFloat = 17

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 40))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: self.maxFontSize, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.groupTableViewBackground
        label.text = "Course Name"
        label.textAlignment = .center
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 90, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 90))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.groupTableViewBackground
        label.text = "Course Details"
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.maximumContentHeight = 160
        self.minimumContentHeight = 88

        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.detailLabel)
        self.backgroundColor = UIColor.orange
    }

    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)

        let alpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        self.label.alpha = alpha
        self.detailLabel.alpha = alpha
    }
}
