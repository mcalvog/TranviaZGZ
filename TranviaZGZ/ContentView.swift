//
//  ContentView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .ignoresSafeArea()
            FavoriteListView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
