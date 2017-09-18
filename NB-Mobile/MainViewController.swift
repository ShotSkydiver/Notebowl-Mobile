//
//  MainViewController.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/5/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class MainViewController: UITableViewController, ResourceObserver {
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCoverParent()
    }
    
    var uniList: [JSON] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var uniResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            
            uniResource?
                .addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        uniList = uniResource?.typedContent() ?? []
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
        
        uniResource = NoteBowlAPI.universities
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniCell", for: indexPath)
        
        // Get pokemon out of pokemon resource
        let uniSummary = uniList[indexPath.row]
        
        // Customize cell here based on pokemon
        cell.textLabel?.text = uniSummary["name"].stringValue.capitalized
        cell.detailTextLabel?.text = "id: \(indexPath.row + 1)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if self.tableView.indexPathForSelectedRow != nil {
                
            }
        }
    }
    
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: "https://demo.nbstage.com/rpc/v1.0/validateEmail/chdowen@notebowl.com?__sK=1505162451139-0.zcqbbgvm8sq&__rK=1505162451244")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "result")!)
                
                /*
                //getting the avengers tag array from json and converting it to NSArray
                if let heroeArray = jsonObj!.value(forKey: "avengers") as? NSArray {
                    //looping through all the elements
                    for heroe in heroeArray{
                        
                        //converting the element to a dictionary
                        if let heroeDict = heroe as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if let name = heroeDict.value(forKey: "name") {
                                
                                //adding the name to the array
                                self.nameArray.append((name as? String)!)
                            }
                            
                        }
                    }
                }
 
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.showNames()
                })
             */
            }
        }).resume()
    }
    
    
}


