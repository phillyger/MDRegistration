//
//  RegistrationService.swift
//  MDRegistration
//
//  Created by GER OSULLIVAN on 11/25/14.
//  Copyright (c) 2014 brilliantage. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

typealias SignInReponse = (Bool) -> ()


func delay(delay: Double, closure:()->()) {
    let time = dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
    )
    dispatch_after(time, dispatch_get_main_queue(), closure)
}

class RegistrationService {
    
    func signIn(username: NSString, password: NSString, complete: SignInReponse) {
//        delay(2.0) {
//            let sucess = username == "user" && password == "password"
//            complete(sucess)
//        }
        
        
        var parameters: [String: AnyObject] = ["username": username, "password": password]
//                var parameters: [String: AnyObject] = ["username": "ger@brilliantage.com", "password": "test1"]
        
        MDRegistrationProvider.request(.Authenticate, method: .POST, parameters: parameters, completion: { (data, status, response, error) -> () in
            
            var success = error == nil
            if let data = data {
                let jsonDict = JSON(data: data)

                if let code = jsonDict["outcome"]["code"].string {
                
//                    println(code)
//                    println(jsonDict)
                    success = (code.toInt() > 400000) ? false : true

                } else {
                   success = false
                }
                
                //                self.tableView.reloadData()
            } else {
                success = false
                
            }
            
            complete(success)
    
        })

    }
    
    func isUsernameAvailable(username:String) {
        
        
    }
    
    
}