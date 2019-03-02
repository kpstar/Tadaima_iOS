//
//  ParentMapViewController.swift
//  Tadaima
//
//  Created by KpStar on 2/12/19.
//  Copyright © 2019 Tadaima. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import KYDrawerController

class ParentMapViewController: UIViewController, GMSMapViewDelegate {
    
    private let locationManager = CLLocationManager()
    let ref = Database.database().reference()

    @IBOutlet weak var mapView: GMSMapView!
    var homeLocation: CLLocationCoordinate2D?
    var homeMarker: GMSMarker?
    let uid = Auth.auth().currentUser?.uid
    var draggable: Bool?
    var initial: Bool?
    
    var drawer: KYDrawerController? {
        get {
            return self.navigationController?.parent as? KYDrawerController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
        
        if draggable == true {
            let rButton = UIButton(type: .custom)
            rButton.setTitle("Done", for: .normal)
            rButton.setTitleColor(UIColor.black, for: .normal)
            rButton.addTarget(self, action: #selector(homeLocationChanged), for: .touchUpInside)
            rButton.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
            let rBarButton = UIBarButtonItem(customView: rButton)
            self.navigationItem.rightBarButtonItem = rBarButton
        }
    }
    
    @objc func homeLocationChanged() {
        
        ref.child(mParent + "/" + uid!).updateChildValues([mLocation: [mLatitude: self.homeLocation?.latitude, mLongitude: self.homeLocation?.longitude]])
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func menuButtonPressed() {
        
        drawer?.setDrawerState(.opened, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser?.uid
        ref.child(mParent + "/" + uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let location = value?[mLocation] as? NSDictionary
            var latitude = 0.0
            var longitude = 0.0
            latitude = location?[mLatitude] as? Double ?? 0.0
            longitude = location?[mLongitude] as? Double ?? 0.0
            
            if latitude == 0.0 || longitude == 0.0 {
                self.locationManager.startUpdatingLocation()
                self.initial = false
            } else {
                self.locationManager.stopUpdatingLocation()
                self.homeLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.homeMarker = GMSMarker(position: self.homeLocation!)
                self.homeMarker?.title = NSLocalizedString("drawer_childmenu_home", comment: "")
                self.homeMarker?.icon = self.imageWithImage(image: UIImage(named: "home")!, scaledToSize: CGSize(width: 40.0, height: 45.0))
                if self.draggable == true {
                    self.homeMarker?.isDraggable = true
                }
                self.homeMarker?.map = self.mapView
                self.mapView.camera = GMSCameraPosition(target: self.homeLocation!, zoom: 15, bearing: 0, viewingAngle: 0)
            }
        }) { (error) in
            self.showAlertMessage(text: error.localizedDescription)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.homeLocation = marker.position
    }
}

extension ParentMapViewController: CLLocationManagerDelegate {
    
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
        
        if self.initial == true {
            return
        }

        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
        self.ref.child(mParent + "/" + uid!).updateChildValues([mLocation: [mLatitude: location.coordinate.latitude, mLongitude: location.coordinate.longitude]])
        self.homeLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.homeMarker = GMSMarker(position: self.homeLocation!)
        self.homeMarker?.title = NSLocalizedString("drawer_childmenu_home", comment: "")
        self.homeMarker?.icon = self.imageWithImage(image: UIImage(named: "home")!, scaledToSize: CGSize(width: 40.0, height: 45.0))
        if self.draggable == true {
            self.homeMarker?.isDraggable = true
        }
        self.homeMarker?.map = self.mapView
        self.initial = true
    }
}
