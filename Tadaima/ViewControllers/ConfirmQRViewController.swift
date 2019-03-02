//
//  ConfirmQRViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/11/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase

class ConfirmQRViewController: UIViewController {

    @IBOutlet weak var qrcode_img: UIImageView!
    @IBOutlet weak var success_lbl: UILabel!
    @IBOutlet weak var accept_btn: UIButton!
    @IBOutlet weak var desc_lbl: UILabel!
    
    var qrCode: String?
    var parentId: String?
    var childId: String?
    var phoneNumber: String?
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
        getPhoneNumber()
    }
    
    func getPhoneNumber() {
        
        parentId = self.qrCode?.getParentID()
        childId = self.qrCode?.getChildID()
        
        ref.child(mChildren + "/" + parentId!).child(childId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.phoneNumber = value?[mPhoneNumber] as? String ?? ""
        }) { (error) in
            self.showAlertMessage(text: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func customizeUI() {
        
        success_lbl.text = NSLocalizedString("children_qr_scan_complete_button_title", comment: "")
        desc_lbl.text = NSLocalizedString("children_qr_description_label_title", comment: "")
        
        accept_btn.setTitle(NSLocalizedString("children_qr_accept_gps_button_title", comment: ""), for: .normal)
        accept_btn.layer.cornerRadius = 4.0
        accept_btn.layer.borderColor = UIColor.white.cgColor
        accept_btn.layer.borderWidth = 0.5
        accept_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        
        let qrCodeImage = self.generateQRCode(from: qrCode!)!
        let scaleX = qrcode_img.frame.size.width / qrCodeImage.size.width
        let scaleY = qrcode_img.frame.size.height / qrCodeImage.size.height

        let transformedImage = qrCodeImage.ciImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        qrcode_img.image = UIImage(ciImage: transformedImage!)
    }
    
    @IBAction func acceptBtn_clicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerification") as? PhoneVerificationViewController
        vc?.childUid = childId
        vc?.parentUid = parentId
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                self.showAlertMessage(text: error.localizedDescription)
                return
            }
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerification") as? PhoneVerificationViewController
            vc?.verificationId = verificationID
            vc?.childUid = self.childId
            vc?.parentUid = self.parentId
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
