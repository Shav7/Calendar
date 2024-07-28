import SwiftUI

struct AddBirthdayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var birthdayManager: BirthdayManager
    @Environment(\.colorScheme) var colorScheme
    @State private var name: String = ""
    @State private var date = Date()
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("BIRTHDAY DETAILS")
                    .foregroundColor(colorScheme == .dark ? .gray : .black)
                    .font(.system(size: 14, weight: .regular, design: .monospaced)) // Monospaced and smaller size for section header
                    .padding(.bottom, 12)) {
                    VStack(spacing: 18) { // Increased spacing
                        TextField("Name", text: $name)
                            .font(.system(.body, design: .monospaced)) // Monospaced font for text field
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 6) // Add vertical padding for more spacing
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .font(.system(.body, design: .monospaced)) // Monospaced font for date picker
                            .accentColor(Color(red: 0.2, green: 0.3, blue: 0.8)) // Dark blue color
                        
                        TextField("Notes", text: $notes)
                            .font(.system(.body, design: .monospaced)) // Monospaced font for text field
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 6) // Add vertical padding for more spacing
                    }
                    .padding(.horizontal, 5)
                }
            }
            .navigationBarTitle(Text("🎂")
                .font(.system(.title, design: .monospaced)), displayMode: .inline) // Monospaced font for navigation title
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.8))
            .font(.system(.body, design: .monospaced)), // Monospaced font for navigation buttons
            trailing: Button("Save") {
                let newBirthday = Birthday(name: name, date: date, notes: notes.isEmpty ? "" : notes)
                birthdayManager.addBirthday(newBirthday)
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.8))
            .font(.system(.body, design: .monospaced))) // Monospaced font for navigation buttons
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













