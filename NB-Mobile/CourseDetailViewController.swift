//
//  CourseDetailViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/2/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Disk


class CourseDetailViewController: UIViewController {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDescriptionLabel: UILabel!
    @IBOutlet weak var courseIdentifierLabel: UILabel!
    @IBOutlet weak var courseLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    var course: Course? {
        didSet {
            //courseNameLabel.text = course?.courseName
            self.title = course?.courseName
            courseDescriptionLabel.text = course?.courseDescription
            courseIdentifierLabel.text = ((course?.courseSubject)! + " " + (course?.courseNumber)!)
            courseLocationLabel.text = course?.location
        }
    }
    
}
