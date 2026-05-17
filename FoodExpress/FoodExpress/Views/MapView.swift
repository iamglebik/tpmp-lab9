//
//  MapView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 17.05.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationService = LocationService()
    @State private var restaurants: [Restaurant] = []
    @State private var selectedRestaurant: Restaurant?
    @State private var showAlert: Bool = false
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 53.9045, longitude: 27.5615),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(position: $cameraPosition) {
                    ForEach(restaurants) { restaurant in
                        Annotation(restaurant.name, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                            VStack {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                    .background(Circle().fill(Color.white).frame(width: 30, height: 30))
                                
                                Text(restaurant.name)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .padding(3)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .shadow(radius: 1)
                            }
                            .onTapGesture {
                                selectedRestaurant = restaurant
                                showAlert = true
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    if let nearest = findNearestRestaurant() {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading) {
                                Text(String(localized: "map_nearest"))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(nearest.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle(String(localized: "map_title"))
            .onAppear {
                loadRestaurants()
                locationService.requestPermission()
            }
            .alert(String(localized: "map_select_restaurant"), isPresented: $showAlert) {
                Button("OK") {
                    showAlert = false
                }
            } message: {
                if let restaurant = selectedRestaurant {
                    Text("\(restaurant.name)\n\(restaurant.cuisineType)")
                }
            }
        }
    }
    
    private func loadRestaurants() {
        restaurants = DatabaseService.shared.getAllRestaurants()
    }
    
    private func findNearestRestaurant() -> Restaurant? {
        guard let userLocation = locationService.userLocation else { return restaurants.first }
        
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
        
        return nearest
    }
}
