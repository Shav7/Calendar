import Foundation

struct Birthday: Codable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var notes: String // Add this line
    
    var nextBirthday: Date {
        let calendar = Calendar.current
        let now = Date()
        var nextDateComponents = calendar.dateComponents([.month, .day], from: date)
        nextDateComponents.year = calendar.component(.year, from: now)
        
        if let nextBirthday = calendar.date(from: nextDateComponents), nextBirthday >= now {
            return nextBirthday
        } else {
            nextDateComponents.year! += 1
            return calendar.date(from: nextDateComponents)!
        }
    }
    
    var age: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year!
    }
}


