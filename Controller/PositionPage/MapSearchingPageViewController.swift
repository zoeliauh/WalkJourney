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
import MapKit

class MapSearchingPageViewController: UIViewController, GMSMapViewDelegate {
        
    @IBOutlet weak var googleMapView: GMSMapView!
    
    @IBOutlet weak var startButton: UIButton!
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    var locationManager = CLLocationManager()
    
    var placesClient = GMSPlacesClient()
    
    let marker = GMSMarker()
    
    var camera = GMSCameraPosition()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        print(GMSServices.openSourceLicenseInfo())
    
        GoogleMapsHelper.initLocationManager(locationManager, delegate: self)
        
        defaultPosition()
        
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
        
        googleMapView.layer.cornerRadius = 10
        
        startButton.layer.cornerRadius = 20
        
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        guard let startToWalkPagevc = UIStoryboard.position.instantiateViewController(withIdentifier: "StartToWalkPage") as? StartToWalkPageViewController else { return }
    }
    
    func defaultPosition() {
        
        camera = GMSCameraPosition.camera(withLatitude: 25.043, longitude: 121.565, zoom: 16.0)
                        
        marker.position = CLLocationCoordinate2D(latitude: 25.043, longitude: 121.565)
        
        googleMapView.delegate = self
        
        googleMapView.camera = camera
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.isMyLocationEnabled = true
                
        marker.map = googleMapView
    }
    
    func reportLocationServicesDeniedError() {
        
        let alert = UIAlertController(title: "Oops! Location Services Disabled.", message: "Please go to Settings to enable location services for this app.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MapSearchingPageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation: CLLocation = locations[0] as CLLocation
        
        GoogleMapsHelper.didUpdateLocations(locations, locationManager: locationManager, mapView: googleMapView)
        
        print("\(currentLocation.coordinate.latitude)")
        
        print("\(currentLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        GoogleMapsHelper.handle(manager, didChangeAuthorization: status)
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
        
        camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
        
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        googleMapView.camera = camera
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.isMyLocationEnabled = true
        
        print("\(coordinate.latitude)")
        
        print("\(coordinate.longitude)")
    }
}
