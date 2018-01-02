//
//  CoursesTableViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/12/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class CoursesTableViewController: UITableViewController {
    var courses: [Course]!
    
    private var lastSelected: IndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = NBClient.shared.get(Course.self) as! [Course]
        for course in courses {
            print("course term: ", course.term.first)
            
        }
        self.title = courses.first?.term.first?.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CoursesTableViewCell
        cell.courseTitle.text = courses[indexPath.row].name
        cell.courseNumber.text = courses[indexPath.row].courseCode
        cell.courseDescription.text = courses[indexPath.row].description
        cell.currentGrade.text = "88.5%"
        
        return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            
            let destination = segue.destination as! CoursesDetailViewController
            destination.selectedCourse = courses[self.tableView.indexPathForSelectedRow!.row]
            
        }
    }
}
