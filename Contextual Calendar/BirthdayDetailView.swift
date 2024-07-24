import SwiftUI

struct BirthdayDetailView: View {
    @EnvironmentObject var birthdayManager: BirthdayManager
    var date: Date
    private let calendar = Calendar.current

    var body: some View {
        VStack {
            Text("Birthdays on \(date.formatted(.dateTime.month().day().year()))")
                .font(.title2)
                .padding()
            
            List {
                ForEach(birthdayManager.birthdays(on: date)) { birthday in
                    VStack(alignment: .leading) {
                        Text(birthday.name)
                            .font(.headline)
                        Text("Turns \(birthday.age + 1) years old")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
}

struct BirthdayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayDetailView(date: Date())
            .environmentObject(BirthdayManager())
    }
}


