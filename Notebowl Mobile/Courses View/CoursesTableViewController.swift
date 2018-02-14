//
//  CoursesTableViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
class CoursesTableViewController: UITableViewController {
    var courses: [Course]!
    var loadingView: NBLoadingView!
    
    private var lastSelected: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = NBLoadingView()
        self.view.addSubview(loadingView!)
        loadingView.addUntitled2Animation()
        self.getTableData()
    }
    
    func getTableData() {
        loadingView.showLoadView(true)
        
        DispatchQueue.main.async {
            let coursesFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Term.self)!)
            self.courses = NBClient.shared.getMappable(Course.self, filters: "[\"_term:IN:\(coursesFilter)\"]", sortBy: "updatedAt:desc", limit: "10")
            
            for course in self.courses {
                course.refreshGrades()
            }
            
            self.courses.sort() { $0.secondsSinceUpdate > $1.secondsSinceUpdate }
        
            self.loadingView.showLoadView(false)
            self.tableView.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.courses != nil) {
           return self.courses.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CoursesTableViewCell
        
        if (self.courses) != nil {
            let course = self.courses[indexPath.row]
            cell.courseTitle.text = course.name
            cell.courseNumber.text = course.courseCode
            cell.lastUpdated.text = course.lastUpdated
            cell.currentGrade.text = course.userCourseGrade
            cell.showCell(true)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderCell = sender as? CoursesTableViewCell {
            let indexPath = tableView.indexPath(for: senderCell)
            let destVC = segue.destination as! CoursesDetailViewController
            
            destVC.selectedCourse = self.courses[indexPath!.row]
        }
    }
}

