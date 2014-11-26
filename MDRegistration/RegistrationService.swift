//
//  RegistrationService.swift
//  MDRegistration
//
//  Created by GER OSULLIVAN on 11/25/14.
//  Copyright (c) 2014 brilliantage. All rights reserved.
//

import Foundation
import UIKit

typealias SignInReponse = (Bool) -> ()

func delay(delay: Double, closure:()->()) {
    let time = dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
    )
    dispatch_after(time, dispatch_get_main_queue(), closure)
}

class RegistrationService {
    
    func signInWithUsername(username: NSString, password: NSString, complete: SignInReponse) {
//        delay(2.0) {
//            let sucess = username == "user" && password == "password"
//            complete(sucess)
//        }
        
        var success=false;
        
        var parameters: [String: AnyObject] = ["username": username, "password": password]
        //        let json = JSON(parameters)
        
        
        MDRegistrationProvider.request(.Authenticate, method: .POST, parameters: parameters, completion: { (data, status, response, error) -> () in
            
            var success = error == nil
            if let data = data {
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                
                //                println(json)
                //                for (index: String, subJson: JSON) in json {
                //                    //Do something you want
                //                    println(index)
                //                    println(subJson)
                //                }
                success=true
                 complete(success)
                if let json = json as? NSDictionary {
                    // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                    //                    self.repos = json
                    println(json);
                } else {
//                    success = false
                }
                
                //                self.tableView.reloadData()
            } else {
                success = false
                complete(success)
            }
            
    
        })
        
        

    }
    
    
}