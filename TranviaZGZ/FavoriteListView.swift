//
//  FavoriteListView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI
import CoreData

struct FavoriteListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(entity: FavStop.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavStop.title, ascending: true)])
    
    var favorites: FetchedResults<FavStop>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favorites) { item in
                    NavigationLink(destination:
                                    StopDetailView(stopID: item.stopId!)
                                    .navigationTitle(item.title?.capitalized ?? "")
                    ) {
                        Text(item.title ?? "")
                    }
                    
                }
            }
            .navigationTitle("Favoritos")
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}
