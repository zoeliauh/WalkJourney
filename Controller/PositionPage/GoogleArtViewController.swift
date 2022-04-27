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
        imageView.image = UIImage.asset(.bubbleTeaLine)
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isHidden = true
       return imageView
    }()
    
    lazy var dismissButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.crossMark), for: .normal)
        return button
    }()
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var timerlabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton! {
        
        didSet {
            
            doneButton.buttonConfig(doneButton, cornerRadius: 20)
        }
    }
    
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
        
    @IBOutlet weak var googleArtMapView: GMSMapView!
    
    var newRecord: (() -> Void)?
    
    var locationManager = CLLocationManager()
    
    var camera = GMSCameraPosition()
    
    var currentLocation = [Double]()
    
    var newLocation: (() -> Void)?
        
    var path = GMSMutablePath()
    
    var timer = Timer()
        
    let pedometer = CMPedometer()
    
    var count: Int = 0
    
    var timeString: String = "" {
        
        didSet {
            
            timeLabel.text = timeString
        }
    }
    
    var lastLocation: CLLocation?
        
    var distanceSum: Double = 0
    
    var eachLocation: [CLLocationDegrees: CLLocationDegrees] = [:]
    
    var certainLat: [CLLocationDegrees] = []
    
    var certainLong: [CLLocationDegrees] = []
    
    var screenshotImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        GoogleMapsManager.defaultPostion(googleArtMapView)
                
        countDownStart()

        countSteps()
                
        setupRouteSampleImageView()
        
        setUpDismissButton()
                        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton!) {
        
        doneButton.isHidden = true
        
        dismissButton.isHidden = true
        
        let screenshotImage = self.view.takeScreenshot()
        
        screenshotImageView.image = screenshotImage
        
        createNewRecord()
        
        locationManager.stopUpdatingLocation()
        
        successMessage()
    }
    
    @objc func dismissButtonPressed(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
    
    func countDownStart() {
        
        var downCountTimer = 4
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            
            downCountTimer -= 1
            
            self?.timerlabel.text = String(downCountTimer)
            self?.timerlabel.isHidden = false
            self?.timerLabelAnimation()
            
            if downCountTimer == 0 {
                timer.invalidate()
                self?.timerlabel.isHidden = true
                self?.fadeOut()
                self?.routeSampleImageView.isHidden = false
                self?.countTimer()
            }
        }
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
                                          screenshot: screenshotImageView) { result in
            
            switch result {
                
            case .success:
                
                self.newRecord?()
                
            case .failure(let error):
                
                print("add new record failure \(error)")
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, viewController: UIViewController) {
        
        GoogleMapsManager.handle(manager, didChangeAuthorization: status, viewController: self)
    }
}

extension GoogleArtViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            googleArtMapView.camera = GMSCameraPosition.camera(
                withLatitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                zoom: 15)
                            
            path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)

            eachLocation[location.coordinate.latitude] = location.coordinate.longitude
            
            if eachLocation.count == 1 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                        
            if eachLocation.count % 5 == 0 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
                                    
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 2
            
            polyline.strokeColor = (UIColor.black)
                        
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
        
        present(.confirmationAlert(
            title: String.successfulSave, message: nil, preferredStyle: .alert,
            actions: [UIAlertAction.addAction(title: String.confirmed, style: .default, handler: { _ in
                    
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.selectedIndex = 1
                    self.tabBarController?.tabBar.isHidden = false
                })]
        ), animated: true, completion: nil)
    }
}

extension GoogleArtViewController {
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = TimeManager.shared.secondToSecMinHour(seconds: count)
        
        timeString = TimeManager.shared.makeTimeString(hour: time.0, min: time.1, sec: time.2)
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
}

// MARK: UI design
extension GoogleArtViewController {
    
    private func setupRouteSampleImageView() {
        
        view.addSubview(routeSampleImageView)
        
        routeSampleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            routeSampleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            routeSampleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            routeSampleImageView.widthAnchor.constraint(equalToConstant: 150),
            routeSampleImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setUpDismissButton() {
                                
        view.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
    }
}
