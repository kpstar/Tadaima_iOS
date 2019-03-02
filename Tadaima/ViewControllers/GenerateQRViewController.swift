//
//  GenerateQRViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/22/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit

class GenerateQRViewController: UIViewController {

    
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var generateBtn: UIButton!
    
    var qrCode = String()
    var saveImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        setQRImage()
    }
    
    func customizeUI() {
    
        generateBtn.layer.cornerRadius = 4.0
        generateBtn.layer.borderColor = UIColor.white.cgColor
        generateBtn.layer.borderWidth = 0.5
        generateBtn.setTitle(NSLocalizedString("parent_qr_save_button_title", comment: ""), for: .normal)
    }
    
    func setQRImage() {
        
        let stringData = qrCode.data(using: String.Encoding.isoLatin1)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(stringData, forKey: "inputMessage")
        guard let qrCodeImage = qrFilter.outputImage else { return }
        
        let scaleX = qrImage.frame.size.width / qrCodeImage.extent.size.width
        let scaleY = qrImage.frame.size.height / qrCodeImage.extent.size.height
        
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrImage.image = UIImage(ciImage: transformedImage)
        saveImage = QRCodeGenerator.convert(transformedImage)
    }
    
    @IBAction func generateBtn_Clicked(_ sender: Any) {
        
        guard let selectedImage = saveImage else {
            showAlertMessage(text: "Image Not Found")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertMessage(text: error.localizedDescription)
        } else {
            showAlertMessage(text: "Successfully Saved.")
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "navDrawer") as? UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
    }
    
}
