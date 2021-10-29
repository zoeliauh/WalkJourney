//
//  DetailRecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/26.
//

import UIKit
import GoogleMaps
import CoreMedia

class DetailRecordViewController: UIViewController {
    
    lazy var headerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.Celadon
        view.clipsToBounds = true
        return view
    }()
    
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = walkDate
        label.textAlignment = .center
        return label
    }()

    lazy var walkTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = walkTime
        label.textAlignment = .center
        return label
    }()
    
    lazy var walkStepLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "走了 \(walkStep ?? 0) 步"
        label.textAlignment = .center
        return label
    }()
    
    lazy var walkDistanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = walkDistance
        label.textAlignment = .center
        return label
    }()
    
    lazy var trackingMapView: GMSMapView = {
        
        let GMSMapView = GMSMapView()
        return GMSMapView
    }()
        
    let locationManager = CLLocationManager()
    
    var screenshotURL: String?
    
    var latitudeArr: [CLLocationDegrees] = []
    
    var longitudeArr: [CLLocationDegrees] = []
    
    var indexPath: IndexPath?
    
    var path = GMSMutablePath()
    
    var walkDate: String?
    
    var walkTime: String?
    
    var walkStep: Int?
    
    var walkDistance: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
        setupHeaderTitleLabel()
        setupWalkTimeLabel()
        setupWalkStepLabel()
        setupWalkDistanceLabel()
        setuptrackingMapView()
        setupBackIcon()
        locationManager(locationManager, latitude: latitudeArr, longitude: longitudeArr)
    }

    // MARK: - UI design
    private func setupHeader() {
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        headerView.backgroundColor = UIColor.Celadon
    }
    
    private func setupHeaderTitleLabel() {
        
        headerView.addSubview(headerTitleLabel)
        
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10)
        ])
    }
    
    private func setupWalkTimeLabel() {
        
        view.addSubview(walkTimeLabel)
        
        walkTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            walkTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            walkTimeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            walkTimeLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupWalkStepLabel() {
        
        view.addSubview(walkStepLabel)
        
        walkStepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            walkStepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            walkStepLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            walkStepLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupWalkDistanceLabel() {
        
        view.addSubview(walkDistanceLabel)
        
        walkDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            walkDistanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            walkDistanceLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            walkDistanceLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setuptrackingMapView() {
        
        view.addSubview(trackingMapView)
        
        trackingMapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            trackingMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackingMapView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 100),
            trackingMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackingMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    private func setupBackIcon() {
        let backButtonImage = UIImage(named: "Icons_24px_Back02")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}

extension DetailRecordViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, latitude: [CLLocationDegrees], longitude: [CLLocationDegrees]) {
        
        trackingMapView.camera = GMSCameraPosition.camera(withLatitude: latitude[0], longitude: longitude[0], zoom: 15)
                
        for index in 0..<latitude.count {
            
            path.addLatitude(latitudeArr[index], longitude: longitudeArr[index])
                        
                print("start do draw a line")
        
        let polyline = GMSPolyline(path: path)
        
                polyline.strokeWidth = 2
                
                polyline.strokeColor = .blue
                
                polyline.geodesic = true
                
                polyline.map = self.trackingMapView
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
}
