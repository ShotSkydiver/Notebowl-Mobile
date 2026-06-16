//
//  CourseAssignmentsTableView.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/28/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import HGPlaceholders
import Tamamushi
import GSKStretchyHeaderView
import PKHUD

class CourseAssignmentsTableView: AnimatedNavBarViewController {
    var assignments: [AssignmentAssessment]!
    var selectedCourse: Course!
    var gradientColors: [UIColor]!
    var gradientImage: UIImage!
    var stretchyHeaderView: AssignmentsHeaderView!

    var loadingView: NBLoadingView!
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.title = selectedCourse.courseCode

        gradientColors = selectedCourse.hexValuesFromGradientHeader()
        gradientImage = TMGradientNavigationBar().generateGradientImage(direction: .horizontal, startColor: gradientColors[0], endColor: gradientColors[1], startPoint: CGPoint(x: 0.0, y: 0.4), endPoint: CGPoint(x: 0.8, y: 0.7), height: 500.0)

        stretchyHeaderView = AssignmentsHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 160))
        stretchyHeaderView.label.text = selectedCourse.name
        stretchyHeaderView.detailLabel.text = selectedCourse.term.title
        stretchyHeaderView.label.accessibilityIdentifier = "courseAssignmentsHeaderName"
        stretchyHeaderView.detailLabel.accessibilityIdentifier = "courseAssignmentsHeaderTerm"
        stretchyHeaderView.backgroundColor = UIColor(patternImage: gradientImage)
        stretchyHeaderView.expansionMode = GSKStretchyHeaderViewExpansionMode.topOnly
        stretchyHeaderView.manageScrollViewInsets = false
        tableView.addSubview(stretchyHeaderView)

        tableView.separatorColor = tableView.backgroundColor
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 24, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: (self.stretchyHeaderView.maximumContentHeight-self.stretchyHeaderView.minimumContentHeight)+14))

        CourseDetailViewCell.register(in: tableView)
        reloadTable()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingAssignment(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAssignment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingAssignment(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingAssessmentQuestion(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAssessmentQuestion"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingGrade(_:)), name: NSNotification.Name("ModelDidFinishUpdatingGrade"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingPostsComments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingPostsComments(_:)), name: NSNotification.Name("ModelDidFinishUpdatingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingSubmission(_:)), name: NSNotification.Name("ModelDidFinishUpdatingSubmission"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingSubmission(_:)), name: NSNotification.Name("ModelDidFinishUpdatingAssessmentSubmission"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishUpdatingCourse(_:)), name: NSNotification.Name("ModelDidFinishUpdatingCourse"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingAssignment(_:)), name: NSNotification.Name("ModelDidFinishDeletingAssignment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingAssignment(_:)), name: NSNotification.Name("ModelDidFinishDeletingAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingPostsComments(_:)), name: NSNotification.Name("ModelDidFinishDeletingPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingPostsComments(_:)), name: NSNotification.Name("ModelDidFinishDeletingComment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDeletingEnrollment(_:)), name: NSNotification.Name("ModelDidFinishDeletingEnrollment"), object: nil)
    }

    func updateRows(from object: NBModel) {
        guard let oldIndex = self.assignments.firstIndex(where: { ($0 as! NBModel) == object }) else {
            return
        }

        self.updateSorting()

        guard let newIndex = self.assignments.firstIndex(where: { ($0 as! NBModel) == object }) else {
            return
        }

        if tableView.numberOfRows(inSection: 0) >= self.assignments.count {
            if oldIndex != newIndex {
                tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
            }
            tableView.reloadRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        } else {
            tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .left)
        }
    }

    @objc func finishUpdatingAssignment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }

        if !self.assignments.contains(where: { ($0 as! NBModel) == newObject }) {
            self.assignments.insert((newObject as! AssignmentAssessment), at: self.assignments.startIndex)
        }

        updateRows(from: newObject)
    }

    @objc func finishUpdatingAssessmentQuestion(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newQuestion = dict["object"] as? AssessmentQuestion else {
            return
        }

        if let indexOfAssessment = self.assignments.index(where: { ($0 as! NBModel) == newQuestion.parent }) {
            tableView.reloadRows(at: [IndexPath(row: indexOfAssessment, section: 0)], with: .fade)
        }
    }

    @objc func finishUpdatingGrade(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newGrade = dict["object"] as? Grade else {
            return
        }

        if newGrade.owner!.parent?.enrollmentForUser?.role == .professor || newGrade.owner!.parent?.enrollmentForUser?.role == .admin {
            return
        }

        updateRows(from: newGrade.owner!)
    }

    @objc func finishUpdatingSubmission(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }

        if newObject.parent!.parent?.enrollmentForUser?.role == .professor || newObject.parent!.parent?.enrollmentForUser?.role == .admin {
            return
        }

        updateRows(from: newObject.parent!)
    }

    @objc func finishUpdatingPostsComments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newObject = dict["object"] as? NBModel else {
            return
        }

        if newObject.getParentByType(Post.self, withSelf: true)!.isPostFeedback || !((newObject as! PostsComments).creator == NBClient.shared.getCurrentUser()) {
            return
        }

        updateRows(from: newObject.getParentByType(Assignment.self))
    }

    @objc func finishUpdatingCourse(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let newCourse = dict["object"] as? Course else {
            return
        }

        if newCourse != self.selectedCourse {
            return
        }
    }

    @objc func finishDeletingAssignment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedObject = dict["object"] as? NBModel else {
            return
        }

        guard let index = self.assignments.firstIndex(where: { ($0 as! NBModel) == deletedObject}) else {
            return
        }

        self.assignments.removeAll(where: { ($0 as! NBModel) == deletedObject})

        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)

        self.updateSorting()
    }

    @objc func finishDeletingPostsComments(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedObject = dict["object"] as? NBModel else {
            return
        }

        if deletedObject.getParentByType(Post.self, withSelf: true)!.isPostFeedback || !((deletedObject as! PostsComments).creator == NBClient.shared.getCurrentUser()) {
            return
        }

        updateRows(from: deletedObject.getParentByType(Assignment.self))
    }

    @objc func finishDeletingEnrollment(_ notification: NSNotification) {
        guard let dict = notification.userInfo as NSDictionary?, let deletedEnrollment = dict["object"] as? Enrollment else {
            return
        }

        if deletedEnrollment.user != NBClient.shared.getCurrentUser() || deletedEnrollment.parent != self.selectedCourse {
            return
        }

        self.navigationController?.popViewController(animated: true)
    }

    override func setNavigationColors() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        if gradientImage != nil { navigationController?.navigationBar.barTintColor = UIColor(patternImage: gradientImage) }
        navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func reloadTable() {
        HUD.show(.progress)
        DispatchQueue.main.async {
            if self.selectedCourse.courseAssignments.isEmpty {
                var assigns = NBClient.shared.requireByReference(Assignment.self, property: "parent", value: self.selectedCourse)
                if let userRole = (assigns.first)?.parent?.enrollmentForUser.role, userRole == .TA {
                    assigns = assigns.filter({$0.gradeOnly == false})
                }
                var assignmentFilter = NBClient.shared.buildFilterString(from: assigns)
                _ = NBClient.shared.requireByReferences(Submission.self, property: "parent", values: assigns)

                var assess = NBClient.shared.requireByReference(Assessment.self, property: "parent", value: self.selectedCourse)
                let assessSubs = NBClient.shared.requireByReferences(AssessmentSubmission.self, property: "parent", values: assess)
                let assessQs = NBClient.shared.requireByReferences(AssessmentQuestion.self, property: "parent", values: assess)

                let posts = NBClient.shared.getMappable(Post.self, filters: "[\"creator:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\",\"parent:IN:\(assignmentFilter)\"]")
                let postsFilter = NBClient.shared.buildFilterString(from: posts!)
                _ = NBClient.shared.getMappable(Comment.self, filters: "[\"creator:IN:\(NBClient.shared.getCurrentUser().url.absoluteString)\",\"parent:IN:\(postsFilter)\"]")

                assignmentFilter = (assignmentFilter + NBClient.shared.buildFilterString(from: assess) + NBClient.shared.buildFilterString(from: assessSubs))
                _ = NBClient.shared.getMappable(Grade.self, filters: "[\"owner:IN:\(assignmentFilter)\"]")
            }

            self.assignments = self.selectedCourse.courseAssignments
            self.sortAssignments()
            self.tableView.reloadData()
            self.setupObservers()
            HUD.hide(animated: true)
        }
    }

    func sortAssignments() {
        self.assignments.sort() {
            if let userRole = ($0 as! NBModel).parent?.enrollmentForUser.role, userRole == .professor || userRole == .admin || userRole == .TA, $0.status.sortValueProfessor != $1.status.sortValueProfessor {
                return $0.status.sortValueProfessor < $1.status.sortValueProfessor
            } else if $0.status.sortValue != $1.status.sortValue {
                return $0.status.sortValue < $1.status.sortValue
            } else if $0.status == .NotPublished {
                return ($0 as! NBModel).updatedAt > ($1 as! NBModel).updatedAt
            } else if $0.status == .Graded {
                return $0.userGrade.updatedAt > $1.userGrade.updatedAt
            } else if $0.status == .Open || $0.status == .NotAvailableYet {
                return $0.availableDate > $1.availableDate
            } else {
                return $0.dueDate > $1.dueDate
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assignments != nil ? self.assignments.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseDetailViewCell.dequeue(from: tableView)!
        let assignment = self.assignments[indexPath.row]
        cell.configure(assignment: assignment, color: gradientColors[0])
        return cell
    }

    func updateSorting() {
        self.assignments = self.selectedCourse.courseAssignments
        self.sortAssignments()
    }
}

class AssignmentsHeaderView: GSKStretchyHeaderView {
    let maxFontSize: CGFloat = 22
    let minFontSize: CGFloat = 17

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 40, width: self.contentView.frame.size.width-40, height: self.contentView.frame.size.height - 40))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: self.maxFontSize, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.groupTableViewBackground
        label.text = "Course Name"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 95, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 95))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.groupTableViewBackground
        label.text = "Course Details"
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.maximumContentHeight = 160
        self.minimumContentHeight = 88

        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.detailLabel)
        self.backgroundColor = UIColor.orange
    }

    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        super.didChangeStretchFactor(stretchFactor)

        let alpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        self.label.alpha = alpha
        self.detailLabel.alpha = alpha
    }
}
