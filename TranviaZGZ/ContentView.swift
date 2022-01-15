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
                    Label("Mapa", systemImage: "map")
                }
            FavoriteListView()
                .tabItem {
                    Label("Favoritos", systemImage: "star")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
