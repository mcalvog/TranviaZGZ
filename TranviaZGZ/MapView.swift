//
//  MapView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var mapViewModel = MapViewModel()
    @StateObject var stopsViewModel = StopsViewModel()
    
    @State var trackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: stopsViewModel.tramwayStops) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.geometry.coordinates[1], longitude: item.geometry.coordinates[0])) {
                        NavigationLink(destination:
                                        StopDetailView(stopID: item.id)
                                        .navigationTitle(item.title.capitalized)
                        ) {
                            Image("tramPointerIcon")
                        }
                    }
                }
                .onAppear {
                    stopsViewModel.fetchTramwayStops()
                }
                
                Button(action: {
                    mapViewModel.requestLocation()
                }) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 34, height: 34)
                    Text("Mi posición")
                        .bold()
                        .padding(.trailing, 16)
                }.background(Color(.systemBackground))
                    .cornerRadius(17)
                    .shadow(color: .black.opacity(0.5), radius: 4)
                    .padding(.bottom, 24)
                
                LoadingView()
                    .isVisible(isLoading())
            }
            .navigationTitle("Mapa")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
        .navigationViewStyle(.stack)
    }
    
    private func isLoading() -> Binding<Bool> {
        return Binding<Bool>(get: { mapViewModel.isLoading || stopsViewModel.isLoading }, set: { _ in })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
