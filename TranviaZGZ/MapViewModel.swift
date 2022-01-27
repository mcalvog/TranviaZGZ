//
//  LocationManager.swift
//  TranviaZGZ
//
//  Created by Marcos on 2/12/21.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

// Location adapted from: https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-users-location-using-locationbutton

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.6563, longitude: -0.876566),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @Published var isLoading = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        if let coordinate = locationManager.location?.coordinate {
            // We already have user location
            setRegion(coordinate)
            return
        }
        
        // We do not have user location, we have to request it
        isLoading = true
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            setRegion(coordinate)
        }
        
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // ERROR getting user location
        isLoading = false
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
    }
    
}
