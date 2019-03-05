//
//  EmergencyViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/15/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.performSegue(withIdentifier: "seguechildMain", sender: nil)
    }
}
