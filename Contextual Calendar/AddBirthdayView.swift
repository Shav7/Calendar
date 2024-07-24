import SwiftUI

struct AddBirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var birthdayManager: BirthdayManager
    @Environment(\.colorScheme) var colorScheme
    @State private var name: String = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Birthday Details")
                    .foregroundColor(colorScheme == .dark ? .gray : .black)
                    .padding(.bottom, 10)) {
                    VStack(spacing: 16) { // Increased spacing
                        TextField("Name", text: $name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 6) // Add vertical padding for more spacing
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .accentColor(.red) // Make the DatePicker elements red
                }
                .padding(.horizontal, 5)
            }
            .navigationBarTitle("Add Birthday", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red), trailing: Button("Save") {
                let newBirthday = Birthday(name: name, date: date)
                birthdayManager.addBirthday(newBirthday)
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
            .background(colorScheme == .dark ? Color.black : Color.white)
            .preferredColorScheme(colorScheme)
        }
        .preferredColorScheme(colorScheme)
    }
}

struct AddBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        AddBirthdayView().environmentObject(BirthdayManager())
    }
}





