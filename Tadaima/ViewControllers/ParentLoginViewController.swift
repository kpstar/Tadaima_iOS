//
//  ParentLoginViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/9/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class ParentLoginViewController: UIViewController {
    
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var signup_btn: UIButton!
    
    var bannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        self.showAdMob()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener {(auth, user) in
            
            if user == nil {
                return
            }
            if user?.phoneNumber != nil {
                do {
                    try Auth.auth().signOut()
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
                    vc?.method = 0
                    self.navigationController?.pushViewController(vc!, animated: true)
                } catch {
                    
                }
                return
            } else if user?.email != nil && UserDefaults.standard.string(forKey: mUserCreated) == "" {
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "navDrawer") as? UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
            }
        }
    }
    
    func customizeUI() {
        
        login_btn.setTitleColor(UIColor.white, for: .normal)
        login_btn.layer.cornerRadius = 4.0
        login_btn.layer.borderColor = UIColor.white.cgColor
        login_btn.layer.borderWidth = 0.5
        login_btn.layer.backgroundColor = UIColor.colorBlue.cgColor
        login_btn.setTitle(NSLocalizedString("login_button_email_title", comment: ""), for: .normal)
        
        signup_btn.setTitleColor(UIColor.white, for: .normal)
        signup_btn.layer.cornerRadius = 4.0
        signup_btn.layer.backgroundColor = UIColor.secButtonColor.cgColor
        signup_btn.setTitle(NSLocalizedString("signup_button_email_title", comment: ""), for: .normal)
        
    }
    
    @IBAction func loginBtn_clicked(_ sender: UIButton) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
        vc?.method = 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func signupBtn_clicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
        vc?.method = 1
        self.navigationController?.pushViewController(vc!, animated: true)
//        let vc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneLogin") as? PhoneLoginViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
