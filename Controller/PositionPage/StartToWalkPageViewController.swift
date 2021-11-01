//
//  StartToWalkPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import CoreMotion
import CoreLocation

class StartToWalkPageViewController: UIViewController, GMSMapViewDelegate {
        
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var stepTitleLabel: UILabel!
    
    @IBOutlet weak var currentStepsLabel: UILabel!
    
    @IBOutlet weak var currentdurationLabel: UILabel!
    
    @IBOutlet weak var currentDistanceLabel: UILabel!
    
    @IBOutlet weak var currentRouteMapView: GMSMapView!
    
    var db: Firestore!
    
    let locationManager = CLLocationManager()
    
    var path = GMSMutablePath()
    
    var camera = GMSCameraPosition()
    
    var currentLocation = [Double]()
        
    let activityManager = CMMotionActivityManager()
    
    let pedometer = CMPedometer()
    
    var timer = Timer()
    
    var count: Int = 0
    
    var timeString: String = ""
    
    var lastLocation: CLLocation?
        
    var distanceSum: Double = 0
    
    var newRecord: (() -> Void)?
        
    var eachLatitude: [CLLocationDegrees] = []
    
    var eachLongitude: [CLLocationDegrees] = []
    
    var certainLat: [CLLocationDegrees] = []
    
    var certainLong: [CLLocationDegrees] = []
    
    var date: String = ""
    
    var year: String = ""
    
    var month: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        countTimer()
        
        countSteps()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        currentRouteMapView.layer.cornerRadius = 20
        
        finishButton.layer.cornerRadius = 20
        
        defaultPosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton!) {
                                        
        createNewRecord()
        
        locationManager.stopUpdatingLocation()
        
        successMessage()
    }
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = secondToSecMinHour(seconds: count)
        
        timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        
        currentdurationLabel.text = timeString
    }
    
    func defaultPosition() {
        
        currentRouteMapView.delegate = self
                
        currentRouteMapView.settings.myLocationButton = true
        
        currentRouteMapView.isMyLocationEnabled = true
    }
    // swiftlint:disable line_length
    func createNewRecord() {

            guard let currentDistance = currentDistanceLabel.text, let currentduration = currentdurationLabel.text, let currentSteps = currentStepsLabel.text else { return }
        guard let numberOfStep = Int(currentSteps) else { return }

        RecordAfterWalkingManager.shared.addNewRecord(distanceWalk: currentDistance, durationTime: currentduration, numStep: numberOfStep, latitude: certainLat, longitude: certainLong, date: date, year: year, month: month) { result in
            
            switch result {
                
            case .success:
                
                print("successful to upload the new record")
                self.newRecord?()
                
            case .failure(let error):
                
                print("add new record failure \(error)")
            }
        }
    }
    
    func countTimer() {
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func countSteps() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            self.currentStepsLabel.text = response.numberOfSteps.stringValue
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
    
    func finishedMessage() {
        
        let controller = UIAlertController(title: nil,
                                           message: "已成功儲存至足跡",
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}

extension StartToWalkPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        if let location = locations.last {
            
            currentRouteMapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
            
            path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            eachLatitude.append(location.coordinate.latitude)
            
            eachLongitude.append(location.coordinate.longitude)
            
            print(eachLongitude.count)
            
            if eachLatitude.count == 1 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                        
            if eachLatitude.count % 8 == 0 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                                    
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 2
            
            polyline.strokeColor = .blue
            
            polyline.geodesic = true
            
            polyline.map = self.currentRouteMapView
            
            if let lastLocation = lastLocation {
                
                let distance = location.distance(from: lastLocation)
                
                distanceSum += distance
                
                let formatDistanceSum = String(format: "%.2f", self.distanceSum / 1000)
                
                currentDistanceLabel.text = formatDistanceSum
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
        let okAction = UIAlertAction(title: "確定", style: .default) { (action: UIAlertAction) in self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}
