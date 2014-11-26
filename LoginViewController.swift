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
import ReactiveCocoa

class LoginViewController: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInFailureText: UILabel!
    
    
    let signInService: RegistrationService
    
    required init(coder aDecoder: NSCoder) {
        signInService = RegistrationService()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        func validToBackground(valid: NSNumber) -> UIColor {
            return valid.boolValue ? UIColor.clearColor() : UIColor.yellowColor()
        }
        
        func isValidText(validator:(String) -> Bool)(text: NSString) -> NSNumber {
            return validator(text)
        }
        
//        let validUsernameSignal = usernameTextField.rac_textSignal().mapAs(isValidText(isValidUsername)).distinctUntilChanged
        
        let validUsernameSignal = usernameTextField.rac_textSignal()
            .mapAs(isValidText(isValidUsername))
            .distinctUntilChanged()
        
        let validPasswordSignal = passwordTextField.rac_textSignal()
            .mapAs(isValidText(isValidPassword))
            .distinctUntilChanged()
        
        RAC(usernameTextField, "backgroundColor") << validUsernameSignal.mapAs(validToBackground)
        
        RAC(passwordTextField, "backgroundColor") << validPasswordSignal.mapAs(validToBackground)
        
        let signUpActiveSignal = RACSignalEx.combineLatestAs([validUsernameSignal, validPasswordSignal]) {
            (validUsername: NSNumber, validPassword: NSNumber) -> NSNumber in
            return validUsername && validPassword
        }
        
        signUpActiveSignal.subscribeNextAs {
            (active: NSNumber) in
            self.signInButton.enabled = active.boolValue
        }
        
        let signUpCommand = RACCommand(enabled: signUpActiveSignal) {
            (any) -> RACSignal in
            return self.signInSignal()
        }
        
        signUpCommand.executionSignals
            .flattenMap {
                (any) -> RACSignal in
                any as RACSignal
            }.subscribeNextAs {
                (success: NSNumber) in
                self.handleSignInResult(success.boolValue)
        }
        
        signInButton.rac_command = signUpCommand
        
    }
    
    func handleSignInResult(success: Bool) {
        if success {
//            self.performSegueWithIdentifier("signInSuccess", sender: self)
            UIAlertView(title: "Sign in success", message: "Well Done ;-)",
                delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            UIAlertView(title: "Sign in failure", message: "try harder next time ;-)",
                delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    // MARK: implementation
    
    func signInSignal() -> RACSignal {
        return RACSignal.createSignal {
            (subscriber) -> RACDisposable! in
            
            println("Sign-in initiated")
            self.signInService.signInWithUsername(self.usernameTextField.text,
                password: self.passwordTextField.text) {
                    (success) in
                    println("Sign-in completed")
                    subscriber.sendNext(success)
                    subscriber.sendCompleted()
            }
            return nil
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func isValidUsername(username:String) -> Bool {
        return (countElements(username)) > 3 && (username =~ ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*")
    }
    
    private func isValidPassword(password:String) -> Bool {
        return (countElements(password) > 3)
    }

//    @IBAction func login(sender: UIButton) {
//        
//        println("Hello, world")
    
//        MDRegistrationProvider.request(.Authenticate, method: .POST, parameters: ["username": "ger@brilliantage.com", "password":"test1"], completion: { (data, status, resonse, error) -> () in
        
//        var success = true
//        var error
        
        
        
//        if !success {
//            let alertController = UIAlertController(title: "MDRegistration Authentication", message: error?.description, preferredStyle: .Alert)
//            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//                alertController.dismissViewControllerAnimated(true, completion: nil)
//            })
//            alertController.addAction(ok)
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
        
//    }
    
    
}