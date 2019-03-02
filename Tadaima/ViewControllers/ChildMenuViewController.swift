//
//  ChildMenuViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/26/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import KYDrawerController
import Firebase

class ChildMenuViewController: UIViewController {
    
    @IBOutlet weak var profile_img: UIImageView!
    @IBOutlet weak var desc_lbl: UILabel!
    @IBOutlet weak var menu_tbl: UITableView!
    
    var drawer: KYDrawerController? {
        get {
            return self.navigationController?.parent as? KYDrawerController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu_tbl.delegate = self
        menu_tbl.dataSource = self
        
        customizeUIView()
    }
    
    func customizeUIView() {
        
        desc_lbl.text = NSLocalizedString("profile_photo_change_title", comment: "")
    }
}

extension ChildMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var title = NSLocalizedString("drawer_menu_home", comment: "")
        if indexPath.row == 1 {
            title = NSLocalizedString("drawer_childmenu_emergency", comment: "")
        } else if indexPath.row == 2 {
            title = NSLocalizedString("drawer_menu_logout", comment: "")
        }
        cell.textLabel?.text = title
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.separatorInset = .init(top: 1, left: 1, bottom: 1, right: 1)
        cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            drawer?.performSegue(withIdentifier: "segueChildMain", sender: nil)
            UserDefaults.standard.set("No", forKey: mEmergency)
            drawer?.setDrawerState(.closed, animated: true)
        case 1:
            drawer?.performSegue(withIdentifier: "segueChildMain", sender: nil)
            UserDefaults.standard.set("Yes", forKey: mEmergency)
            drawer?.setDrawerState(.closed, animated: true)
        case 2:
            do {
                try Auth.auth().signOut()
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "Select") as? SelectViewController
                self.navigationController?.show(vc!, sender: nil)
            } catch {
                
            }
        default:
            return
        }
    }
}

