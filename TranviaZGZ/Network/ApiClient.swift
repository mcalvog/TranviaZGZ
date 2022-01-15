//
//  ApiClient.swift
//  TranviaZGZ
//
//  Created by Marcos on 15/12/21.
//

import Foundation

class ApiClient: NSObject, ObservableObject {
    
    private let baseUrl = "https://www.zaragoza.es/sede/servicio/urbanismo-infraestructuras/transporte-urbano/"
    
    func getData<T: Decodable>(_ path: String, completion: @escaping (Result<T>) -> ()) {
        guard let url = URL(string: baseUrl + path) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let resData = data, let result = try? JSONDecoder().decode(T.self, from: resData), error == nil else {
                DispatchQueue.main.async {
                    completion(.error(error ?? NetworkError.unknown))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(result))
            }
        }.resume()
    }
    
}
