//
//  MapSearchingPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation

class MapSearchingPageViewController: UIViewController {
    
    @IBOutlet var mapInsertButtons: [UIButton]!
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    @IBOutlet weak var startButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    var isUpdatingLocation = false
    
    var lastLocationError: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.043, longitude: 121.565, zoom: 16.0)
        googleMapView.camera = camera
        
        googleMapView.layer.cornerRadius = 10
        
        startButton.layer.cornerRadius = 20
    }
    
    @IBAction func defineLocation(_ sender: UIButton) {
        for maps in mapInsertButtons {
            
            UIView.animate(withDuration: 0.3, animations: { maps.isHidden = !maps.isHidden
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func autoLocationPressed(_ sender: UIButton) {
        findLocation()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let startToWalkPagevc = UIStoryboard.position.instantiateViewController(withIdentifier: "StartToWalkPage") as? StartToWalkPageViewController else { return }
    }
    
    // MARK: - Target / Action
    func findLocation() {
        
        // 1. get the user's permission to use location services
        let authorizationStatus: CLAuthorizationStatus
        
        let manager = CLLocationManager()
        
        if #available(iOS 14, *) {
            
            authorizationStatus = manager.authorizationStatus
            
        } else {
            
            authorizationStatus = CLLocationManager.authorizationStatus()
            
        }
        
        if authorizationStatus == .notDetermined {
            
            locationManager.requestWhenInUseAuthorization()
            
            return
        }
        
        // 2. report to user if permission is denied - (1) user accidentally refused (2) the device is restricted
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            
            reportLocationServicesDeniedError()
            
            return
        }
        
        // 3. start / stop finding location
        locationManager.delegate = self
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func reportLocationServicesDeniedError() {
        
        let alert = UIAlertController(title: "Oops! Location Services Disabled.", message: "Please go to Settings to enable location services for this app.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MapSearchingPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        
        lastLocationError = error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // current location
        let currentLocation: CLLocation = locations[0] as CLLocation
        
        print("\(currentLocation.coordinate.latitude)")
        
        print("\(currentLocation.coordinate.longitude)")
    }
}
