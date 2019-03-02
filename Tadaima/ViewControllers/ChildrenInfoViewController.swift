//
//  ChildrenInfoViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/21/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ChildrenInfoViewController: UIViewController {

    @IBOutlet weak var childName_txt: SkyFloatingLabelTextField!
    @IBOutlet weak var childAge_txt: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumber_txt: SkyFloatingLabelTextField!
    @IBOutlet weak var addChild_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
    }
    
    func customizeUI() {
        
        addChild_btn.layer.cornerRadius = 4.0
        addChild_btn.layer.borderColor = UIColor.white.cgColor
        addChild_btn.layer.borderWidth = 0.5
        addChild_btn.setTitle(NSLocalizedString("child_generate_qr_button_title", comment: ""), for: .normal)
        
        childName_txt.placeholder = NSLocalizedString("placeholder_child_name", comment: "")
        childAge_txt.placeholder = NSLocalizedString("placeholder_child_age", comment: "")
        phoneNumber_txt.placeholder = NSLocalizedString("child_contact_number_label_placeholder_title", comment: "")
    }
    
    @IBAction func addChildBtn_clicked(_ sender: Any) {
        
        let name = childName_txt.text
        let age = childAge_txt.text
        let phone = phoneNumber_txt.text
        let uid = Auth.auth().currentUser?.uid as! String
        
        if name == "" || Int(age ?? "0") ?? 0 < 1 || (phone?.isValidPhoneNumber())! {
            return
        }
        
        let ref = Database.database().reference()
        let childUid = ref.child(mChildren).childByAutoId().key as! String
        ref.child(mChildren + "/" + uid).child(childUid).setValue([mToken: token!, mChildName: name ?? "", mLocation: [mLatitude:0, mLongitude:0], mChildAge: age as! String, mPhoneNumber: phone, mStatus: "none"])
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "GenerateQR") as? GenerateQRViewController
        let qrCode = uid + "/" + childUid
        vc!.qrCode = qrCode
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
