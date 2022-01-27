//
//  StopDetailView.swift
//  TranviaZGZ
//
//  Created by Marcos on 12/12/21.
//

import SwiftUI
import WebKit
import CoreData

struct StopDetailView: View {
    
    @StateObject private var stopsViewModel = StopsViewModel()
    
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var isFavorite = false
    @State private var stop: NetworkStop? = nil
    
    @State private var showShareMenu = false
    @State private var selectedDestino: NetworkDestino? = nil
    
    let stopID : String
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: FavStop.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavStop.title, ascending: true)]) var favorites: FetchedResults<FavStop>
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("Destinos")) {
                        ForEach(stop?.destinos ?? []) { destino in
                            Button {
                                selectedDestino = destino
                                showShareMenu = true
                            } label: {
                                HStack {
                                    Text(destino.destino)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(destino.minutos) minutos")
                                        .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }.refreshable {
                    getStopData()
                }
                .listStyle(InsetGroupedListStyle())
                .confirmationDialog(
                    selectedDestino?.destino ?? "",
                    isPresented: $showShareMenu,
                    titleVisibility: .visible
                ) {
                    Button("Compartir") {
                        guard let stop = stop, let destino = selectedDestino else {
                            return
                        }
                        
                        let data = "\(stop.title)\n\n\(destino.destino): \(destino.minutos) minutos\n\nvía TranviaZGZ"
                        let avc = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        
                        let scenes = UIApplication.shared.connectedScenes
                        let windowScene = scenes.first as? UIWindowScene
                        let window = windowScene?.windows.first
                        
                        window?.rootViewController?.present(avc, animated: true, completion: nil)
                    }
                }
                
                Text(stop?.mensajes.joined() ?? "")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
            }
            
            LoadingView()
                .isVisible($isLoading)
        }.onAppear {
            getStopData()
            isFavorite = (favorites.first(where: { $0.stopId == stopID } ) != nil)
            
        }.navigationBarItems(trailing: Button(action: {
            
            if let selectedStop = stop {
                isFavorite = stopsViewModel.toggleFavoriteStop(favorites: favorites, stop: selectedStop)
            }
            
        }) {
            if isFavorite {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
        }).alert(
            isPresented: $showErrorAlert,
            content: { Alert(title: Text("Ha ocurrido un error al cargar la parada.")) }
        )
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getStopData() {
        isLoading = true
        stopsViewModel.getNetworkStop(stopID) { result in
            switch result {
            case .success(let data):
                isLoading = false
                stop = data
            case .error(let error):
                isLoading = false
                showErrorAlert = true
                
                print(error.localizedDescription)
            }
        }
    }
}

struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stopID: "")
    }
}
