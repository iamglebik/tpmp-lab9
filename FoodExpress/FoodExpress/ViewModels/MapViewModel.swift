//
//  MapViewModel.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import Foundation
import MapKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published Properties
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.8930, longitude: 27.5674),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var restaurants: [Restaurant] = []
    @Published var nearestRestaurant: Restaurant?
    
    // MARK: - Private Properties
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    
    // MARK: - Public Methods
    func checkIfLocationIsEnabled() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func loadRestaurants() {
        restaurants = DatabaseService.shared.fetchRestaurants()
        findNearestRestaurant()
    }
    
    func centerOnUserLocation() {
        if let location = currentLocation {
            region.center = location.coordinate
        }
    }
    
    // MARK: - Private Methods
    private func findNearestRestaurant() {
        guard let userLocation = currentLocation else { return }
        
        var nearest: Restaurant?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        
        for restaurant in restaurants {
            let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
            let distance = userLocation.distance(from: restaurantLocation)
            if distance < minDistance {
                minDistance = distance
                nearest = restaurant
            }
        }
        
        nearestRestaurant = nearest
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.requestLocation()
        case .denied:
            print("Location access denied")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            region.center = location.coordinate
            findNearestRestaurant()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
