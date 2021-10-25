//
//  UserLocationViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController {
    
    let mapSearchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        setupButton()
    }
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false
    var lastLocationError: Error?
    func updateUI() {
        
        if let location = location {
            // TODO: populate the location labels wiht coordinate info
        } else {
//            myLabel.text = "check location"
        }
    }
    
        // MARK: - Target / Action
    
    @objc func findLocation() {
        // 1. get the user's permission to use location services
        let authorizationStatus = CLLocationManager.authorizationStatus()
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

    }
    
    func reportLocationServicesDeniedError() {
        let alert = UIAlertController(title: "Oops! Location Services Disabled.", message: "Please go to Settings > Provacy to enable location services for this app.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func setupButton() {
        
        view.addSubview(mapSearchButton)

        mapSearchButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapSearchButton.backgroundColor = .black
        
        mapSearchButton.setTitle("find location", for: .normal)
        
        mapSearchButton.titleLabel?.textAlignment = .center
        
        mapSearchButton.addTarget(self, action: #selector(findLocation), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            mapSearchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),

            mapSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapSearchButton.heightAnchor.constraint(equalToConstant: 50),
            
            mapSearchButton.widthAnchor.constraint(equalToConstant: UIScreen.width * 1 / 2)
        
        ])
    }
}
