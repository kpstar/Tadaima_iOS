//
//  AdViewControllerExtension.swift
//  Tadaima
//
//  Created by KpStar on 2/10/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import ZAlertView
import GoogleMobileAds

extension UIViewController {
    
    func showAlertMessageWithKey(key: String) {
        let title = NSLocalizedString("alert_message_title", comment: "")
        let content = NSLocalizedString(key, comment: "")
        let dialog = ZAlertView(title: title, message: content, closeButtonText: NSLocalizedString("alert_message_button_close", comment: ""), closeButtonHandler: { alertView in
            alertView.dismissAlertView()
        })
        dialog.show()
    }
    
    func showAlertMessage(text: String) {
        let title = NSLocalizedString("alert_message_title", comment: "")
        let dialog = ZAlertView(title: title, message: text, alertType: ZAlertView.AlertType(rawValue: 0)!)
        dialog.show()
    }
    
    func showConfirmationMessage() {
        
    }
    
    func showAdMob() {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3350101969936788/1301073223"
        self.view.addSubview(bannerView)
        self.view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        bannerView.load(GADRequest())
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
