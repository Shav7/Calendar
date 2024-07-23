//
//  Contextual_CalendarApp.swift
//  Contextual Calendar
//
//  Created by Shahvir Sarkary on 2024-07-22.
//

import SwiftUI

@main
struct Contextual_CalendarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
