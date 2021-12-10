//
//  MapView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var locationManager = LocationManager()
    
    @State var trackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true, userTrackingMode: $trackingMode)
                
                Button(action: {
                    locationManager.requestLocation()
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
                    .isVisible($locationManager.isLoading)
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
