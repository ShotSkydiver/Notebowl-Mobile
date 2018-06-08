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

class CoursesTableViewController: UITableViewController, PlaceholderDelegate, UpdateVC {
    var indexes: Paths = Paths()
    
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var placeholderTableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        self.bgView.alpha = 0.0
        
        placeholderTableView = tableView as? TableView
        placeholderTableView?.placeholderDelegate = self
        
        setupNavBar()
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (navigationController?.navigationBar)!, direction: .horizontal, startColor: #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1), endColor: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        self.getTableData(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func getTableData(animated: Bool? = false) {
        if animated! {
            self.loadingView.showLoadView(true)
            self.bgView.showViewAnimated(true)
        }
        DispatchQueue.main.async {
            if self.courses == nil {
                TTLog.error("this shouldn't be nil!")
            }
            self.tableView.reloadData()
            
            if animated! {
                self.bgView.showViewAnimated(false)
            }
        }
    }

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        placeholderTableView?.showDefault()

        self.getTableData(animated: true)
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

extension CoursesTableViewController {
    func handleUpdated(newObject: NBModel) {
        if ["CourseUser","Course"].contains(newObject.itemType) {
            newObject.refresh()
            
            NBClient.shared.storedTypes[Course.classIdentifier]!.sort(by: { ($0 as! Course).secondsSinceUpdate > ($1 as! Course).secondsSinceUpdate })
            self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
            indexes.reloadIndexPaths = self.tableView.indexPathsForVisibleRows!
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if ["CourseUser","Course"].contains(deletedObject.itemType) {
            if let assignmentVC = self.navigationController?.topViewController as? CourseAssignmentsTableView {
                if deletedObject.resourceKey == assignmentVC.selectedCourse.resourceKey {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let indexOfCourse = self.courses.index(where: { $0.resourceKey == deletedObject.resourceKey })
            if indexOfCourse != nil { indexes.deleteIndexPaths.append(IndexPath(row: indexOfCourse!, section: 0)) }
        }
        
    }
    
    func handleElapsed(elapsedObject: NBModel) {
        
    }
    
    func reloadTableViews() {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: self.indexes.reloadIndexPaths, with: .fade)
        self.tableView.insertRows(at: self.indexes.insertIndexPaths, with: .left)
        self.tableView.deleteRows(at: self.indexes.deleteIndexPaths, with: .right)
        self.tableView.endUpdates()
        self.indexes = Paths()
        
    }
}

class CourseTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .coursesPlaceholders
    }
}

