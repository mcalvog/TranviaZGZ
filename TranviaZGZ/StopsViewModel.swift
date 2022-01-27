//
//  StopsViewModel.swift
//  TranviaZGZ
//
//  Created by Marcos on 12/12/21.
//

import Foundation
import CoreData
import SwiftUI


class StopsViewModel: NSObject, ObservableObject {
    
    private var viewContext: NSManagedObjectContext
    
    private let apiClient = ApiClient()
    
    override init() {
        self.viewContext = PersistenceController.shared.container.viewContext
    }
    
    func getNetworkStops(completion: @escaping (Result<NetworkStopsResponse>) -> Void) {
        apiClient.getData("parada-tranvia.json", completion: completion)
    }
    
    func getNetworkStop(_ id: String, completion: @escaping (Result<NetworkStop>) -> Void) {
        apiClient.getData("parada-tranvia/\(id).json", completion: completion)
    }
    
    func toggleFavoriteStop(favorites: FetchedResults<FavStop>, stop: NetworkStop) -> Bool {
        if let favoriteStop = favorites.first(where: { $0.stopId == stop.id } ) {
            // Remove from favorites
            viewContext.delete(favoriteStop)
            try? viewContext.save()
            return false
        } else {
            // Add to favorites
            let favStop = FavStop(context : viewContext)
            favStop.stopId = stop.id
            favStop.title = stop.title
            
            try? viewContext.save()
            return true
        }
    }
    
}
