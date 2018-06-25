//
//  NotificationSettingCellTableViewCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 6/19/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class NotificationSettingCell: UITableViewCell {

    @IBOutlet weak var settingName: KerningLabel!
    @IBOutlet weak var settingSubtitle: KerningLabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var settingForCell: SettingsDefault!
    var currentValue: Bool! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(setting: SettingsDefault) {
        settingName.text = setting.name
        if setting.help != nil { settingSubtitle.text = setting.help }
        else { settingSubtitle.text = nil }
        
        settingSwitch.setOn((setting.userSetting != nil ? setting.userSetting!.value : setting.defaultValue), animated: false)
 
        self.settingForCell = setting
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        if (settingSwitch.isOn == settingForCell.defaultValue) {
            let delete = NBNetworking.shared.request(.delete, url: settingForCell.userSetting!.url.absoluteString )
            TTLog.warning("delete url request: ", delete.description)
            settingForCell.userSetting = nil
        }
        else if (settingSwitch.isOn != settingForCell.defaultValue) {
            let fakeSetting = Mapper<Setting>().map(JSON: ["key":settingForCell.key, "value":settingSwitch.isOn])
            settingForCell.userSetting = fakeSetting
            
            let payload: Any? = ["key": settingForCell.key, "value": settingSwitch.isOn, "_parent": "\(NBClient.shared.getCurrentUser().url.absoluteString)"]
            let post = NBNetworking.shared.request(.post, url: Setting.endpoint, json: payload)
            TTLog.warning("post url request: ", post.description)
        }
    }
}


extension NotificationSettingCell {
    static var reuseId: String {
        return "settingCell"
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "NotificationSettingCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> NotificationSettingCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? NotificationSettingCell
    }
}
