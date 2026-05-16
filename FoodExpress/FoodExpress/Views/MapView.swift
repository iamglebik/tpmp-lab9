//
//  MapView.swift
//  FoodExpress
//
//  Created by Глеб Синяков on 16.05.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedRestaurant: Restaurant?
    @StateObject private var cartViewModel = CartViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.restaurants) { restaurant in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                        Button(action: {
                            selectedRestaurant = restaurant
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                Text(restaurant.name)
                                    .font(.caption2)
                                    .padding(4)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    viewModel.checkIfLocationIsEnabled()
                    viewModel.loadRestaurants()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.centerOnUserLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Карта ресторанов")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedRestaurant) { restaurant in
                NavigationView {
                    RestaurantMenuView(restaurant: restaurant)
                        .environmentObject(cartViewModel)
                }
            }
        }
    }
}

#Preview {
    MapView()
}
