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
        
        placeholderTableView = tableView as? AssignmentTableView
        placeholderTableView?.placeholderDelegate = self
        
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        reloadTable()
    }
    
    func reloadTable() {
        loadingView.showLoadView(true)
        bgView.showViewAnimated(true)
        DispatchQueue.main.async {
            self.assignments = (NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)!)
            self.categories = (NBClient.shared.requireByReference(Category.self, property: "parent", value: self.selectedCourse)!)
            
            
            for assignment in self.assignments {
                assignment.getGradeString()
            }
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.data[self.categories[section]]?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! CourseAssignmentViewCell
        
        let assignmentForCell = self.data[self.categories[indexPath.section]]?[indexPath.row]
        cell.assignmentName.text = assignmentForCell?.title
        if (assignmentForCell?.gradeOnly)! {
            cell.assignmentDesc.text = ""
        }
        else {
            cell.assignmentDesc.text = assignmentForCell?.desc
        }
        cell.assignmentPoints.text = ("\(assignmentForCell?.points! ?? 0)")
        cell.dueDate.text = assignmentForCell?.dueDate?.relativeFormat
        
        cell.assignmentGrade.text = assignmentForCell?.gradeString
        cell.assignmentStatus.text = assignmentForCell?.getStatus
        
        cell.showCell(true)
        
        return cell
    }
}

extension CourseAssignmentsTableView {
    
    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "AssignmentGroup" {
            
        }
        else if let newAssignment = newObject as? Assignment {
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            self.updateData()
            let indexOfAssignment = self.data[newAssignment.category]!.index(where: { $0 == newAssignment })
            let indexOfCategory = self.categories.index(where: { $0 == self.assignments[indexOfAssignment!].category })
            let existingAssignment = self.tableView.numberOfRows(inSection: indexOfCategory!) < (self.data[self.categories[indexOfCategory!]]?.count)! ? false : true
            
            placeholderTableView?.showDefault()
            
            existingAssignment == false ? tableView.insertRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) : tableView.reloadRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .fade)
        }

        else if let newCategory = newObject as? Category {
            self.categories = NBClient.shared.storedTypes[Category.classIdentifier]! as! [Category]
            self.updateData()
            let indexOfCategory = self.categories.index(where: { $0 == newCategory })
            let existingCategory = self.tableView.numberOfSections < self.data.count ? false : true
            if !existingCategory { tableView.insertSections(IndexSet(integer: indexOfCategory!), with: .left) }
            else { tableView.reloadSections(IndexSet(integer: indexOfCategory!), with: .fade) }
        }
        
        else if let newGrade = newObject as? Grade {
            if newGrade.parent is Assignment {
                let assignment = self.assignments.first(where: { $0 == (newGrade.parent as! Assignment) })
                assignment!.getGradeString()
                self.updateData()
                let indexOfAssignment = self.data[assignment!.category]!.index(where: { $0 == assignment! })
                let indexOfCategory = self.categories.index(where: { $0 == self.assignments[indexOfAssignment!].category })
                tableView.reloadRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .fade)
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
            if indexOfAssignment != nil { tableView.deleteRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) }
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            self.updateData()
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
