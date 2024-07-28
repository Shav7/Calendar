import SwiftUI

struct BirthdayDetailView: View {
    @EnvironmentObject var birthdayManager: BirthdayManager
    var date: Date
    private let calendar = Calendar.current

    var body: some View {
        VStack {
            Text("Birthdays on \(date.formatted(.dateTime.month().day().year()))")
                .font(.system(size: 18, weight: .regular, design: .monospaced))
                .padding(.top, 10)
                .padding()
            
            List {
                ForEach(birthdayManager.birthdays(on: date)) { birthday in
                    VStack(alignment: .leading, spacing: 8) { // Add spacing here
                        Text(birthday.name)
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        Text("Turns \(birthday.age + 1) years old")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundColor(.gray)
                        if !birthday.notes.isEmpty {
                            Text("Notes: \(birthday.notes)") // Display notes here
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button("Back") {
            // Add your back action here if needed
        }.foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.5))
        .font(.system(size: 16, weight: .regular, design: .monospaced)))
    }
}

struct BirthdayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayDetailView(date: Date())
            .environmentObject(BirthdayManager())
    }
}




