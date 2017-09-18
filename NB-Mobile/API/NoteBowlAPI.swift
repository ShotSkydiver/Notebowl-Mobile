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
    
    var sessionCookie: String??
    
    private let service = Service(baseURL: "https://demo.nbstage.com/api/v1.0")
    
    
    
    fileprivate init() {
        #if DEBUG
            // Bare-bones logging of which network calls Siesta makes:
            LogCategory.enabled = LogCategory.detailed
            
            // For more info about how Siesta decides whether to make a network call,
            // and when it broadcasts state updates to the app:
            //LogCategory.enabled = LogCategory.common
            
            // For the gory details of what Siesta’s up to:
            //LogCategory.enabled = LogCategory.detailed
        #endif
        
        // Global configuration
        
        service.configure {
            // By default, Siesta parses JSON using Foundation JSONSerialization.
            // This transformer wraps that with SwiftyJSON.
            
            $0.pipeline[.parsing].add(SwiftyJSONTransformer, contentTypes: ["*/json"])
            //$0.expirationTime = 3600
            
            //addStoredCookiesTo($0.config.headers)
            //$0.headers["Cookie"] = self.sessionCookie ?? ""
            
            //$0.config.beforeStartingRequest {
             //   _, req in
             //   req.onSuccess {
             //       entity in
             //       storeCookiesFrom(entity.headers)
             //   }
            //}
            
            // Custom transformers can change any response into any other — in this case, replacing the default error
            // message with the one provided by the Github API.
            
            //$0.pipeline[.cleanup].add(GithubErrorMessageExtractor())
        }
        
        // Resource-specific configuration
        
        //service.configure("/credentials") {
            //$0.headers["Cookie"] = "testcookie; notebowl_api=eyJpdiI6Imt5K1Byc0hsYk9vUlR5ODQ0elpXVXc9PSIsInZhbHVlIjoiNUNRNXIya3lRY1JGMTN2cVB1ZVwvaHdGaHFXeEp4dGQ0UnExcXVLVDIxWm1VazJvcHFRbG12TWZuOURtaWJXZFZleU9sT01MSEcyYm9HTlVIYm5iNWFBPT0iLCJtYWMiOiJmMDYwN2RhNThlZTVhMzM3Y2U2MjVhNTA0MWZkMGY4ZGM3NWVkMzdiOTAzYjdiYzEyZDBhZGZjMTQ2M2ViYzU0In0%3D"
        //}
        
        // Auth configuration
        
        // Note the "**" pattern, which makes this config apply only to subpaths of baseURL.
        // This prevents accidental credential leakage to untrusted servers.
        
        service.configure("**") {
            // This header configuration gets reapplied whenever the user logs in or out.
            // How? See the basicAuthHeader property’s didSet.
            $0.headers["Cookie"] = "testcookie; notebowl_api=eyJpdiI6Imt5K1Byc0hsYk9vUlR5ODQ0elpXVXc9PSIsInZhbHVlIjoiNUNRNXIya3lRY1JGMTN2cVB1ZVwvaHdGaHFXeEp4dGQ0UnExcXVLVDIxWm1VazJvcHFRbG12TWZuOURtaWJXZFZleU9sT01MSEcyYm9HTlVIYm5iNWFBPT0iLCJtYWMiOiJmMDYwN2RhNThlZTVhMzM3Y2U2MjVhNTA0MWZkMGY4ZGM3NWVkMzdiOTAzYjdiYzEyZDBhZGZjMTQ2M2ViYzU0In0%3D"
            //$0.headers["Authorization"] = self.basicAuthHeader
        }
        
        // Mapping from specific paths to models
        
        service.configureTransformer("/universities") {
            try  University(json: ($0.content as JSON)["result"])
        //        .arrayValue
        //        .map(University.init)
        }
        
        service.configureTransformer("/credentials") {
            //try User(json: ($0.content as JSON)["result"])
            try User(json: ($0.content as JSON)["result"])
            //try ($0.content as JSON)["result"]
                //.arrayValue
                //.map(User.init)  // Model mapping gives Siesta an implicit output type
        }
        
        /*
        service.configureTransformer("/search/repositories") {
            try ($0.content as JSON)["items"]
                .arrayValue
                .map(Repository.init)
        }
        
        service.configureTransformer("/repos/") {
            try Repository(json: $0.content)
        }
        
        service.configureTransformer("/repos//contributors") {
            try ($0.content as JSON)
                .arrayValue
                .map(User.init)
        }
        
        service.configure("/user/starred/") {   // Github gives 202 for “starred” and 404 for “not starred.”
            $0.pipeline[.model].add(               // This custom transformer turns that curious convention into
                TrueIfResourceFoundTransformer())  // a resource whose content is a simple boolean.
        }
         */
        // Note that you can use Siesta without these sorts of model mappings. By default, Siesta parses JSON, text,
        // and images based on content type — and a resource will contain whatever the server happened to return, in a
        // parsed but unstructured form (string, dictionary, etc.). If you prefer to work with raw dictionaries instead
        // of models (good for rapid prototyping), then no additional transformer config is necessary.
        //
        // If you do apply a path-based mapping like the ones above, then any request for that path that does not return
        // the expected type becomes an error. For example, "/users/foo" _must_ return a JSON response because that's
        // what the User(json:) expects.
    }
    
    var credentials: Resource { return service.resource("/credentials") }
    
    // MARK: Authentication
    
    //func logIn(_ email: String, _ password: String) {
    func logIn() {
        let credTest = credentials.request(.get)
        //print("after let credTest")
        /*
        let credLogin = credentials.request(.post, urlEncoded: ["email": "bob.smith@notebowl.com", "password": "notebowlbeta"])
        
        credTest.onFailure { (error) in
            if error.httpStatusCode == 404 {
                print("no user logged in!")
                
                credLogin.start()
                credLogin.onSuccess { (entity) in
                    //var headers: [String:String] = entity.headers
                    
                    //header = entity.heade
                    //let resKey = entity.header(forKey: "X-NoteBowl-User-ResourceKey")
                    let cookieKey = entity.header(forKey: "Cookie")
                    
                    //self.sessionCookie = entity.header(forKey: "set-cookie")
                    print("success! response: ", entity.content)
                    print("headers: ", entity.headers)
                    print("cookie: ", cookieKey)
                    self.service.invalidateConfiguration()
                    //print("new user logged in!", resKey ?? "no reskey!", cookieKey ?? "no cookie!")
                }
            }
        }
         */
        credTest.onSuccess { (entity) in
            //print("user already logged in! response: ", (entity.content as! JSON)["result"])
            //print("headers: ", entity.headers)
        }
        
    }
    
    func logOut() {
        basicAuthHeader = nil
    }
    
    var isAuthenticated: Bool {
        return basicAuthHeader != nil
    }
    
    private var basicAuthHeader: String? {
        didSet {
            // These two calls are almost always necessary when you have changing auth for your API:
            
            service.invalidateConfiguration()  // So that future requests for existing resources pick up config change
            service.wipeResources()            // Scrub all unauthenticated data
            
            // Note that wipeResources() broadcasts a “no data” event to all observers of all resources.
            // Therefore, if your UI diligently observes all the resources it displays, this call prevents sensitive
            // data from lingering in the UI after logout.
        }
    }
    
    
    
    
    // MARK: Endpoints
    
    // You can turn your REST API into a nice Swift API using lightweight wrappers that return Siesta resources.
    //
    // Note that this class keeps its service private, making these methods the only entry points for the API.
    // You could also choose to subclass Service, which makes methods like service.resource(…) available to
    // your whole app. That approach is sometimes better for quick and dirty prototyping.
    
    var universities: Resource {
        return service
            .resource("/universities")
            //.withParam("limit", "151")
    }
    
    //func user() -> Resource {
    //    return credentials.request(.get)
    //}
    
    
    func loginUser() -> Request {
        return credentials.request(.post, urlEncoded: ["email": "bob.smith@notebowl.com", "password": "notebowlbeta"])
       
    }
    
    func createAuthToken() -> Request {
        return credentials
            .request(.post, urlEncoded: ["email": "bob.smith@notebowl.com", "password": "notebowlbeta"])
            .onSuccess {
                //self.authToken = $0.jsonDict["token"] as? String  // Store the new token, then…
                self.sessionCookie = $0.header(forKey: "set-cookie")
                self.service.invalidateConfiguration()                    // …make future requests use it
        }
    }

    
    /*
    func loginUser(_ isUserLoggedIn: Bool, user userModel: User) -> Request {
        return credentials.request(.post) {
            $0.headers["Content-Type"] = "application/x-www-form-urlencoded"
            $0.httpBody = imageData
            $0.addValue("image/png", forHTTPHeaderField: "Content-Type")
        }
    }
    */
    
    /*
 
    var activeRepositories: Resource {
        return service
            .resource("/search/repositories")
            .withParam("q", "stars:>0")
            .withParam("sort", "updated")
            .withParam("order", "desc")
    }
    
    func user(_ username: String) -> Resource {
        return service
            .resource("/users")
            .child(username.lowercased())
    }
    
    func repository(ownedBy login: String, named name: String) -> Resource {
        return service
            .resource("/repos")
            .child(login)
            .child(name)
    }
    
    func repository(_ repositoryModel: Repository) -> Resource {
        return repository(
            ownedBy: repositoryModel.owner.login,
            named: repositoryModel.name)
    }
    
    func currentUserStarred(_ repositoryModel: Repository) -> Resource {
        return service
            .resource("/user/starred")
            .child(repositoryModel.owner.login)
            .child(repositoryModel.name)
    }
    
    func setStarred(_ isStarred: Bool, repository repositoryModel: Repository) -> Request {
        let starredResource = currentUserStarred(repositoryModel)
        return starredResource
            .request(isStarred ? .put : .delete)
            .onSuccess { _ in
                // Update succeeded. Directly update the locally cached “starred / not starred” state.
                
                starredResource.overrideLocalContent(with: isStarred)
                
                // Ask server for an updated star count. Note that we only need to trigger the load here, not handle
                // the response! Any UI that is displaying the star count will be observing this resource, and thus
                // will pick up the change. The code that knows _when_ to trigger the load is decoupled from the code
                // that knows _what_ to do with the updated data. This is the magic of Siesta.
                
                self.repository(repositoryModel).load()
        }
    }
     */

}
