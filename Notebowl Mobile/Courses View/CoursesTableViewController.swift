//
//  CoursesTableViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 12/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import HGPlaceholders

class CoursesTableViewController: UITableViewController, PlaceholderDelegate {
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var placeholderTableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        placeholderTableView = tableView as? TableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        
        self.getTableData()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 5.5
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
        
        self.view.layer.masksToBounds = false
        
    }
    
    func getTableData() {
        self.loadingView.showLoadView(true)

        DispatchQueue.main.async {
            var currentTermFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Term.self, filters: "[\"permalink:IN:spring-2018\"]", sortBy: "updatedAt:desc", limit: "1")!)
            if currentTermFilter.count < 10 {
                print("current term filter: ", currentTermFilter)
                currentTermFilter = NBClient.shared.buildFilterString(from: NBClient.shared.getMappable(Term.self, filters: "[\"permalink:IN:forever-term\"]", sortBy: "updatedAt:desc", limit: "1")!)
            }
            self.courses = NBClient.shared.initArray(from: NBClient.shared.getMappable(Course.self, filters: "[\"_term:IN:\(currentTermFilter)\"]", sortBy: "updatedAt:desc", limit: "10")!)
            
            self.courses.sort() { $0.secondsSinceGradeUpdate > $1.secondsSinceGradeUpdate }
            self.tableView.reloadData()
            self.bgView.showViewAnimated(false)
        }
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        placeholderTableView?.showDefault()

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
        
        let courseForCell = self.courses[indexPath.row]
        cell.courseTitle.text = courseForCell.name
        cell.courseNumber.text = courseForCell.courseCode
        cell.lastUpdated.text = courseForCell.lastUpdated
        cell.showCell(true)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderCell = sender as? CoursesTableViewCell {
            let indexPath = tableView.indexPath(for: senderCell)
            let destVC = segue.destination as! CourseAssignmentsTableView
            
            destVC.selectedCourse = self.courses[indexPath!.row]
        }
    }
}

class CourseTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .coursesPlaceholders
    }
}

