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
    
    @State var trackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: mapViewModel.tramwayStops){ item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.geometry.coordinates[1], longitude: item.geometry.coordinates[0]) ){
                        
                        NavigationLink(destination: StopDetailView(stopID: item.id)){
                            Image("icon")
                        }
                    }
                }
                    .onAppear {
                        mapViewModel.fetchTramwayStops()
                    }
                
                Button(action: {
                    mapViewModel.requestLocation()
                }) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 34, height: 34)
                    Text("My position")
                        .bold()
                        .padding(.trailing, 16)
                }.background(Color.white)
                    .cornerRadius(17)
                    .shadow(color: .gray, radius: 4)
                    .padding(.bottom, 24)
                
                LoadingView()
                    .isVisible($mapViewModel.isLoading)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
