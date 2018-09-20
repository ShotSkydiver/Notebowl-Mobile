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

class CourseAssignmentsTableView: AnimatedNavBarViewController, UpdateVC {
    var indexes: Paths = Paths()
    var placeholderTableView: AssignmentTableView?
    
    var assignments: [AssignmentAssessment]!
    var data = [Category: [AssignmentAssessment]]()
    var selectedCourse: Course!
    var categories: [Category]!
    var gradientColors: [UIColor]!
    var gradientImage: UIImage!
    var stretchyHeaderView: AssignmentsHeaderView!
    
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.title = selectedCourse.courseCode

        if let gradients = self.selectedCourse.hexValuesFromGradientHeader() {
            gradientColors = gradients
            gradientImage = TMGradientNavigationBar().generateGradientImage(direction: .horizontal, startColor: gradientColors[0], endColor:  gradientColors[1], startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 0.6, y: 0.9), height: 500.0)
        }

        stretchyHeaderView = AssignmentsHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 160))
        stretchyHeaderView.label.text = selectedCourse.name
        stretchyHeaderView.detailLabel.text = selectedCourse.term.title
        stretchyHeaderView.backgroundColor = UIColor(patternImage: gradientImage)
        stretchyHeaderView.expansionMode = .topOnly
        stretchyHeaderView.manageScrollViewInsets = false
        tableView.addSubview(stretchyHeaderView)

        tableView.separatorColor = tableView.backgroundColor
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsetsMake(160, 0, 12, 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: (self.stretchyHeaderView.maximumContentHeight-self.stretchyHeaderView.minimumContentHeight)+12))

        SettingsTableViewHeader.register(in: tableView)
        CourseDetailViewCell.register(in: tableView)

        placeholderTableView = tableView as? AssignmentTableView
        placeholderTableView?.placeholderDelegate = self
        
        reloadTable()
    }

    override func setNavigationColors(){
        navigationController?.navigationBar.shadowImage = UIImage()
        if gradientImage != nil { navigationController?.navigationBar.barTintColor = UIColor(patternImage: gradientImage) }
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.groupTableViewBackground]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func reloadTable() {
        HUD.show(.progress)
        DispatchQueue.main.async {
            if self.selectedCourse.courseCategories.isEmpty {
                _ = NBClient.shared.requireByReference(Category.self, property: "parent", value: self.selectedCourse)
                let assigns = NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)!
                _ = NBClient.shared.requireByReferences(Submission.self, property: "_parent", values: assigns)
                _ = NBClient.shared.requireByReferences(Grade.self, property: "_parent", values: assigns)
                var combined = assigns as [AssignmentAssessment]
                let assess = NBClient.shared.requireByReference(Assessment.self, property: "parent", value: self.selectedCourse)!
                _ = NBClient.shared.requireByReferences(AssessmentSubmission.self, property: "_parent", values: assess)
                _ = NBClient.shared.requireByReferences(AssessmentQuestion.self, property: "_parent", values: assess)
                _ = NBClient.shared.requireByReferences(Grade.self, property: "_owner", values: assess)
                combined += assess as [AssignmentAssessment]
                for assign in combined {
                    assign.getGradeString()
                }
                self.selectedCourse.refresh()
            }
            self.assignments = self.selectedCourse.courseAssignments
            self.categories = self.selectedCourse.courseCategories
            self.updateData()
            self.placeholderTableView?.reloadData()
            self.navigationController?.setNavigationBarTransparent(true, animated: true)
            HUD.hide(animated: true)
        }
    }
    
    func updateData() {
        for category in self.categories! {
            let filtered = self.assignments.filter({ $0.category == category })
            if (filtered.count > 0) {
                self.data[category] = filtered
            }
            else {
                self.data[category] = filtered
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsTableViewHeader.dequeue(from: tableView)!
        header.setupHeader(showButton: false)
        guard let count = self.data[self.categories[section]]?.count else { fatalError() }

        if let title = self.categories[section].title {
            header.sectionTitle.text = title.uppercased()
            if count == 0 { header.sectionTitle.alpha = 0.0 }
            else { header.sectionTitle.alpha = 1.0 }
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.data[self.categories[section]]?.count == 0 {
            return 0
        }
        else {
            return 30
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.data[self.categories[section]]?.count == 0 {
            return 0
        }
        else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.data[self.categories[section]]?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseDetailViewCell.dequeue(from: tableView)!
        let assignment = self.data[self.categories[indexPath.section]]![indexPath.row]
        if gradientColors != nil { cell.configure(assignment: assignment, color: gradientColors[0]) }
        else { cell.configure(assignment: assignment, color: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1)) }
        return cell
    }
}

extension CourseAssignmentsTableView {
    
    func handleUpdated(newObject: NBModel) {
        if let newAssignment = newObject as? AssignmentAssessment {
            let assigns = (NBClient.shared.storedTypes.has(key: Assignment.classIdentifier) ? NBClient.shared.storedTypes[Assignment.classIdentifier]! : [])
            var combined = assigns as! [AssignmentAssessment]
            let assess = (NBClient.shared.storedTypes.has(key: Assessment.classIdentifier) ? NBClient.shared.storedTypes[Assessment.classIdentifier]! : [])
            combined += assess as! [AssignmentAssessment]
            self.assignments = combined

            let indexOfAssignment = self.assignments.index(where: { ($0 as! NBModel) == (newAssignment as! NBModel) })
            _ = NBClient.shared.requireByReference(AssessmentQuestion.self, property: "parent", value: newObject)
            self.assignments[indexOfAssignment!].getGradeString()
            self.selectedCourse.refresh()

            self.updateData()

            let indexOfCategory = self.categories.index(of: self.assignments[indexOfAssignment!].category)
            let existingAssignment = tableView.numberOfRows(inSection: indexOfCategory!) < self.data[self.categories[indexOfCategory!]]!.count ? false : true

            if tableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell {
                placeholderTableView?.showDefault()
            }

            if self.data[newAssignment.category]!.count == 1 && !existingAssignment {
                guard let headerView = tableView.headerView(forSection: indexOfCategory!) as? SettingsTableViewHeader else { return }
                headerView.sectionTitle.showViewAnimated(true)
            }

            let indexInData = self.data[newAssignment.category]!.index(where: { ($0 as! NBModel) == (newAssignment as! NBModel) })
            existingAssignment == false ? tableView.insertRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .left) : tableView.reloadRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .fade)
        }

        else if let newSubmission = newObject as? Submission {
            if newSubmission.parent is Assignment {
                if newSubmission.parent!.parent?.enrollmentForUser?.role == .professor || newSubmission.parent!.parent?.enrollmentForUser?.role == .admin {
                    return
                }
                if let indexOfAssignment = self.assignments.index(where: { ($0 as! NBModel) == newSubmission.parent! }) {
                    let indexInData = self.data[(newSubmission.parent as! AssignmentAssessment).category]!.index(where: { ($0 as! NBModel) == newSubmission.parent! })
                    let indexOfCategory = self.categories.index(of: self.assignments[indexOfAssignment].category)
                    tableView.reloadRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .fade)
                }
            }
        }

        else if let newCategory = newObject as? Category {
            self.categories = NBClient.shared.storedTypes[Category.classIdentifier]! as! [Category]
            self.updateData()
            let indexOfCategory = self.categories.index(of: newCategory)
            let existingCategory = self.tableView.numberOfSections < self.data.count ? false : true

            if !existingCategory { tableView.insertSections(IndexSet(integer: indexOfCategory!), with: .left) }
            else { tableView.reloadSections(IndexSet(integer: indexOfCategory!), with: .fade) }
        }
        
        else if let newGrade = newObject as? Grade {
            if newGrade.owner is Assessment || newGrade.owner is Assignment {
                if newGrade.owner!.parent?.enrollmentForUser?.role == .professor || newGrade.owner!.parent?.enrollmentForUser?.role == .admin {
                    return
                }
                if let indexOfAssignment = self.assignments.index(where: { ($0 as! NBModel) == newGrade.owner! }) {
                    self.assignments[indexOfAssignment].getGradeString()
                    self.updateData()

                    let indexInData = self.data[(newGrade.owner as! AssignmentAssessment).category]!.index(where: { ($0 as! NBModel) == newGrade.owner! })
                    let indexOfCategory = self.categories.index(of: self.assignments[indexOfAssignment].category)
                    tableView.reloadRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .fade)
                }
            }
        }
        else if newObject is Course {
            reloadTable()
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if let deleteAssignment = deletedObject as? AssignmentAssessment {
            let indexOfAssignment = self.data[deleteAssignment.category]!.index(where: { ($0 as! NBModel) == (deleteAssignment as! NBModel) })
            let indexOfCategory = self.categories.index(where: { $0 == self.assignments[indexOfAssignment!].category })

            self.selectedCourse.refresh()
            self.assignments = self.selectedCourse.courseAssignments
            self.categories = self.selectedCourse.courseCategories
            self.updateData()

            if indexOfAssignment != nil { tableView.deleteRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) }
            if self.data[deleteAssignment.category]!.count == 0 {
                guard let headerView = tableView.headerView(forSection: indexOfCategory!) as? SettingsTableViewHeader else { return }
                headerView.sectionTitle.showViewAnimated(false)
            }
            if tableView.visibleCells.count == 0 { placeholderTableView?.showNoResultsPlaceholder() }
        }

        else if let deleteCategory = deletedObject as? Category {
            let indexOfCategory = self.categories.index(where: { $0 == deleteCategory })
            tableView.deleteSections(IndexSet(integer: indexOfCategory!), with: .right)
            self.categories = NBClient.shared.storedTypes[Category.classIdentifier]! as! [Category]
            self.updateData()
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
    func reloadTableViews() {}
}

extension CourseAssignmentsTableView: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        TTLog.debug(placeholder.key.value)
        self.reloadTable()
    }
}

class AssignmentTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .makePlaceholdersProvider(from: .emptyAssignments)
    }
}

class AssignmentsHeaderView: GSKStretchyHeaderView {
    let maxFontSize: CGFloat = 22
    let minFontSize: CGFloat = 17

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 20))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: self.maxFontSize, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.groupTableViewBackground
        label.text = "Course Name"
        label.textAlignment = .center
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 70, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 70))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
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
        self.maximumContentHeight = 200
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
