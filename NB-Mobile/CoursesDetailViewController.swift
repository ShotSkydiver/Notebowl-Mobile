//
//  CoursesDetailViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 12/12/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class CoursesDetailViewController: UIViewController {
    
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDescription: UILabel!
    @IBOutlet weak var courseGrade: UILabel!
    
    var selectedCourse: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.selectedCourse.courseCode
        self.courseTitle.text = self.selectedCourse.name
        self.courseDescription.text = self.selectedCourse.desc
        self.courseGrade.text = self.selectedCourse.userCourseGrade
    }
}
