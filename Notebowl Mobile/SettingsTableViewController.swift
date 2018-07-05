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


class SettingsTableViewController: UITableViewController, UpdateVC {
    var indexes: Paths = Paths()
    var settings: [Setting]!

    var settingsArray: [SettingsGroup]!

    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
        
        SettingsTableViewHeader.register(in: tableView)
        NotificationSettingCell.register(in: tableView)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
        self.getTableData()
    }
    
    func getTableData() {
        loadingView.showLoadView(true)
        bgView.showViewAnimated(true)
        DispatchQueue.main.async {
            if NBClient.shared.storedTypes[Setting.classIdentifier] != nil {
                self.settings = NBClient.shared.storedTypes[Setting.classIdentifier] as! [Setting]
            }
            
            
            let result = NBNetworking.shared.request(url: RequestKind.rpc.requestUrl(url: "users/getSettingsList"))
            let nestedData = try? JSONSerialization.data(withJSONObject: (result.json as AnyObject).value(forKeyPath: "result")!)
            let mappedResult = Mapper<SettingDefaults>().map(JSONString: String(data: nestedData!, encoding: .utf8)!)
            
            self.settingsArray = mappedResult?.settingsArray
   
            self.tableView.reloadData()
            self.bgView.showViewAnimated(false)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ( self.settingsArray != nil ? self.settingsArray.count : 4 )
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsTableViewHeader.dequeue(from: tableView)!
        header.setupHeader(showButton: false)
        header.sectionTitle.text = ( self.settingsArray != nil ? self.settingsArray[section].sectionName.uppercased() : "" )
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( self.settingsArray != nil ? self.settingsArray[section].sectionMobileSettings.count : 0 )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationSettingCell.dequeue(from: tableView)!
        
        if self.restorationIdentifier == "mobileSettingsView" { cell.configure(setting: self.settingsArray[indexPath.section].sectionMobileSettings[indexPath.row]) }
        else if self.restorationIdentifier == "emailSettingsView" { cell.configure(setting: self.settingsArray[indexPath.section].sectionEmailSettings[indexPath.row]) }
        
        
        return cell
    }
}


extension SettingsTableViewController {
    func handleUpdated(newObject: NBModel) {
        if newObject.itemType == "Setting" {
            self.settings = NBClient.shared.storedTypes[Setting.classIdentifier] as! [Setting]

            for section in self.settingsArray {
                let foundSetting: SettingsDefault = (self.restorationIdentifier == "mobileSettingsView" ? section.sectionMobileSettings.first(where: {$0.key == (newObject as! Setting).key}) : section.sectionEmailSettings.first(where: {$0.key == (newObject as! Setting).key}) )!
                foundSetting.findSetting()
                
                let indexRow = (self.restorationIdentifier == "mobileSettingsView" ? section.sectionMobileSettings.index(where: {$0.name == foundSetting.name}) : section.sectionEmailSettings.index(where: {$0.name == foundSetting.name}))
                let cellIndexPath = IndexPath(row: indexRow!, section: self.settingsArray.index(where: { $0.sectionName == section.sectionName })!)
                guard let notificationCell = self.tableView.cellForRow(at: cellIndexPath) as? NotificationSettingCell else { return }
                if (notificationCell.settingSwitch.isOn == (newObject as! Setting).value) {
                    TTLog.debug("already set previouisly!")
                }
                else {
                    notificationCell.settingSwitch.setOn((newObject as! Setting).value, animated: true)
                }
                
            }
        }
    }
    
    func handleDeleted(deletedObject: NBModel) {
        if deletedObject.itemType == "Setting" {
            self.settings = NBClient.shared.storedTypes[Setting.classIdentifier] as! [Setting]
            for section in self.settingsArray {
                let foundSetting: SettingsDefault = (self.restorationIdentifier == "mobileSettingsView" ? section.sectionMobileSettings.first(where: {$0.key == (deletedObject as! Setting).key}) : section.sectionEmailSettings.first(where: {$0.key == (deletedObject as! Setting).key}) )!
                foundSetting.findSetting()
                
                let indexRow = (self.restorationIdentifier == "mobileSettingsView" ? section.sectionMobileSettings.index(where: {$0.name == foundSetting.name}) : section.sectionEmailSettings.index(where: {$0.name == foundSetting.name}))
                let cellIndexPath = IndexPath(row: indexRow!, section: self.settingsArray.index(where: { $0.sectionName == section.sectionName })!)
                guard let notificationCell = self.tableView.cellForRow(at: cellIndexPath) as? NotificationSettingCell else { return }
                if (notificationCell.settingSwitch.isOn == foundSetting.defaultValue) {
                    TTLog.debug("already set previouisly!")
                }
                else {
                    notificationCell.settingSwitch.setOn(foundSetting.defaultValue, animated: true)
                }

            }
        }
    }
    
    func handleElapsed(elapsedObject: NBModel) { }
    
    func reloadTableViews() {
 
    }
}
