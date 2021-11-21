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
            
    @IBOutlet weak var stepTitleLabel: UILabel!
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
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
    
    var screenshotImageView = UIImageView()
    
    lazy var dismissButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "Icon_cross_mark"), for: .normal)
        return button
    }()
    
    lazy var finishButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("完成囉", for: .normal)
        button.titleLabel?.font = UIFont.kleeOneSemiBold(ofSize: 18)
        button.backgroundColor = UIColor.C4
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layoutIfNeeded()
        return button
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFinishButton()
        
        setUpDismissButton()
        
        db = Firestore.firestore()
        
        countTimer()
        
        countSteps()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        currentRouteMapView.layer.cornerRadius = 20
                
        defaultPosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    @objc func finishButtonPressed(_ sender: UIButton!) {
                                        
        createNewRecord()
        
        successMessage()
    }
    
    @objc func dismissButtonPressed(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = secondToSecMinHour(seconds: count)
        
        timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        
        durationLabel.text = timeString
    }
    
    func defaultPosition() {
        
        currentRouteMapView.delegate = self
                
        currentRouteMapView.settings.myLocationButton = true
        
        currentRouteMapView.isMyLocationEnabled = true
    }

    func createNewRecord() {

            guard let curDist = distanceLabel.text,
                    let curdur = durationLabel.text,
                    let currentSteps = stepsLabel.text else { return }
        
        guard let numStep = Int(currentSteps) else { return }

        RecordManager.shared.addNewRecord(distanceWalk: curDist,
                                          durationTime: curdur,
                                          numStep: numStep,
                                          latitude: certainLat,
                                          longitude: certainLong,
                                          date: date, year: year, month: month,
                                          screenshot: screenshotImageView) { result in
            
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
                            self.stepsLabel.text = response.numberOfSteps.stringValue
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
                
        if let location = locations.last {
            
            currentRouteMapView.camera = GMSCameraPosition.camera(
                withLatitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                zoom: 16)
            
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
        
        let controller = UIAlertController(title: "儲存成功",
                                           message: nil,
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定",
                                     style: .default
        ) { (_: UIAlertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
}
// MARK: - UI design
extension StartToWalkPageViewController {
    private func setUpDismissButton() {
                        
        guard let nav = navigationController?.navigationBar else { return }
        
        nav.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dismissButton.leadingAnchor.constraint(equalTo: nav.leadingAnchor, constant: 30),
            dismissButton.topAnchor.constraint(equalTo: nav.topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
    }
    
    private func setupFinishButton() {
        
        view.addSubview(finishButton)
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            finishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
                
        finishButton.addTarget(self, action: #selector(finishButtonPressed(_:)), for: .touchUpInside)
    }
}
