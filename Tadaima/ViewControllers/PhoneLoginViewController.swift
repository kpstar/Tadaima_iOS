//
//  PhoneLoginViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/11/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import Firebase

class PhoneLoginViewController: UIViewController {

    @IBOutlet weak var phone_txt: FPNTextField!
    @IBOutlet weak var privacy_txt: UILabel!
    @IBOutlet weak var accept_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
    }
    
    func customizeUI() {
        
        accept_btn.setTitle(NSLocalizedString("phone_auth_button_title", comment: ""), for: .normal)
        accept_btn.layer.cornerRadius = 4.0
        accept_btn.layer.borderColor = UIColor.white.cgColor
        accept_btn.layer.borderWidth = 0.5
        accept_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        
        privacy_txt.text = NSLocalizedString("terms_and_condition_title", comment: "")
        privacy_txt.layer.borderColor = UIColor.white.cgColor
        privacy_txt.layer.borderWidth = 0.5
        privacy_txt.layer.cornerRadius = 5.0
    }
    
    @IBAction func acceptBtn_clicked(_ sender: Any) {
        
        let phoneNumber = phone_txt.text
        if phoneNumber?.isValidPhoneNumber() != true {
            self.showAlertMessageWithKey(key: "phone_error_alert")
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showAlertMessage(text: error.localizedDescription)
                return
            }
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerification") as? PhoneVerificationViewController
            vc?.verificationId = verificationID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
