//
//  LoginViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/9/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email_txt: SkyFloatingLabelTextField!
    @IBOutlet weak var password_txt: SkyFloatingLabelTextField!
    @IBOutlet weak var login_btn: UIButton!
    
    var method = Int()
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        self.showAdMob()
    }
    
    func customizeUI() {
        
        var text: String = NSLocalizedString("email_login_button_title", comment: "")
        if method == 1 {
            text = NSLocalizedString("email_signup_button_title", comment: "")
        }
        login_btn.setTitle(text, for: .normal)
        login_btn.setTitleColor(UIColor.white, for: .normal)
        login_btn.layer.cornerRadius = 4.0
        login_btn.layer.borderColor = UIColor.white.cgColor
        login_btn.layer.borderWidth = 0.5
        login_btn.layer.backgroundColor = UIColor.colorBlue.cgColor

        email_txt.placeholder = NSLocalizedString("login_text_email_placeholder", comment: "")
        password_txt.placeholder = NSLocalizedString("login_text_password_placeholder", comment: "")
    }
    
    @IBAction func loginBtn_clicked(_ sender: Any) {
        
        var errorKey = ""
        let this = self
        
        let emailTxt = email_txt.text
        let passwordTxt = password_txt.text
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if emailTxt?.isValidEmail() == false {
            errorKey = "email_error_alert"
        }
        if passwordTxt?.isValidPassword() == false {
            errorKey = "password_error_alert"
        }
        
        if errorKey != "" {
            self.showAlertMessageWithKey(key: errorKey)
        }
        
        let firebaseAuth = Auth.auth()
        
        if method == 1 {
            firebaseAuth.createUser(withEmail: emailTxt!, password: passwordTxt!) { (result, error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if error != nil {
                    this.showAlertMessage(text: (error?.localizedDescription)!)
                }
                
                guard let user = result?.user else { return }
                self.ref.child(mParent + user.uid).setValue([mToken: token!, mFamilyName: "", mLocation: [mLatitude:0, mLongitude:0], mEmail: user.email as! String, mPhoneNumber: ""])
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneLogin") as? PhoneLoginViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            return;
        }
        
        firebaseAuth.signIn(withEmail: emailTxt!, password: passwordTxt!) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                this.showAlertMessage(text: (error?.localizedDescription)!)
            }
            
            guard (result?.user) != nil else { return }
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "ParentInfo") as? ParentInfoViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
