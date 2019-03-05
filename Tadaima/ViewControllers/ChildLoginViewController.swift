//
//  ChildLoginViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/9/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class ChildLoginViewController: UIViewController {
    
    @IBOutlet weak var camera_btn: UIButton!
    @IBOutlet weak var library_btn: UIButton!
    
    var bannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        self.showAdMob()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener {(auth, user) in
            
            if user == nil {
                return
            }
            if user?.phoneNumber != nil {
                if UserDefaults.standard.string(forKey: mParentUid) == "" || UserDefaults.standard.string(forKey: mChildUid) == "" {
                    return
                }
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "navChildDrawer") as? UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
                UserDefaults.standard.set("No", forKey: mEmergency)
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func cameraBtn_clicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CameraQR") as? CameraQRViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func libraryBtn_clicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LibraryQR") as? LibraryQRViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func customizeUI() {
        
        camera_btn.setTitleColor(UIColor.white, for: .normal)
        camera_btn.layer.cornerRadius = 4.0
        camera_btn.layer.borderColor = UIColor.white.cgColor
        camera_btn.layer.borderWidth = 0.5
        camera_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        camera_btn.setTitle(NSLocalizedString("login_button_scanqr_title", comment: ""), for: .normal)
        
        library_btn.setTitleColor(UIColor.white, for: .normal)
        library_btn.layer.cornerRadius = 4.0
        library_btn.layer.backgroundColor = UIColor.secButtonColor.cgColor
        library_btn.setTitle(NSLocalizedString("login_button_library_title", comment: ""), for: .normal)
    }
}
