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
        
        registerSocketHandler()
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
    func handleUpdate(mapped: Generic, updateUI: Bool) {
        if mapped.itemType! == "CourseUser" {
            let mappedEnroll = mapped as! Response<Enrollment>
            if mappedEnroll.actionType != .deleted {
                if let courseForEnroll = (NBClient.shared.storedTypes[Course.classIdentifier]!.first(where: {$0.resourceKey == mappedEnroll.updateUrl!.resourceKey }) as? Course) {
                    courseForEnroll.refresh()
                }
            }
            NBClient.shared.storedTypes[Course.classIdentifier]!.sort(by: { ($0 as! Course).secondsSinceUpdate > ($1 as! Course).secondsSinceUpdate })
            self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
            if updateUI {
                self.tableView.beginUpdates()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    func registerSocketHandler() {
        NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    
                    self.handleUpdate(mapped: mapped, updateUI: true)
                }
                catch let error {
                    print("Error parsing json: \(error)")
                }
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

class CourseTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .coursesPlaceholders
    }
}

