//
//  CoursesTableViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/12/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

@available(iOS 11.0, *)
class CoursesTableViewController: UITableViewController {
    var courses: [Course]!
    
    private var lastSelected: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Refresh grades")
        self.tableView.refreshControl!.tintColor = UIColor(named: "Notebowl Blue")
        self.tableView.refreshControl!.addTarget(self, action: #selector(CoursesTableViewController.refreshCourseData(sender:)), for: .valueChanged)
        
        self.view.showAnimatedSkeleton()
        self.getTableData()
    }
    
    func getTableData() {
        DispatchQueue.main.async {
            self.courses = NBClient.shared.getMappable(Course.self)
            
            for course in self.courses {
                course.refreshGrades()
            }
            
            self.title = "Spring 2018"
            self.navigationController?.title = "Courses"
        
            if (self.tableView.refreshControl!.isRefreshing) { self.tableView.refreshControl!.endRefreshing() }
            if (self.view.isSkeletonActive) { self.view.hideSkeleton(reloadDataAfter: false) }
        
            self.tableView.reloadData()
        }
    }

    
    @objc func refreshCourseData(sender: UIRefreshControl) {
        self.tableView.refreshControl!.beginRefreshing()
        self.getTableData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.courses != nil) {
           return self.courses.count
        }
        else {
            return 7
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CoursesTableViewCell

        if (self.courses) != nil {
            let course = self.courses[indexPath.row]
            cell.courseTitle.text = course.name
            cell.courseNumber.text = course.courseCode
            cell.lastUpdated.text = course.lastUpdated
            cell.currentGrade.text = course.userCourseGrade
        }
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 59.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            
            let destination = segue.destination as! CoursesDetailViewController
            destination.selectedCourse = self.courses[self.tableView.indexPathForSelectedRow!.row]
            
        }
    }
}

@available(iOS 11.0, *)
extension CoursesTableViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "courseCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}
