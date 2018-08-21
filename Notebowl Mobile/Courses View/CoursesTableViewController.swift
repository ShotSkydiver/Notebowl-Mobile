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
import QuartzCore
import Tamamushi
import ObjectMapper

class CoursesTableViewController: UITableViewController, UpdateVC {
    var indexes: Paths = Paths()
    var courses: [Course]!
    var placeholderTableView: CourseTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderTableView = tableView as? CourseTableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1))
        
        reloadTable()
    }
    
    func reloadTable() {
        self.courses = (NBClient.shared.storedTypes.has(key: Course.classIdentifier) ? NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course] : [])
        placeholderTableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage.init()
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 7.5
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.masksToBounds = false
        
        self.view.layer.masksToBounds = false
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
        cell.lastUpdated.text = "Updated \(courseForCell.updatedAt.relativeFormat)"
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

extension CoursesTableViewController {
    func handleUpdated(newObject: NBModel) {
        if let newCourse = newObject as? Course {
            var indexOfCourse = self.courses.index(where: { $0 == newCourse })
            self.courses = NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]
            let existingCourse = self.tableView.numberOfRows(inSection: 0) < self.courses.count ? false : true
            
            placeholderTableView?.showDefault()
            if !existingCourse { tableView.insertRows(at: [IndexPath(row: indexOfCourse!, section: 0)], with: .left) }
            else {
                self.tableView.moveRow(at: IndexPath(row: indexOfCourse!, section: 0), to: IndexPath(row: 0, section: 0))
                indexOfCourse = 0
                tableView.reloadRows(at: [IndexPath(row: indexOfCourse!, section: 0)], with: .fade)
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if ["CourseUser","Course"].contains(deletedObject.itemType) {
            let indexOfCourse = self.courses.index(where: { $0 == (deletedObject as! Course) })
            if indexOfCourse != nil { tableView.deleteRows(at: [IndexPath(row: indexOfCourse!, section: 0)], with: .fade) }
            if tableView.numberOfRows(inSection: 0) == 0 { placeholderTableView?.reloadData() }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) {}
    func reloadTableViews() {}
}

extension CoursesTableViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        self.reloadTable()
    }
}

class CourseTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .makePlaceholdersProvider(from: .emptyCourses)
    }
}

