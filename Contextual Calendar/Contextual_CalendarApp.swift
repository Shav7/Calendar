import SwiftUI

@main
struct Contextual_CalendarApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var birthdayManager = BirthdayManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(birthdayManager)
        }
    }
}

