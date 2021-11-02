//
//  GoogleMapsHelper.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/20.
//

import Foundation
import GoogleMaps
import CoreLocation

struct GoogleMapsManager {
    
    static let AppWorks = CLLocation(latitude: 25.043, longitude: 121.565)
    
    static var preciseLocationZoomLevel: Float = 15.0
    
    static var approximateLocationZoomLevel: Float = 10.0
    
    static func initLocationManager(_ locationManager: CLLocationManager, delegate: UIViewController) {
        
        locationManager.allowsBackgroundLocationUpdates = true

        locationManager.pausesLocationUpdatesAutomatically = false

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
    
    static func didUpdateLocations(_ locations: [CLLocation], locationManager: CLLocationManager, mapView: GMSMapView) {
        
        guard let lastLocation: CLLocation = locations.last else { return }
                    
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        
        let camera = GMSCameraPosition.camera(withLatitude: lastLocation.coordinate.latitude,
                                              longitude: lastLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(
            latitude: lastLocation.coordinate.latitude,
            longitude: lastLocation.coordinate.longitude
        )
                
        mapView.camera = camera
        
        marker.map = mapView        
    }
    
    static func handle(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        let accuracy = manager.accuracyAuthorization
        
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            print("Location status is authorizedAlways.")
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
}
