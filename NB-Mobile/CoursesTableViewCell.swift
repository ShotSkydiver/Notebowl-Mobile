//
//  CoursesTableViewCell.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/2/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDescriptionLabel: UILabel!
    @IBOutlet weak var courseIdentifierLabel: UILabel!
    
    var course: Course? {
        didSet {
            courseNameLabel.text = course?.courseName
            courseDescriptionLabel.text = course?.courseDescription
            courseIdentifierLabel.text = ((course?.courseSubject)! + " " + (course?.courseNumber)!)
        }
    }
}
