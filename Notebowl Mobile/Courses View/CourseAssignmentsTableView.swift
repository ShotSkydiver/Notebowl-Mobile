//
//  CourseAssignmentsTableView.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit

class CourseAssignmentsTableView: UITableViewController {
    var assignments: [Assignment]!
    var data = [Category: [Assignment]]()
    var selectedCourse: Course!
    var categories: [Category]!
    
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCourse.courseCode
        self.categories = self.selectedCourse.categories
        
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        self.getTableData()
    }
    
    func getTableData() {
        loadingView.showLoadView(true)
        DispatchQueue.main.async {
            
            self.assignments = NBClient.shared.getMappable(Assignment.self, filters: "[\"_parent:IN:\(self.selectedCourse.url.absoluteString)\"]")!
            self.categories = NBClient.shared.getMappable(Category.self, filters: "[\"_parent:IN:\(self.selectedCourse.url.absoluteString)\"]")!
            
            for assignment in self.assignments {
                assignment.getGradeString()
            }
    
            for category in self.categories! {
                let filtered = self.assignments.filter({ $0.category.absoluteString == category.url.absoluteString })
                if (filtered.count > 0) {
                    self.data[category] = filtered
                }
                else {
                    self.categories.remove(at: self.categories.index(of: category)!)
                }
            }
            self.tableView.reloadData()
            self.bgView.showViewAnimated(false)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
