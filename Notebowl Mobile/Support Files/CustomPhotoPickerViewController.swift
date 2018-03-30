//
//  CustomPhotoPickerViewController.swift
//  TLPhotoPicker
//
//  Created by wade.hawk on 2017. 5. 28..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import Foundation
import TLPhotoPicker

class CustomPhotoPickerViewController: TLPhotosPickerViewController {
    override func makeUI() {
        super.makeUI()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2039999962, green: 0.2820000052, blue: 0.3650000095, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        // self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
    }
    @objc func customAction() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2039999962, green: 0.2820000052, blue: 0.3650000095, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
    }
}
