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

class CourseAssignmentsTableView: UITableViewController, UpdateVC {
    var indexes: Paths = Paths()
    var placeholderTableView: AssignmentTableView?
    
    var assignments: [Assignment]!
    var data = [Category: [Assignment]]()
    var selectedCourse: Course!
    var categories: [Category]!
    
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCourse.courseCode

        SettingsTableViewHeader.register(in: tableView)
        
        placeholderTableView = tableView as? AssignmentTableView
        placeholderTableView?.placeholderDelegate = self
        
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0)
        
        reloadTable()
    }

    func reloadTable() {
        loadingView.showLoadView(true)
        bgView.showViewAnimated(true)
        DispatchQueue.main.async {
            if self.selectedCourse.courseCategories.isEmpty {
                _ = NBClient.shared.requireByReference(Category.self, property: "parent", value: self.selectedCourse)
                let assigns = NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)!
                _ = NBClient.shared.requireByReferences(Grade.self, property: "_parent", values: assigns)
                for assign in assigns {
                    assign.refresh()
                    assign.getGradeString()
                }
                self.selectedCourse.refresh()
            }
            self.assignments = self.selectedCourse.courseAssignments
            self.categories = self.selectedCourse.courseCategories
            self.updateData()
            
            self.placeholderTableView?.reloadData()
            self.bgView.showViewAnimated(false)
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.data[self.categories[section]]?.count == 0 {
            return nil
        }
        guard let title = self.categories[section].title else {
            return ""
        }
        return title
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsTableViewHeader.dequeue(from: tableView)!
        header.setupHeader(showButton: false)
        if let count = self.data[self.categories[section]]?.count {
            if count == 0 {
                header.sectionTitle.text = ""
                header.sectionTitle.isHidden = true
            }
            else if let title = self.categories[section].title {
                header.sectionTitle.text = title
                header.sectionTitle.isHidden = false
            }
        }
        else {
            header.sectionTitle.text = ""
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.data[self.categories[section]]?.count == 0 {
            return 0
        }
        else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.data[self.categories[section]]?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! CourseAssignmentViewCell
        let assignment = self.data[self.categories[indexPath.section]]![indexPath.row]
        cell.configure(assignment: assignment)
        return cell
    }
}

extension CourseAssignmentsTableView {
    
    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "AssignmentGroup" {
            
        }
        else if let newAssignment = newObject as? Assignment {
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            let indexOfAssignment = self.assignments.index(of: newAssignment)
            self.assignments[indexOfAssignment!].refresh()
            self.assignments[indexOfAssignment!].getGradeString()
            self.updateData()
            let indexOfCategory = self.categories.index(of: self.assignments[indexOfAssignment!].category)
            let existingAssignment = tableView.numberOfRows(inSection: indexOfCategory!) < self.data[self.categories[indexOfCategory!]]!.count ? false : true

            if tableView.cellForRow(at: IndexPath(row: 0, section: 0)) is PlaceholderTableViewCell {
                placeholderTableView?.showDefault()
            }

            let indexInData = self.data[newAssignment.category]!.index(of: newAssignment)
            existingAssignment == false ? tableView.insertRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .left) : tableView.reloadRows(at: [IndexPath(row: indexInData!, section: indexOfCategory!)], with: .fade)
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
            if newGrade.parent is Assignment {
                if (newGrade.parent as! Assignment).parent?.enrollmentForUser?.role == .professor || (newGrade.parent as! Assignment).parent?.enrollmentForUser?.role == .admin {
                    return
                }
                if let indexOfAssignment = self.assignments.index(of: (newGrade.parent as! Assignment)) {
                    self.assignments[indexOfAssignment].refresh()
                    self.assignments[indexOfAssignment].getGradeString()
                    self.updateData()

                    let indexInData = self.data[(newGrade.parent as! Assignment).category]!.index(of: (newGrade.parent as! Assignment))
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
        if let deleteAssignment = deletedObject as? Assignment {
            let indexOfAssignment = self.data[deleteAssignment.category]!.index(where: { $0 == deleteAssignment })
            let indexOfCategory = self.categories.index(where: { $0 == self.assignments[indexOfAssignment!].category })
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            self.updateData()

            if indexOfAssignment != nil { tableView.deleteRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) }
            if self.data[deleteAssignment.category]!.isEmpty { tableView.reloadSections(IndexSet(integer: indexOfCategory!), with: .fade) }
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
