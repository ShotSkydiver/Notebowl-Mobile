//
//  CoursesTableViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/2/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import ListPlaceholder

class CoursesTableViewController: UITableViewController {
    
    //@IBOutlet weak var coursesTableView: UITableView!
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        self.tableView.showLoader()
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(CoursesTableViewController.removeLoader), userInfo: nil, repeats: false)
        
        API.getCourses { (result) in
            switch result {
            case .success(let resultCourses):
                self.courses = resultCourses.result
                API.saveCoursesToDisk(courses: self.courses)
                print("got courses!")
                //self.tableView.hideLoader()
                //self.tableView.reloadData()
            case .failure(let error):
                fatalError("error: \(error)")
            }
        }

    }
    
    @objc func removeLoader()
    {
        self.tableView.hideLoader()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        if let cell = cell as? CoursesTableViewCell {
            cell.course = self.courses[(indexPath as IndexPath).row]
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail" {
            if let courseVC = segue.destination as? CourseDetailViewController,
                let cell = sender as? CoursesTableViewCell {
                print("segue to course details")
            }
        }
    }
}
