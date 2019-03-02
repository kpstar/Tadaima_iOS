//
//  PhoneVerificationViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/11/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import Firebase
import PinCodeTextField
import MBProgressHUD

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var pincode_txt: PinCodeTextField!
    @IBOutlet weak var desc_lbl: UILabel!
    
    var verificationId : String?
    var childUid : String? = ""
    var parentUid : String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        pincode_txt.delegate = self
        pincode_txt.keyboardType = .numberPad
        pincode_txt.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tap() {
        pincode_txt.becomeFirstResponder()
    }
    
    func customizeUI() {
        
        title_lbl.text = NSLocalizedString("phone_verification_label_title", comment: "")
        desc_lbl.text = NSLocalizedString("phone_verification_hint_title", comment: "")
    }
}

extension PhoneVerificationViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        print("value changed: \(value)")
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationId!,
            verificationCode: textField.text!)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                self.showAlertMessage(text: error.localizedDescription)
                textField.text = ""
                return
            }
            
            if (self.childUid != "" && self.parentUid != "") {
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "navChildDrawer") as? UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
                UserDefaults.standard.set(self.parentUid, forKey: mParentUid)
                UserDefaults.standard.set(self.childUid, forKey: mChildUid)
                UserDefaults.standard.set("No", forKey: mEmergency)
                return;
            }
            
            UserDefaults.standard.set("", forKey: mParentUid)
            UserDefaults.standard.set("", forKey: mChildUid)
            UserDefaults.standard.set("", forKey: mUserCreated)
            self.showSuccessMessageWithKey(key: "success_message_text")
//            let vc = mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
//            vc?.method = 0
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
