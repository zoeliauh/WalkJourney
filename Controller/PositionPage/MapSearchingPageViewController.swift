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
    
    var currentLocation = [Double]()
    
    var newLocation: (() -> Void)?
    
    lazy var startButton: UIButton = {
        
        let button = UIButton()
        button.setTitle(String.letsGo, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        GoogleMapsManager.defaultPostion(googleMapView)
        
        setupSearchVC()
                        
        setupStartButton()
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
    
        guard let startToWalkPageVC = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: StartToWalkPageViewController.self)
        ) as? StartToWalkPageViewController else { return }

        let navVC = UINavigationController(rootViewController: startToWalkPageVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
 
        startToWalkPageVC.currentLocation = currentLocation
    }
    
    func setupSearchVC() {
        
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
        
        searchVC.searchBar.searchTextField.textColor = .black
        
        searchVC.searchBar.backgroundColor = .white
    }
    
    func createLocation() {
        
        CountingStepManager.shared.addNewLocation(latitude: currentLocation[0],
                                                  longitude: currentLocation[1]) { result in
            
            switch result {
                
            case .success:
                                
                self.newLocation?()
                
            case .failure(let error):
                
                print("create location.failure: \(error)")
            }
        }
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
    
    func reportLocationServicesDeniedError() {
        
        present(.confirmationAlert(title: "Oops! Location Services Disabled.",
                                   message: "Please go to Settings to enable location services for this app.",
                                   preferredStyle: .alert,
                                   actions: [UIAlertAction.addAction(title: "ok", style: .default, handler: nil)]
                                  ), animated: true, completion: nil)
    }
}

extension MapSearchingPageViewController: ResultsViewControllerDelegate {

    func didTapPlace(with coordinate: CLLocationCoordinate2D, marker: GMSMarker) {
        
        var camera = GMSCameraPosition()

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

// MARK: - UI design
extension MapSearchingPageViewController {
    
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
