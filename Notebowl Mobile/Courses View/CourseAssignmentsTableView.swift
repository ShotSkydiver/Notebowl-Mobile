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

class CourseAssignmentsTableView: UITableViewController, PlaceholderDelegate, UpdateVC {
    var indexes: Paths = Paths()
    var placeholderTableView: TableView?
    
    var assignments: [Assignment]!
    var data = [Category: [Assignment]]()
    var selectedCourse: Course!
    var categories: [Category]!
    
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCourse.courseCode
        
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        placeholderTableView = tableView as? TableView
        placeholderTableView?.placeholderDelegate = self
        
        self.getTableData()
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        self.getTableData()
    }

    
    func getTableData() {
        loadingView.showLoadView(true)
        bgView.showViewAnimated(true)
        DispatchQueue.main.async {
            self.assignments = NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)!
            self.categories = NBClient.shared.requireByReference(Category.self, property: "parent", value: self.selectedCourse)!
            
            for assignment in self.assignments {
                assignment.getGradeString()
            }
            self.updateData()
            
            self.tableView.reloadData()
            self.bgView.showViewAnimated(false)
        }
    }
    
    func updateData() {
        for category in self.categories! {
            let filtered = self.assignments.filter({ $0.category.resourceKey == category.resourceKey })
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
        cell.dueDate.text = assignmentForCell?.dueDate?.relativelyFormatted
        
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
        else if newObject.itemType.contains("Assignment") {
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            self.updateData()
            
            let indexOfAssignment = self.data[(newObject as! Assignment).category]!.index(where: { $0.resourceKey == newObject.resourceKey })
            let indexOfCategory = self.categories.index(where: { $0.resourceKey == self.assignments[indexOfAssignment!].category.resourceKey })
            
            let existingAssignment = self.tableView.numberOfRows(inSection: indexOfCategory!) < (self.data[self.categories[indexOfCategory!]]?.count)! ? false : true
            
            existingAssignment == false ? tableView.insertRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) : tableView.reloadRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .fade)
        }

        else if newObject.itemType == "Category" {
            self.categories = NBClient.shared.storedTypes[Category.classIdentifier]! as! [Category]
            self.updateData()
            
            let indexOfCategory = self.categories.index(where: { $0.resourceKey == newObject.resourceKey })
 
            let existingCategory = self.tableView.numberOfSections < self.data.count ? false : true
            
            if !existingCategory {
                tableView.insertSections(IndexSet(integer: indexOfCategory!), with: .left)
            }
            else {
                tableView.reloadSections(IndexSet(integer: indexOfCategory!), with: .fade)
            }
            
        }
        
        else if newObject.itemType == "Grade" {
            let assignment = self.assignments.first(where: { $0.resourceKey == newObject.parent?.resourceKey })
            assignment!.getGradeString()
            self.updateData()
            
            let indexOfAssignment = self.data[assignment!.category]!.index(where: { $0.resourceKey == assignment!.resourceKey })
            let indexOfCategory = self.categories.index(where: { $0.resourceKey == self.assignments[indexOfAssignment!].category.resourceKey })
            
            tableView.reloadRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .fade)
        }
        
        else if newObject.itemType == "Course" {
            self.getTableData()
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if deletedObject.itemType.contains("Assignment") {

            let indexOfAssignment = self.data[(deletedObject as! Assignment).category]!.index(where: { $0.resourceKey == deletedObject.resourceKey })
            let indexOfCategory = self.categories.index(where: { $0.resourceKey == self.assignments[indexOfAssignment!].category.resourceKey })
            if indexOfAssignment != nil { tableView.deleteRows(at: [IndexPath(row: indexOfAssignment!, section: indexOfCategory!)], with: .left) }
            self.assignments = NBClient.shared.storedTypes[Assignment.classIdentifier]! as! [Assignment]
            self.updateData()
            
        }

        else if deletedObject.itemType == "Category" {
            let indexOfCategory = self.categories.index(where: { $0.resourceKey == deletedObject.resourceKey })
            tableView.deleteSections(IndexSet(integer: indexOfCategory!), with: .right)
            self.categories = NBClient.shared.storedTypes[Category.classIdentifier]! as! [Category]
            self.updateData()
        }
        
        else if deletedObject.itemType.contains("Course") {
            if deletedObject.resourceKey == self.selectedCourse.resourceKey {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        
    }
    
    func reloadTableViews() {
    }
}

class AssignmentTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .assignmentsPlaceholders
    }
}
