//
//  MDRegistrationAPI.swift
//  MDRegistration
//
//  Created by GER OSULLIVAN on 11/24/14.
//  Copyright (c) 2014 brilliantage. All rights reserved.
//


import Foundation
import Moya

// MARK: - Provider setup

let endpointsClosure = { (target: MDRegistration, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<MDRegistration> in
    return Endpoint<MDRegistration>(URL: url(target), sampleResponse: .Success(200, target.sampleData), method: method, parameters: parameters)
}

let GitHubProvider = MoyaProvider(endpointsClosure: endpointsClosure)


// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum MDRegistration {

    case Available
    case AllQuestions
    case UserQuestions(String)
    case Activate
    case Authenticate
    case Register
    case ResetPassword
    
    // Secure APIs
    case SecureVerify
    case SecureUpdateAccount
    case SecureGetAccount(String)
    case SecureChangePassword
}

extension MDRegistration : MoyaPath {
    public var path: String {
        switch self {

        case .Available:
            return "/available"

        case .AllQuestions:
            return "/questions"
        case .UserQuestions(let name):
            return "/account/\(name.URLEscapedString)/questions"
        case .Activate:
            return "/activate"
        case .Authenticate:
            return "/authenticate"
        case .Register:
            return "/register"
        case ResetPassword:
            return "/account/reset_password"
        case .SecureVerify:
            return "/secure/verify"
        case SecureChangePassword:
            return "/secure/account/change_password"
        case .SecureGetAccount(let name):
            return "/secure/account/\(name.URLEscapedString)"
        case .SecureUpdateAccount:
            return "/secure/account/"
        }
    }
}

extension MDRegistration : MoyaTarget {
    public var baseURL: NSURL { return NSURL(string: "http://localhost:8099/app/rest")! }
    public var sampleData: NSData {
        switch self {
        case .Available:
            return "{\"outcome\": {\"message\": \"\",\"code\": \"\",\"errors\": [{\"code\": \"\",\"description\": \"\",\"severity\": \"\"}]},\"data\": \"object\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .AllQuestions:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        case UserQuestions(let name):
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .Activate:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        default:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

extension Moya.ParameterEncoding: Equatable {
}

public func ==(lhs: Moya.ParameterEncoding, rhs: Moya.ParameterEncoding) -> Bool {
    switch (lhs, rhs) {
    case (.URL, .URL):
        return true
    case (.JSON, .JSON):
        return true
    case (.PropertyList(_), .PropertyList(_)):
        return true
    case (.Custom(_), .Custom(_)):
        return true
    default:
        return false
    }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString!
}
