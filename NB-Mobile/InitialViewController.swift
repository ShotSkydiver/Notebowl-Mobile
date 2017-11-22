//
//  InitialViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 10/14/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        let webVC = NBAuthViewController()
        present(webVC, animated: true, completion: nil)
    }

}
