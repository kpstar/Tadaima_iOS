//
//  ParentInfoViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/12/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import MBProgressHUD
import KYDrawerController

class ParentInfoViewController: UIViewController {

    
    @IBOutlet weak var childInfo_btn: UIButton!
    @IBOutlet weak var setLocation_btn: UIButton!
    @IBOutlet weak var familyName_txt: SkyFloatingLabelTextField!
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    var drawer: KYDrawerController? {
        get {
            return self.navigationController?.parent as? KYDrawerController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUIView()
        customizeNavigationBar()
        familyName_txt.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        ref.child(mParent + "/" + uid!).updateChildValues([mFamilyName: textField.text as! String])
    }
    
    func customizeNavigationBar() {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: -10, y: 5, width: 30, height: 25)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func menuButtonPressed() {
        
        drawer?.setDrawerState(.opened, animated: true)
    }
    
    func customizeUIView() {
        
        childInfo_btn.layer.cornerRadius = 4.0
        childInfo_btn.layer.borderColor = UIColor.white.cgColor
        childInfo_btn.layer.borderWidth = 0.5
        childInfo_btn.setTitle(NSLocalizedString("parent_add_children_button_title", comment: ""), for: .normal)
        
        setLocation_btn.layer.cornerRadius = 4.0
        setLocation_btn.layer.borderColor = UIColor.white.cgColor
        setLocation_btn.layer.borderWidth = 0.5
        setLocation_btn.setTitle(NSLocalizedString("parent_set_home_button_title", comment: ""), for: .normal)
        
        familyName_txt.placeholder = NSLocalizedString("placeholder_family_name", comment: "")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ref.child(mParent + "/" + uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            MBProgressHUD.hide(for: self.view, animated: true)
            let value = snapshot.value as? NSDictionary
            let username = value?[mFamilyName] as? String ?? ""
            self.familyName_txt.text = username
        }) { (error) in
            self.showAlertMessage(text: error.localizedDescription)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func setMapBtn_clicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ParentMap") as? ParentMapViewController
        vc?.draggable = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addChildrenBtnClicked(_ sender: Any) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChildrenInfo") as? ChildrenInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
