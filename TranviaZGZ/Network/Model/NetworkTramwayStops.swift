//
//  NetworkTramwayStops.swift
//  TranviaZGZ
//
//  Created by Marcos on 12/12/21.
//

import Foundation

// MARK: - NetworkStopsResponse
struct NetworkStopsResponse: Codable {
    let result: [NetworkStop]
}

// MARK: - NetworkStop
struct NetworkStop: Codable, Identifiable {
    let id: String
    let uri: String
    let title: String
    let geometry: NetworkGeometry
    let lastUpdated: String
    let mensajes: [String]
    let icon: String
    let destinos: [NetworkDestino]?
    let description: String
}

// MARK: - NetworkDestino
struct NetworkDestino: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let linea: String
    let destino: String
    let minutos: Int
}

// MARK: - NetworkGeometry
struct NetworkGeometry: Codable {
    let coordinates: [Double]
}
