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
    
    var loadingView: NBLoadingView?
    
    private var lastSelected: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Refresh grades")
        self.tableView.refreshControl!.tintColor = UIColor(named: "Notebowl Blue")
        self.tableView.refreshControl!.addTarget(self, action: #selector(CoursesTableViewController.refreshCourseData(sender:)), for: .valueChanged)
        
        loadingView = NBLoadingView()
        loadingView?.showLoadView(false)
        self.view.addSubview(loadingView!)
        loadingView?.addUntitled2Animation()
        self.getTableData()
    }
    
    func getTableData() {
        loadingView?.showLoadView(true)
        DispatchQueue.main.async {
            self.courses = NBClient.shared.getMappable(Course.self)
            
            for course in self.courses {
                course.refreshGrades()
            }
            
            self.title = "Spring 2018"
            self.navigationController?.title = "Courses"
            
            self.courses.sort() { $0.secondsSinceUpdate! > $1.secondsSinceUpdate! }
        
            self.loadingView?.showLoadView(false)
            self.tableView.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @objc func refreshCourseData(sender: UIRefreshControl) {
        self.getTableData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.courses != nil) {
           return self.courses.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CoursesTableViewCell
        cell.showCell(false)
        
        if (self.courses) != nil {
            let course = self.courses[indexPath.row]
            cell.courseTitle.text = course.name
            cell.courseNumber.text = course.courseCode
            cell.lastUpdated.text = course.lastUpdated
            cell.currentGrade.text = course.userCourseGrade
            cell.showCell(true)
        }
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 59.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        cell.selectedBackgroundView = selectedView
        
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

