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

// Adapted from: https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-users-location-using-locationbutton

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    private let tramwayStopsURL : URL = URL( string: "https://www.zaragoza.es/sede/servicio/urbanismo-infraestructuras/transporte-urbano/parada-tranvia.json")!
    
    
    @Published var tramwayStops = [NetworkStop]()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.6563, longitude: -0.876566),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @Published var isLoading = false

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
    
    
    func fetchTramwayStops(){
        
        isLoading = true
        
        URLSession.shared.dataTask(with: tramwayStopsURL) { data, response, error in
            if let tramwayStopsData = data {
                let tramwayStopsResponse = try! JSONDecoder().decode(NetworkStopsResponse.self, from: tramwayStopsData)
                DispatchQueue.main.async {
                    self.tramwayStops = tramwayStopsResponse.result
                    print(self.tramwayStops)
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
    }
    
    
    
}
