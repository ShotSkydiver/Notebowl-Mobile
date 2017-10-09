
/* ***********************************

import UIKit
import Alamofire
import Luminous
import SwiftyJSON
import ResponseDetective
import CodableAlamofire


let sessionManager: SessionManager = {
    var defaultHeaders = SessionManager.defaultHTTPHeaders
    defaultHeaders["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38"
    defaultHeaders["Accept-Encoding"] = "gzip, deflate, br"
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = defaultHeaders
    ResponseDetective.enable(inConfiguration: configuration)
    
    return SessionManager(configuration: configuration)
}()


class AlamofireTokenLoginVC: UIViewController {
    
    let GLOBAL_TLD = "nbstage.com"
    let domain = "demo.nbstage.com"
    
    let decoder = JSONDecoder()
    
    let device = Luminous.System.Hardware.Device.current
    let deviceUUID = UIDevice().identifierForVendor!.uuidString
    let deviceOS = (Luminous.System.Hardware.systemName + " " + Luminous.System.Hardware.systemVersion)
    
    // Add Headers
    let headers = [
        "Connection":"keep-alive",
        "Accept":"application/json, text/plain, *//*",
        ]
    
    // mobile token url params
    var uuid: String!
    var token: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        testLogUserIn()
        
    }
    
    
    func testApiRequest(uuid: String, token: String) {
        
        self.uuid = uuid
        self.token = token
        
        print("testAPI:", self.uuid, ",", self.token)
        
        // Add URL parameters
        let urlParamsToken: Parameters = [
            "token":token,
            "uuid":uuid,
            ]
        
        // Fetch Request
        sessionManager.request("https://demo.nbstage.com/api/v1.0/credentials", method: .get, parameters: urlParamsToken)
            .responseDecodableObject(keyPath: "result", decoder: decoder) { (response: DataResponse<User>) in
                let userJson = response.result.value
                print("user object: ", userJson)
        }
        
        
    }
    
    func testLogUserIn() {
        
        
        
        let headersLogin: HTTPHeaders = [
            "Origin": "https://demo.nbstage.com",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
        ]
        
        // Form URL-Encoded Body
        let body: Parameters = [
            "email":"bob.smith@notebowl.com",
            "password":"notebowlbeta",
            ]
        
        // Fetch Request
        sessionManager.request("https://demo.nbstage.com/api/v1.0/credentials", method: .post, parameters: body, encoding: URLEncoding.default, headers: headersLogin)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    //debugPrint("HTTP Response Body: \(response.data)")
                    let credJSON = response.result.value
                    
                    print("response json: ", credJSON)
                    //let responseHeader = response.response?.allHeaderFields
                    //let cookieIndex = responseHeader?.index(forKey: "set-cookie")
                    //print("cookie? ", response.response?.value(forKey: "Set-Cookie"))
                    
                    //let template = "<<<; path=/; secure; httponly>>>"
                    //let indexStartOfText = template.index(template.startIndex, offsetBy: 3)
                    //let indexEndOfText = template.index(template.endIndex, offsetBy: -26)
                    //let substring = template[..<indexEndOfText]
                    
                    if let responseCookie = response.response?.allHeaderFields["Set-Cookie"] as? String {
                        print("set-cookie: ", responseCookie)
                        let endText = responseCookie.index(responseCookie.endIndex, offsetBy: -26)
                        let substr = responseCookie[..<endText]
                        let cookieSliced = String(substr)
                        print("set-cookie after slice: ", cookieSliced)
                        self.registerMobileDevice(apiCookie: cookieSliced)
                    }
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    func registerMobileDevice(apiCookie: String) {
        
        let headerCookie = ("testcookie; " + apiCookie)
        print("headercookie: ", headerCookie)
        // Add Headers
        let headersCookie: HTTPHeaders = [
            "Cookie": headerCookie
        ]
        
        
        // Add URL parameters
        let urlParamsRegister: Parameters = [
            "uuid":deviceUUID,
            "name":device.model,
            "os":deviceOS,
            "type":device.type,
            "model":device.identifier,
            ]
        
        // Fetch Request
        sessionManager.request("https://gateway.nbstage.com/services/mobile/register", method: .get, parameters: urlParamsRegister, headers: headersCookie)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    //print("mobile register: ", response.result.value)
                    //let jsonResult = response.result.value as! JSON
                    let resultJson = JSON(response.result.value!)
                    
                    print("json: ", resultJson)
                    
                    self.testApiRequest(uuid: resultJson["result"]["uuid"].string!, token: resultJson["result"]["token"].string!)
                    //let encoder = JSONEncoder()
                    //do {
                    //let jsonEncoded = try encoder.encode(jsonResult)
                    //let jsonString = String(data: jsonEncoded, encoding: .utf8)
                    //print("json encoded: ", jsonString!)
                    
                    //self.testApiRequest(uuid: jsonEncoded["uuid"], token: jsonEncoded["token"])
                    //}
                    //catch {
                    //    print("json encode error!")
                    //}
                    
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


********************************** */
