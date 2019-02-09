//
//  ViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/9/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    @IBOutlet weak var parent_img: UIImageView!
    @IBOutlet weak var child_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(p_imageTapped(tapGestureRecognizer:)))
        parent_img.isUserInteractionEnabled = true
        parent_img.addGestureRecognizer(p_tapGestureRecognizer)
        
        let c_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(c_imageTapped(tapGestureRecognizer:)))
        child_img.isUserInteractionEnabled = true
        child_img.addGestureRecognizer(c_tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parent_img.alpha = 1.0
        child_img.alpha = 1.0
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func c_imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.alpha = 0.3
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildLogin") as? ChildLoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    @objc func p_imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.alpha = 0.3
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParentLogin") as? ParentLoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

