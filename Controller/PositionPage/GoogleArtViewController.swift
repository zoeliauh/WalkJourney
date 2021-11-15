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
        
    @IBOutlet weak var googleArtMapView: GMSMapView!
    
    var newRecord: (() -> Void)?
    
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
    
    var screenshotImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDoneButton()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        defaultPosition()
        
        countDownStart()

        countSteps()
                
        setupRouteSampleImageView()
                
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton!) {
        
        doneButton.isHidden = true
        
        let screenshotImage = self.view.takeScreenshot()
        
        screenshotImageView.image = screenshotImage
        
        createNewRecord()
        
        locationManager.stopUpdatingLocation()
        
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
                countTimer()
            }
        }
    }
    
    func defaultPosition() {
        
        googleArtMapView.delegate = self
        
        googleArtMapView.settings.myLocationButton = true
        
        googleArtMapView.isMyLocationEnabled = true
    }
    
    func createNewRecord() {

            guard let curDist = distanceLabel.text,
                    let curdur = timeLabel.text,
                    let currentSteps = paceLabel.text else { return }
        
        guard let numStep = Int(currentSteps) else { return }

        RecordManager.shared.addNewRecord(distanceWalk: curDist,
                                          durationTime: curdur,
                                          numStep: numStep,
                                          latitude: certainLat,
                                          longitude: certainLong,
                                          date: "", year: "", month: "",
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
    
    private func setupRouteSampleImageView() {
        
        view.addSubview(routeSampleImageView)
        
        routeSampleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            routeSampleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            routeSampleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            routeSampleImageView.widthAnchor.constraint(equalToConstant: 150),
            routeSampleImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupDoneButton() {
        
        doneButton.layer.cornerRadius = 20
        doneButton.layer.shadowOpacity = 0.3
        doneButton.layer.shadowRadius = 2.0
        doneButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        doneButton.layer.shadowColor = UIColor.black.cgColor
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
            
            polyline.strokeColor = (UIColor.C6 ?? .brown)
                        
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
        
        let controller = UIAlertController(title: "成功儲存",
                                           message: "請至 足跡 -> 挑戰地圖 查看或分享",
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
        
        if hour == 0 {
            
            timeString += String(format: "%02d", min)
            timeString += " : "
            timeString += String(format: "%02d", sec)
        } else {
            
            timeString += String(format: "%02d", hour)
            timeString += " : "
            timeString += String(format: "%02d", min)
            timeString += " : "
            timeString += String(format: "%02d", sec)
        }
        return timeString
    }
}
