//
//  GoogleArtViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/3.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import CoreMotion
import CoreLocation
import SwiftUI

class GoogleArtViewController: UIViewController, GMSMapViewDelegate {
    
    lazy var routeSampleImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_tea_line")
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isHidden = true
       return imageView
    }()
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var timerlabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
//    @IBOutlet weak var routeSampleImageView: UIImageView!
    
    @IBOutlet weak var googleArtMapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var camera = GMSCameraPosition()
    
    var currentLocation = [Double]()
    
    var newLocation: (() -> Void)?
    
    var downCountTimer = 4
    
    var path = GMSMutablePath()
    
    var timer = Timer()
    
    let activityManager = CMMotionActivityManager()
    
    let pedometer = CMPedometer()
    
    var count: Int = 0
    
    var timeString: String = ""
    
    var lastLocation: CLLocation?
        
    var distanceSum: Double = 0
    
    var eachLatitude: [CLLocationDegrees] = []
    
    var eachLongitude: [CLLocationDegrees] = []
    
    var certainLat: [CLLocationDegrees] = []
    
    var certainLong: [CLLocationDegrees] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 20
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        defaultPosition()
        
        countDownStart()
        
        countTimer()
        
        countSteps()
        
        setupTestImageView()
                
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton!) {
        successMessage()
    }
    
    func countDownStart() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] (timer) in
            self.downCountTimer -= 1
            timerlabel.text = String(self.downCountTimer)
            if self.downCountTimer == 3 {
                timerlabel.isHidden = false
                timerLabelAnimation()
            }
            if self.downCountTimer == 2 {
                timerlabel.isHidden = false
                timerLabelAnimation()
            }
            if self.downCountTimer == 1 {
                timerlabel.isHidden = false
                timerLabelAnimation()
            }
            if self.downCountTimer == 0 {
                timer.invalidate()
                timerlabel.isHidden = true
                fadeOut()
                routeSampleImageView.isHidden = false
            }
        }
    }
    
    func defaultPosition() {
        
        googleArtMapView.delegate = self
        
        googleArtMapView.settings.myLocationButton = true
        
        googleArtMapView.isMyLocationEnabled = true
    }
    
    private func setupTestImageView() {
        
        view.addSubview(routeSampleImageView)
        
        routeSampleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            routeSampleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            routeSampleImageView.widthAnchor.constraint(equalToConstant: 150),
            routeSampleImageView.heightAnchor.constraint(equalToConstant: 150),
            routeSampleImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -79)
        ])
    }
    
    func createLocation() {
        
        CountingStepManager.shared.addNewLocation(latitude: currentLocation[0],
                                                  longitude: currentLocation[1]) { result in
            
            switch result {
                
            case .success:
                
                print("success to create new location")
                
                self.newLocation?()
                
            case .failure(let error):
                
                print("create location.failure: \(error)")
            }
        }
    }
    
    func timerLabelAnimation() {
        
        timerlabel.transform = CGAffineTransform(scaleX: 2.75, y: 2.75)
        
        UIView.animate(withDuration: 1) {
            self.timerlabel.transform = .identity
        }
    }
    
    func fadeOut() {
        
        UIView.animate(withDuration: 0.3) {
            self.coverImageView.alpha = 0
        }
    }
}

// MARK: - draw route
extension GoogleArtViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        if let location = locations.last {
            
            googleArtMapView.camera = GMSCameraPosition.camera(
                withLatitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                zoom: 15)
                    
            path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            eachLatitude.append(location.coordinate.latitude)
            
            eachLongitude.append(location.coordinate.longitude)
            
            print(eachLongitude.count)
            
            if eachLatitude.count == 1 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                        
            if eachLatitude.count % 5 == 0 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                                    
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 2
            
            polyline.strokeColor = (.DarkCeladon ?? .brown)
                        
            polyline.geodesic = true
            
            polyline.map = self.googleArtMapView
            
            if let lastLocation = lastLocation {
                
                let distance = location.distance(from: lastLocation)
                
                distanceSum += distance
                
                let formatDistanceSum = String(format: "%.2f", self.distanceSum / 1000)
                
                distanceLabel.text = formatDistanceSum
            }
            self.lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
    
    func successMessage() {
        
        let controller = UIAlertController(title: nil,
                                           message: "已成功儲存至足跡裡",
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定",
                                     style: .default
        ) { (_: UIAlertAction) in
            
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
        
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
}
// MARK: - timer counter
extension GoogleArtViewController {
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = secondToSecMinHour(seconds: count)
        
        timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        
        timeLabel.text = timeString
    }
    
    func countTimer() {
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerCounter),
            userInfo: nil,
            repeats: true)
    }
    
    func countSteps() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            self.paceLabel.text = response.numberOfSteps.stringValue
                        }
                    }
                }
            }
        }
    }
    
    func secondToSecMinHour(seconds: Int) -> (Int, Int, Int) {
        
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        
        var timeString: String = ""
        
        timeString += String(format: "%02d", hour)
        timeString += " : "
        timeString += String(format: "%02d", min)
        timeString += " : "
        timeString += String(format: "%02d", sec)
        
        return timeString
    }
}
