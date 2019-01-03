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

class CoursesTableViewController: AnimatedNavBarViewController {
    var courses: [Course]!
    var placeholderTableView: CourseTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderTableView = tableView as? CourseTableView
        placeholderTableView?.placeholderDelegate = self

        reloadTable()
        setupObservers()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingCourse(_:)), name: NSNotification.Name("ModelDidFinishUpdatingCourse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingEnrollment(_:)), name: NSNotification.Name("ModelDidFinishUpdatingEnrollment"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingEnrollment(_:)), name: NSNotification.Name("ModelDidFinishDeletingEnrollment"), object: nil)
    }

    @objc func finishUpdatingCourse(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newCourse = dict["object"] as? Course else {
            return
        }

        guard let index = self.courses.index(of: newCourse) else {
            return
        }

        self.courses.sortByDate()
        let newIndex = self.courses.index(of: newCourse)!

        tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: newIndex, section: 0))
        tableView.reloadRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }

    @objc func finishUpdatingEnrollment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newEnrollment = dict["object"] as? Enrollment else {
            return
        }

        if newEnrollment.user != NBClient.shared.getCurrentUser() {
            return
        }

        guard let newCourse = newEnrollment.parent as? Course else {
            return
        }

        if !self.courses.contains(newCourse) {
            self.courses.insert(newCourse, at: self.courses.startIndex)
            self.courses.sortByDate()
        }

        let index = self.courses.index(of: newCourse)!

        if tableView.numberOfRows(inSection: 0) >= self.courses.count {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }
    }

    @objc func finishDeletingEnrollment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedEnrollment = dict["object"] as? Enrollment else {
            return
        }

        if deletedEnrollment.user != NBClient.shared.getCurrentUser() {
            return
        }

        guard let deletedCourse = deletedEnrollment.parent as? Course, let index = self.courses.index(of: deletedCourse) else {
            return
        }

        self.courses.removeAll(deletedCourse)

        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    override func setBeforePopNavigationColors() {
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func setNavigationColors() {
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
        if self.courses != nil {
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

