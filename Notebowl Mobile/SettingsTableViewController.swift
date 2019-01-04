//
//  SettingsTableViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 6/18/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import PKHUD

class SettingsTableViewController: UITableViewController {
    var settings: [Setting]!
    var settingsArray: [SettingsGroup?]!

    var loadingView: NBLoadingView!
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SettingsTableViewHeader.register(in: tableView)
        NotificationSettingCell.register(in: tableView)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)

        self.getTableData()
    }

    func getTableData() {
        loadingView.alpha = 1.0
        bgView.alpha = 1.0
        DispatchQueue.main.async {
            self.settings = Setting.getCache()

            let result = NBNetworking.shared.request(url: RequestKind.rpc.requestUrl(url: "users/getSettingsList"))

            if let jsonObject = result.json as AnyObject?, let nestedJson = jsonObject.value(forKeyPath: "result"), let nestedData = try? JSONSerialization.data(withJSONObject: nestedJson), let nestedString = String(data: nestedData, encoding: .utf8) {
                let mappedResult = Mapper<SettingDefaults>().map(JSONString: nestedString)
                self.settingsArray = mappedResult?.settingsArray
            }
            self.tableView.reloadData()
            self.bgView.alpha = 0.0
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ( self.settingsArray != nil ? self.settingsArray.count : 4 )
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsTableViewHeader.dequeue(from: tableView)!
        header.setupHeader(showButton: false)
        header.sectionTitle.text = ( self.settingsArray != nil ? self.settingsArray[section]!.sectionName.uppercased() : "" )
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( self.settingsArray != nil ? self.settingsArray[section]!.sectionMobileSettings.count : 0 )
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationSettingCell.dequeue(from: tableView)!
        if self.restorationIdentifier == "mobileSettingsView" {
            cell.configure(setting: self.settingsArray[indexPath.section]!.sectionMobileSettings[indexPath.row])
        } else if self.restorationIdentifier == "emailSettingsView" {
            cell.configure(setting: self.settingsArray[indexPath.section]!.sectionEmailSettings[indexPath.row])
        } else if self.restorationIdentifier == "webSettingsView" {
            cell.configure(setting: self.settingsArray[indexPath.section]!.sectionWebSettings[indexPath.row])
        }

        return cell
    }
}
