//
//  FavoriteListView.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI

struct FavoriteListView: View {
    var body: some View {
        NavigationView {
            Text("Favoritos")
                .navigationTitle("Favoritos")
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}
