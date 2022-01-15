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
    
    @StateObject var stopsViewModel = StopsViewModel()
    @State var isLoading = false
    @State var isFavorite = false
    @State var stop: NetworkStop? = nil
    
    @State private var showShareMenu = false
    @State private var selectedDestino: NetworkDestino? = nil
    
    let stopID : String
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: FavStop.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavStop.title, ascending: true)]) var favorites: FetchedResults<FavStop>
 
    var body: some View {
        ZStack {
            VStack {
                List(stop?.destinos ?? []) { destino in
                    Button {
                        selectedDestino = destino
                        showShareMenu = true
                    } label: {
                        HStack {
                            Text("Destino: " + destino.destino.capitalized)
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
            
            if let favoriteStop = favorites.first(where: { $0.stopId == stopID } ){
                viewContext.delete(favoriteStop)
                isFavorite = false
            }
            else {
                let favStop = FavStop(context : viewContext)
                favStop.stopId = stopID
                favStop.title = stop?.title ?? ""
                do{
                    try viewContext.save()
                    isFavorite = true
                }
                catch{
                    //Error
                }
            }
            
        }) {
            if isFavorite {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
        })
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
