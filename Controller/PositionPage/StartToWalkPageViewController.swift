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
    
    @IBOutlet weak var currentRouteMapView: GMSMapView! {
        
        didSet {
            currentRouteMapView.layer.cornerRadius = 20
            currentRouteMapView.delegate = self
        }
    }
    
    var db: Firestore!
    
    let locationManager = CLLocationManager()
    
    var path = GMSMutablePath()
    
    var camera = GMSCameraPosition()
    
    var currentLocation = [Double]()
    
    let pedometer = CMPedometer()
    
    var timer = Timer()
    
    var count: Int = 0
    
    var timeString: String = "" {
        
        didSet {
            durationLabel.text = timeString
        }
    }
    
    var lastLocation: CLLocation?
    
    var distanceSum: Double = 0
    
    var newRecord: (() -> Void)?
    
    var eachLocation: [CLLocationDegrees: CLLocationDegrees] = [:]
    
    var certainLat: [CLLocationDegrees] = []
    
    var certainLong: [CLLocationDegrees] = []
    
    var screenshotImageView = UIImageView()
        
    lazy var dismissButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.crossMark), for: .normal)
        return button
    }()
    
    lazy var finishButton: UIButton = {
        
        let button = UIButton()
        button.setTitle(String.finish, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        GoogleMapsManager.defaultPostion(currentRouteMapView)
        
        countTimer()
        
        countSteps()
        
        setupFinishButton()
        
        setUpDismissButton()
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
        
        let time = TimeManager.shared.secondToSecMinHour(seconds: count)
        
        timeString = TimeManager.shared.makeTimeString(hour: time.0, min: time.1, sec: time.2)
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
                                          screenshot: screenshotImageView) { result in
            
            switch result {
                
            case .success:
                
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, viewController: UIViewController) {
        
        GoogleMapsManager.handle(manager, didChangeAuthorization: status, viewController: self)
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
            
            if eachLocation.count == 1 {
                
                certainLat.append(location.coordinate.latitude)
                
                certainLong.append(location.coordinate.longitude)
            }
            
            if eachLocation.count % 8 == 0 {
                
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
        
        present(.confirmationAlert(
            title: String.successfulSave, message: nil,
            preferredStyle: .alert,
            actions: [
                UIAlertAction.addAction(
                    title: String.confirmed, style: .default,
                    handler: { [weak self] _ in
                        self?.dismiss(animated: true, completion: nil)
                    })]
        ), animated: true, completion: nil)
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
