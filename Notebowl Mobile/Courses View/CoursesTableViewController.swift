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

class CoursesTableViewController: AnimatedNavBarViewController, UpdateVC {
    var indexes: Paths = Paths()
    var courses: [Course]!
    var placeholderTableView: CourseTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderTableView = tableView as? CourseTableView
        placeholderTableView?.placeholderDelegate = self

        reloadTable()
    }

    override func setBeforePopNavigationColors() {
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func setNavigationColors(){
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.04705882353, green: 0.4823529412, blue: 0.7568627451, alpha: 1), endColor: #colorLiteral(red: 0.04705882353, green: 0.5294117647, blue: 0.3607843137, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.6), endPoint: CGPoint(x: 0.6, y: 0.9))
        self.navigationController?.view.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    func reloadTable() {
        self.courses = (NBClient.shared.storedTypes.has(key: Course.classIdentifier) ? NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course] : [])
        placeholderTableView?.reloadData()
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
    @IBAction func profileButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDeck", sender: nil)
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
            self.courses = NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]
            var indexOfCourse = self.courses.index(of: newCourse)
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
        if let deleteCourse = deletedObject as? Enrollment {
            log.warning("deletecourse")
            if deleteCourse.parent is Course {
                let indexOfCourse = self.courses.index(where: { $0 == (deletedObject.parent as! Course) })
                NBClient.shared.storedTypes[Course.classIdentifier]!.remove(at: (NBClient.shared.storedTypes[Course.classIdentifier]?.index(of: deletedObject.parent!))!)
                self.courses = NBClient.shared.storedTypes[Course.classIdentifier] as! [Course]
                if indexOfCourse != nil { tableView.deleteRows(at: [IndexPath(row: indexOfCourse!, section: 0)], with: .fade) }
                if tableView.numberOfRows(inSection: 0) == 0 { placeholderTableView?.reloadData() }
            }
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

