//
//  StopsViewModel.swift
//  TranviaZGZ
//
//  Created by Marcos on 12/12/21.
//

import Foundation

class StopsViewModel: NSObject, ObservableObject {
    
    @Published var tramwayStops = [NetworkStop]()
    @Published var isLoading = false
    
    private let apiClient = ApiClient()
    
    func fetchTramwayStops(){
        if !tramwayStops.isEmpty {
            return
        }
        
        isLoading = true
        
        getNetworkStops { response in
            switch response {
            case .success(let data):
                self.isLoading = false
                self.tramwayStops = data.result
            case .error(let error):
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func getNetworkStop(_ id: String, completion: @escaping (Result<NetworkStop>) -> Void) {
        apiClient.getData("parada-tranvia/\(id).json", completion: completion)
    }
    
    func isFavoriteStop(_ id: String) -> Bool {
        // Recorrer array
        false
    }
    
    private func getNetworkStops(completion: @escaping (Result<NetworkStopsResponse>) -> Void) {
        apiClient.getData("parada-tranvia.json", completion: completion)
    }
    
}
