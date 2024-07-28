import Foundation
import Combine

class BirthdayManager: ObservableObject {
    @Published var birthdays: [Birthday] = []

    private let storageKey = "birthdays"

    init() {
        loadBirthdays()
    }

    func addBirthday(_ birthday: Birthday) {
        birthdays.append(birthday)
        saveBirthdays()
    }

    func removeBirthday(at offsets: IndexSet) {
        birthdays.remove(atOffsets: offsets)
        saveBirthdays()
    }

    func birthdays(on date: Date) -> [Birthday] {
        let calendar = Calendar.current
        return birthdays.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func saveBirthdays() {
        if let encoded = try? JSONEncoder().encode(birthdays) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadBirthdays() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let savedBirthdays = try? JSONDecoder().decode([Birthday].self, from: savedData) {
            birthdays = savedBirthdays
        }
    }
}




