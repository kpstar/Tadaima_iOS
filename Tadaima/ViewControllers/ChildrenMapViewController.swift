//
//  ChildrenMapViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/12/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import KYDrawerController

class ChildrenMapViewController: UIViewController, GMSMapViewDelegate {
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var emergency_view: UIView!
    @IBOutlet weak var emergency_lbl: UILabel!
    @IBOutlet weak var manual_lbl: UILabel!
    
    var drawer: KYDrawerController? {
        get {
            return self.navigationController?.parent as? KYDrawerController
        }
    }
    
    let ref = Database.database().reference()
    
    var myLocation : CLLocationCoordinate2D?
    var pUid: String?
    var chUid: String?
    var homeMarker: GMSMarker?
    var myMarker: GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        customizeUIView()
        customizeNavigationBar()
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
        
        pUid = UserDefaults.standard.string(forKey: mParentUid)
        chUid = UserDefaults.standard.string(forKey: mChildUid)
        self.emergency_view.isHidden = !(UserDefaults.standard.string(forKey: mEmergency) == "Yes")
        
        self.emergency_lbl.layer.borderWidth = 0.5
        self.emergency_lbl.layer.borderColor = UIColor.white.cgColor
        self.emergency_lbl.layer.cornerRadius = 120
        self.emergency_lbl.text = NSLocalizedString("main_painc_mode_button_title", comment: "")
        self.emergency_lbl.layer.backgroundColor = UIColor.purple.cgColor
        let e_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.e_imageTapped))
        emergency_lbl.addGestureRecognizer(e_tapGestureRecognizer)
        
        self.manual_lbl.layer.borderWidth = 0.5
        self.manual_lbl.layer.borderColor = UIColor.white.cgColor
        self.manual_lbl.layer.cornerRadius = 120
        self.manual_lbl.layer.backgroundColor = UIColor.purple.cgColor
        self.manual_lbl.text = NSLocalizedString("main_manually_update_button_title", comment: "")
        let m_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.m_imageTapped))
        manual_lbl.addGestureRecognizer(m_tapGestureRecognizer)
        
        myMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        if UserDefaults.standard.string(forKey: mChildDraggable) == "Yes" {
            
            myMarker?.isDraggable = true
            locationManager.stopUpdatingLocation()
        }
        
        self.myMarker?.title = "Me"
        self.myMarker?.icon = self.imageWithImage(image: UIImage(named: "location")!, scaledToSize: CGSize(width: 60.0, height: 60.0))

        ref.child(mParent + "/" + pUid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let location = value?[mLocation] as? NSDictionary
            var latitude = 0.0
            var longitude = 0.0
            latitude = location?[mLatitude] as? Double ?? 0.0
            longitude = location?[mLongitude] as? Double ?? 0.0
       
            self.homeMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            self.homeMarker?.title = NSLocalizedString("drawer_childmenu_home", comment: "")
            self.homeMarker?.icon = self.imageWithImage(image: UIImage(named: "home")!, scaledToSize: CGSize(width: 50.0, height: 60.0))

            self.homeMarker?.map = self.mapView
        }) { (error) in
            self.showAlertMessage(text: error.localizedDescription)
        }

    }
    
    @objc func e_imageTapped() {
        
        emergency_lbl.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.emergency_lbl.alpha = 1.0
            self.emergency_view.isHidden = true
            UserDefaults.standard.set("No", forKey: mEmergency)
            self.ref.child(mChildren + "/" + self.pUid!).child(self.chUid!).updateChildValues([mStatus: "emergency"])
        }
    }
    
    @objc func m_imageTapped() {
        
        manual_lbl.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.manual_lbl.alpha = 1.0
            self.emergency_view.isHidden = true
            self.myMarker?.isDraggable = true
            UserDefaults.standard.set("No", forKey: mEmergency)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.myLocation = marker.position
        myMarker?.isDraggable = false
        UserDefaults.standard.set("No", forKey: mChildDraggable)
        self.updateMyLocation()
    }
    
    func updateMyLocation() {
        
        ref.child(mChildren + "/" + pUid!).child(chUid!).updateChildValues([mLocation: [mLatitude: self.myLocation?.latitude, mLongitude: self.myLocation?.longitude]])
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


extension ChildrenMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        myMarker?.position = location.coordinate
        myMarker?.map = self.mapView
        
        self.myLocation = location.coordinate
        self.updateMyLocation()
        self.updateMyStatus()
    }
    
    func updateMyStatus() {
        
        var status = "none"
        if self.homeMarker == nil {
            return
        }
        let me: CLLocationCoordinate2D = (self.myMarker?.position)!
        let home: CLLocationCoordinate2D = (self.homeMarker?.position)!
        if (me.latitude > home.latitude - 0.01) && (me.latitude < home.latitude + 0.01) && (me.longitude > home.longitude - 0.01) && (me.longitude < home.longitude + 0.01) {
            status = "home"
        } else {
            status = "away"
        }
        ref.child(mChildren + "/" + self.pUid!).child(self.chUid!).updateChildValues([mStatus: status])
    }
}
