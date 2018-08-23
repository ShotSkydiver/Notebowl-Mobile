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
import PKHUD
import SocketIO

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
        settingSwitch.addTarget(self, action: #selector(switchActionTriggered(_:)), for: UIControlEvents.valueChanged)
        settingName.text = setting.name
        settingSubtitle.text = (setting.help != nil ? setting.help : nil)
        settingSwitch.setOn((setting.userSetting != nil ? setting.userSetting!.value : setting.defaultValue), animated: false)
        self.settingForCell = setting
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeSetting() {
        HUD.show(.progress)
        NBClient.shared.delay(1.0) {
            if (self.settingSwitch.isOn == self.settingForCell.defaultValue) {
                self.settingForCell.userSetting!.deleteSelf()
                self.settingForCell.userSetting = nil
            }
            else if (self.settingSwitch.isOn != self.settingForCell.defaultValue) {
                let newSetting = Setting(key: self.settingForCell.key, value: self.settingSwitch.isOn)
                let finalSetting = newSetting.save()
                if finalSetting == nil {
                    HUD.flash(.labeledError(title: "Server Error!", subtitle: "Well, this is embarrassing, something's wrong on our end."), delay: 0.5)
                    return
                }
                self.settingForCell.userSetting = (finalSetting as! Setting)
            }
            HUD.flash(.success, delay: 0.5)
        }
    }
    
    @IBAction func switchActionTriggered(_ sender: UISwitch) {
        changeSetting()
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
