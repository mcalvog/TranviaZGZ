//
//  TranviaZGZApp.swift
//  TranviaZGZ
//
//  Created by Marcos on 26/11/21.
//

import SwiftUI

@main
struct TranviaZGZApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
