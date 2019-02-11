//
//  LibraryQRViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/10/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit

class LibraryQRViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var qrcode_img: UIImageView!
    @IBOutlet weak var import_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
    }
    
    func customizeUI() {
        import_btn.setTitleColor(UIColor.white, for: .normal)
        import_btn.layer.cornerRadius = 4.0
        import_btn.layer.borderColor = UIColor.white.cgColor
        import_btn.layer.borderWidth = 0.5
        import_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        import_btn.setTitle(NSLocalizedString("import_photo_from_library_title", comment: ""), for: .normal)
    }
    
    @IBAction func importBtn_clicked(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrcodeImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            qrcode_img.image = qrcodeImg
            let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])!
            let ciImage:CIImage=CIImage(image:qrcodeImg)!
            var qrCodeLink=""

            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrCodeLink += feature.messageString!
            }
            
            if qrCodeLink.isValidQRCode() {
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ConfirmQR") as? ConfirmQRViewController
                vc?.qrCode = qrCodeLink
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                self.showAlertMessageWithKey(key: "qrcode_error_alert")
            }
        }
        else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
