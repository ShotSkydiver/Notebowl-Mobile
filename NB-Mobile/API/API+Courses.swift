//
//  API+Courses.swift
//  NB-Mobile
//
//  Created by Conner Owen on 9/29/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//


import Foundation
import Luminous
import ResponseDetective
import Disk

extension API {
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    class func getCourses(completion: ((Result<Courses>) -> Void)?) {
        
        var urlComps = URLComponents(string: AppValues.courses)
        urlComps?.queryItems = AppValues.ipt5_queryItems
        
        var request = URLRequest(url: (urlComps?.url)!)

        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        ResponseDetective.enable(inConfiguration: config)
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                guard responseError == nil else {
                    completion?(.failure(responseError!))
                    return
                }
                
                guard let jsonData = responseData else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(Courses.self, from: jsonData)
                    completion?(.success(courses))
                }
                catch {
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
    class func saveCoursesToDisk(courses: [Course]) {
        
        do {
           try Disk.save(courses, to: .documents, as: "courses.json")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getCoursesFromDisk() -> [Course] {
        
        do {
            let retrieved = try Disk.retrieve("courses.json", from: .documents, as: [Course].self)
            return retrieved
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
