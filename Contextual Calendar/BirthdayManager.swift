import Foundation

class BirthdayManager: ObservableObject {
    @Published var birthdays: [Birthday]

    private let birthdaysKey = "birthdaysKey"

    init() {
        self.birthdays = []
        self.birthdays = loadBirthdays()
    }

    func addBirthday(_ birthday: Birthday) {
        birthdays.append(birthday)
    }

    private func saveBirthdays() {
        if let encoded = try? JSONEncoder().encode(birthdays) {
            UserDefaults.standard.set(encoded, forKey: birthdaysKey)
        }
    }

    private func loadBirthdays() -> [Birthday] {
        if let savedData = UserDefaults.standard.data(forKey: birthdaysKey),
           let decoded = try? JSONDecoder().decode([Birthday].self, from: savedData) {
            return decoded
        }
        return []
    }

    func birthdays(on date: Date) -> [Birthday] {
        let calendar = Calendar.current
        return birthdays.filter { calendar.isDate($0.nextBirthday, inSameDayAs: date) }
    }
}



