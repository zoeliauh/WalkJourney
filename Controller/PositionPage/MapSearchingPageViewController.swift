//
//  MapSearchingPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapSearchingPageViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var googleMapView: GMSMapView!
        
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    var locationManager = CLLocationManager()
        
    let marker = GMSMarker()
    
    var camera = GMSCameraPosition()
    
    var currentLocation = [Double]()
    
    var newLocation: (() -> Void)?
    
    lazy var startButton: UIButton = {
        
        let button = UIButton()
        button.setTitle(String.letsGo, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
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
                        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        setupSearchVC()
        
        defaultPosition()
        
        googleMapView.layer.cornerRadius = 10
        
        setupStartButton()
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
    
        guard let startToWalkPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: StartToWalkPageViewController.self)
        ) as? StartToWalkPageViewController else { return }

        let navvc = UINavigationController(rootViewController: startToWalkPagevc)
        navvc.modalPresentationStyle = .fullScreen
        self.present(navvc, animated: true, completion: nil)
 
        startToWalkPagevc.currentLocation = currentLocation
    }
    
    func setupSearchVC() {
        
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
        
        searchVC.searchBar.searchTextField.textColor = .black
        
        searchVC.searchBar.backgroundColor = .white
    }
    
    func defaultPosition() {
        
        camera = GMSCameraPosition.camera(withLatitude: 25.043, longitude: 121.565, zoom: 16.0)
                
        googleMapView.delegate = self
        
        googleMapView.camera = camera
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.isMyLocationEnabled = true
        
        marker.map = googleMapView
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
    
    func reportLocationServicesDeniedError() {
        
        let alert = UIAlertController(title: "Oops! Location Services Disabled.",
                                      message: "Please go to Settings to enable location services for this app.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setupStartButton() {
        
        view.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
                
        startButton.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
    }
}

extension MapSearchingPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        GoogleMapsManager.didUpdateLocations(locations, locationManager: locationManager, mapView: googleMapView)
        
        locationManager.stopUpdatingLocation()
        
        if let currentLocation = manager.location?.coordinate {
            
            self.currentLocation = []
            
            self.currentLocation = [currentLocation.latitude, currentLocation.longitude]
            
            createLocation()
        }
        print("currentLocation is \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        GoogleMapsManager.handle(manager, didChangeAuthorization: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
}

extension MapSearchingPageViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text,
              
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else { return }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlace(query: query) { result in
            switch result {
                
            case .success(let places):
                
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MapSearchingPageViewController: ResultsViewControllerDelegate {
    
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        
        searchVC.searchBar.resignFirstResponder()
        
        searchVC.dismiss(animated: true, completion: nil)
        
        camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                          longitude: coordinate.longitude,
                                          zoom: 16.0)
                
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        googleMapView.camera = camera
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.isMyLocationEnabled = true
        
        currentLocation = []
        
        currentLocation = [coordinate.latitude, coordinate.longitude]
        
        createLocation()
        
        print("location defined by user is \(coordinate)")
    }
}
