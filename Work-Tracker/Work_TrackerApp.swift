//
//  Work_TrackerApp.swift
//  Work-Tracker
//
//  Created by Omar Leal on 2/2/23.
//

import SwiftUI

@main
struct Work_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
