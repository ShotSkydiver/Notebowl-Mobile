//
//  ViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class ViewController: UIViewController, ResourceObserver {
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var avatar: RemoteImageView!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var userResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            
            oldValue?.removeObservers(ownedBy: self)
            //oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            userResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        // typedContent() infers that we want a User from context: showUser() expects one. Our content tranformer
        // configuation in GitHubAPI makes it so that the userResource actually holds a User. It is up to a Siesta
        // client to ensure that the transformer output and the expected content type line up like this.
        //
        // If there were a type mismatch, typedContent() would return nil. (We could also provide a default value with
        // the ifNone: param.)
        print("resourceChanged")
        showUserData()
    }
    
    var currentUser: User? {
        return userResource?.typedContent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
        
        showUserData()
        
        userResource = NoteBowlAPI.credentials
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func showUserData() {
        if let _currentUser = currentUser {
            fullNameLabel?.text = _currentUser.firstName
            usernameLabel?.text = _currentUser.email
            avatar?.imageURL = _currentUser.profileUrl
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCover(userInfoView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

