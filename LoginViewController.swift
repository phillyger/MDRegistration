//
//  LoginViewController.swift
//  MDRegistration
//
//  Created by GER OSULLIVAN on 11/24/14.
//  Copyright (c) 2014 brilliantage. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    
    
    @IBAction func login(sender: UIButton) {
        
        println("Hello, world");
        
//        MDRegistrationProvider.request(.Authenticate, method: .POST, parameters: ["username": "ger@brilliantage.com", "password":"test1"], completion: { (data, status, resonse, error) -> () in
        

        var parameters: [String: AnyObject] = ["username": "ger@brilliantage.com", "password":"test1"]
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
                if let json = json as? NSDictionary {
                    // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                    //                    self.repos = json
                    println(json);
                } else {
                    success = false
                }
                
                //                self.tableView.reloadData()
            } else {
                success = false
            }
            
            if !success {
                let alertController = UIAlertController(title: "MDRegistration Authentication", message: error?.description, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
}