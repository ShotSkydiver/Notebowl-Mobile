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

class CoursesTableViewController: UITableViewController, PlaceholderDelegate {
    var courses: [Course]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    var placeholderTableView: TableView?
    var needsUpdate = false
    
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
        if self.needsUpdate {
            getTableData(animated: true)
            self.needsUpdate = false
        }
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
        
        // NBClient.shared.queue.async {
        // DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            TTLog.error("async courses update begin")
            
            // let enrollments = NBClient.shared.storedTypes[Enrollment.classIdentifier]?.filter({ ($0 as! Enrollment).parent. == self.url }) as! [Comment]
            // let enrollments = NBClient.shared.getMappable(Enrollment.self, filters: "[\"_parent:TYPE:Course\",\"_user:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\"]", limit: "100")!
            
            
            /*
            var cachedCourses = [Course]()
            var resourceKeys: String = ""
            for enrollment in enrollments {
                if enrollment.statusIsAccepted {
                    if let objectExists = NBClient.shared.storedTypes[Course.classIdentifier]?.first(where: {$0.resourceKey == enrollment.parent!.resourceKey }) {
                        print("course exists!")
                        cachedCourses.append((objectExists as! Course))
                    }
                    else {
                        print("course doesn't exist!")
                        resourceKeys = (resourceKeys + enrollment.parent!.resourceKey + ",")
                    }
                }
            }
            if resourceKeys.count > 3 {
                
            }
            self.courses = NBClient.shared.getMappable(Course.self, filters: "[\"resourceKey:IN:\(resourceKeys)\"]", limit: "100")
            self.courses.append(contentsOf: cachedCourses)
            */
            
            /*
            for enrollment in enrollments {
                for course in self.courses {
                    if enrollment.parent!.resourceKey == course.resourceKey {
                        if enrollment.lastAccessDate != nil {
                            course.lastUpdated = ("last accessed" + enrollment.lastAccessDate!.relativelyFormatted)
                            course.secondsSinceGradeUpdate = enrollment.lastAccessDate!.timeIntervalSinceReferenceDate
                        }
                        else {
                            course.lastUpdated = "never accessed"
                            course.secondsSinceGradeUpdate = course.secondsSinceUpdate
                        }
                    }
                }
            }
            */
            
            if self.courses == nil {
                TTLog.error("this shouldn't be nil!")
                if NBClient.shared.storedTypes[Course.classIdentifier]! != nil {
                    self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
                }
                else {
                    TTLog.error("courses stored cache is nil!")
                    
                }
            }
            
            
            // .filter({ ($0 as! Enrollment).parent. == self.url }) as! [Comment]
            
            // self.courses.sort() { $0.secondsSinceGradeUpdate > $1.secondsSinceGradeUpdate }
            self.tableView.reloadData()
            
            // DispatchQueue.main.async {
            if animated! {
                self.bgView.showViewAnimated(false)
            }
            // }
        }
    }
    
    func registerSocketHandler() {
        NBSocket.shared.manager.defaultSocket.on(NBClient.shared.getCurrentUser().resourceKey) { (data, ackEmitter) in
            guard let message = data[0] as? String else { return }
            if let data = message.data(using: .utf8) {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    // let updateUrl: URL = URL(string: JSON["updateUrl"] as! String)!
                    let mapped = Mapper<Generic>().map(JSON: JSON)!
                    if mapped.itemType!.contains("CourseUser") {
                        let mappedEnroll = mapped as! Response<Enrollment>
                        
                        //TODO: WTF COUNTS AS LASTACCESSDATE AND WHY DOES IT NEVER NOT BECOME NULL
                        if mappedEnroll.actionType != .deleted {
                            if let courseForEnroll = (NBClient.shared.storedTypes[Course.classIdentifier]!.first(where: {$0.resourceKey == mappedEnroll.updateUrl!.resourceKey }) as? Course) {
                                courseForEnroll.refresh()
                            }
                        }
                        NBClient.shared.storedTypes[Course.classIdentifier]!.sort(by: { ($0 as! Course).secondsSinceUpdate > ($1 as! Course).secondsSinceUpdate })
                        self.courses = NBClient.shared.storedTypes[Course.classIdentifier]! as! [Course]
                        
                        self.tableView.beginUpdates()
                        // self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        self.tableView.endUpdates()
                    }
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

