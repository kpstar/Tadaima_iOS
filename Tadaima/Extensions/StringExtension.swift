//
//  StringExtension.swift
//  Tadaima
//
//  Created by KpStar on 2/11/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidPassword() -> Bool {
        if self.count < 6 || self.range(of: " ") != nil {
            return false
        }
        return true
    }
    func isValidQRCode() -> Bool {
        let parts = self.components(separatedBy: "/")
        if (parts.count == 2 && self.count > 20) {
            return true
        }
        return false
    }
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    func getParentID() -> String {
        return self.components(separatedBy: "/")[0]
    }
    func getChildID() -> String {
        return self.components(separatedBy: "/")[1]
    }
    // FireBase
    static var ParentDB: String {
        return "parents"
    }
    static var ChildrenDB: String {
        return "children"
    }
    

    static var appName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
}
