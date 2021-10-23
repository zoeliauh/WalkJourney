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
    
    @IBOutlet weak var currentSteps: UILabel!
    
    @IBOutlet weak var currentduration: UILabel!
    
    @IBOutlet weak var currentDistance: UILabel!
    
    @IBOutlet weak var currentRouteMap: GMSMapView!
    
    var db: Firestore!
    
    let manager = CLLocationManager()
    
    var currentLocation = [Double]()
    
    let marker = GMSMarker()
    
    let activityManager = CMMotionActivityManager()
    
    let pedometer = CMPedometer()
    
    var timer = Timer()
    
    var count: Int = 0
    
    var timeString: String = ""
    
    var lastLocation: CLLocation?
    
    var distanceSum: Double = 0
    
    var newRecord: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        countTimer()
        
        countSteps()
        
        manager.startUpdatingLocation()
        
        manager.delegate = self
        
        currentRouteMap.layer.cornerRadius = 20
        
        finishButton.layer.cornerRadius = 20
        
        defaultPosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        defaultPosition()
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton!) {
        
        createNewRecord()
        
        manager.stopUpdatingLocation()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = secondToSecMinHour(seconds: count)
        
        timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        
        currentduration.text = timeString
    }
    
    func defaultPosition() {
        
        var camera = GMSCameraPosition()
        
        if currentLocation.count == 2 {
            
            camera = GMSCameraPosition.camera(withLatitude: currentLocation[0], longitude: currentLocation[1], zoom: 16)
            
            //            marker.position = CLLocationCoordinate2D(latitude: currentLocation[0], longitude: currentLocation[2])
        }
        
        camera = GMSCameraPosition.camera(withLatitude: 23.5, longitude: 123.5, zoom: 16)
        
        currentRouteMap.delegate = self
        
        currentRouteMap.camera = camera
        
        marker.map = currentRouteMap
        
        currentRouteMap.settings.myLocationButton = true
        
        currentRouteMap.isMyLocationEnabled = true
    }
    
    func createNewRecord() {
        
        guard let currentDistance = currentDistance.text, let currentduration = currentduration.text, let currentSteps = currentSteps.text else { return }
        
        RecordAfterWalking.shared.addNewRecord(distanceOfWalk: currentDistance, durationOfTime: currentduration, numberOfStep: Int(currentSteps)!, screenshot: "") { result in
            
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
                            print("STEPS : \(response.numberOfSteps)")
                            self.currentSteps.text = response.numberOfSteps.stringValue
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

extension StartToWalkPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        DispatchQueue.main.async {

        let path = GMSMutablePath()
        
        let location = locations.last
        
        let polyline = GMSPolyline(path: path)
        
        if let lastLocation = self.lastLocation,
           
            let location = location {
            
            let distance = location.distance(from: lastLocation)
            
            self.distanceSum += distance
                            
                path.add(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude))
                
                let formatDistanceSum = String(format: "%.2f", self.distanceSum / 1000)
                
                self.currentDistance.text = formatDistanceSum
                
                polyline.strokeWidth = 4
                
                polyline.strokeColor = .blue
                
                polyline.geodesic = true
                
                print(formatDistanceSum)
            }
            self.lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
}
