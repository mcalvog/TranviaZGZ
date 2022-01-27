//
//  MapView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var stopsViewModel = StopsViewModel()
    
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var tramwayStops = [NetworkStop]()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: tramwayStops) { item in
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
                    getTramwayStops()
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
                    .isVisible(isLoadingContent())
            }
            .navigationTitle("Mapa")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }.alert(
            isPresented: $showErrorAlert,
            content: { Alert(title: Text("Ha ocurrido un error al cargar las paradas.")) }
        )
            .navigationViewStyle(.stack)
    }
    
    private func getTramwayStops() {
        if !tramwayStops.isEmpty {
            return
        }
        
        isLoading = true
        
        stopsViewModel.getNetworkStops { response in
            switch response {
            case .success(let data):
                isLoading = false
                tramwayStops = data.result
            case .error(let error):
                isLoading = false
                showErrorAlert = true
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func isLoadingContent() -> Binding<Bool> {
        return Binding<Bool>(get: { mapViewModel.isLoading || isLoading }, set: { _ in })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
