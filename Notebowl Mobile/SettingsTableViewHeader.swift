//
//  SettingsTableViewHeader.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 6/20/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import UIKit

class SettingsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var sectionTitle: KerningLabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let parentVC = parentViewController as? SettingsTableViewController {
            parentVC.dismiss(animated: true, completion: nil)
        }
    }

    func setupHeader(showButton: Bool) {
        if showButton {
            buttonStackView.isHidden = false
        } else {
            buttonStackView.isHidden = true
        }
    }
}

extension SettingsTableViewHeader {
    static var reuseId: String {
        return "SettingsTableViewHeader"
    }

    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "SettingsTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: self.reuseId)
    }

    class func dequeue(from tableView: UITableView) -> SettingsTableViewHeader? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseId)
        return header as? SettingsTableViewHeader
    }
}
