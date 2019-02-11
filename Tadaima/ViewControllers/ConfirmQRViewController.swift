//
//  ConfirmQRViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/11/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit

class ConfirmQRViewController: UIViewController {

    @IBOutlet weak var qrcode_img: UIImageView!
    @IBOutlet weak var success_lbl: UILabel!
    @IBOutlet weak var accept_btn: UIButton!
    @IBOutlet weak var desc_lbl: UILabel!
    
    var qrCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
    }
    
    func customizeUI() {
        
        success_lbl.text = NSLocalizedString("children_qr_scan_complete_button_title", comment: "")
        desc_lbl.text = NSLocalizedString("children_qr_description_label_title", comment: "")
        
        accept_btn.setTitle(NSLocalizedString("children_qr_accept_gps_button_title", comment: ""), for: .normal)
        accept_btn.layer.cornerRadius = 4.0
        accept_btn.layer.borderColor = UIColor.white.cgColor
        accept_btn.layer.borderWidth = 0.5
        accept_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        
        qrcode_img.image = self.generateQRCode(from: qrCode!)
    }
    
    @IBAction func acceptBtn_clicked(_ sender: Any) {
        
        
    }
}
