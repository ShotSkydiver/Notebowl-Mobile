//
//  NoteBowlAPI.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/11/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//
import Foundation
import Siesta
import SwiftyJSON

let NoteBowlAPI = _NoteBowlAPI()

class _NoteBowlAPI {
    
    
    private let service = Service(baseURL: "https://demo.nbstage.com",
                                  standardTransformers: [.text, .image])
    
    fileprivate init() {
        #if DEBUG
            LogCategory.enabled = LogCategory.common
        #endif
        
        // –––––– Global configuration ––––––
        
        let jsonDecoder = JSONDecoder()
        
        //service.configure {
            // By default, Siesta parses JSON using Foundation JSONSerialization.
            // This transformer wraps that with SwiftyJSON.
            
            // $0.pipeline[.cleanup].add(GitHubErrorMessageExtractor(jsonDecoder: jsonDecoder))
        //}
        
        // –––––– Resource-specific configuration ––––––
        
        
        
        
        // –––––– Auth configuration ––––––
        
        //service.configure("**") {
            // This header configuration gets reapplied whenever the user logs in or out.
            // How? See the basicAuthHeader property’s didSet.
            
            //$0.headers["Authorization"] = self.basicAuthHeader
        //}
        
        // Mapping from specific paths to models
        
        service.configureTransformer("/users/*") {
            // Input type inferred because the from: param takes Data.
            // Output type inferred because jsonDecoder.decode() will return User
            try jsonDecoder.decode([User].self, from: $0.content)
        }
        
        
        service.configureTransformer("/universities/*") {
            
            try jsonDecoder.decode([University].self, from: $0.content)
        }
        

    }
    
    
    // MARK: Authentication
    
    
    
    
    // MARK: Endpoints
    
    // You can turn your REST API into a nice Swift API using lightweight wrappers that return Siesta resources.
    //
    // Note that this class keeps its service private, making these methods the only entry points for the API.
    // You could also choose to subclass Service, which makes methods like service.resource(…) available to
    // your whole app. That approach is sometimes better for quick and dirty prototyping.
    


}
