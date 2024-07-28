import SwiftUI

struct IdentifiableDate: Identifiable {
    let id = UUID()
    let date: Date
}

struct ContentView: View {
    @State private var currentDate = Date()
    @State private var showingAddBirthday = false
    @State private var selectedDate: IdentifiableDate?
    @EnvironmentObject var birthdayManager: BirthdayManager
    private let calendar = Calendar.current
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                headerView
                weekdayHeaderView
                calendarGridView
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(gradientBackground.edgesIgnoringSafeArea(.all))
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height < 0 {
                            nextMonth()
                        } else if value.translation.height > 0 {
                            previousMonth()
                        }
                    }
            )
            
            bottomBar
        }
        .sheet(isPresented: $showingAddBirthday) {
            AddBirthdayView()
                .environmentObject(birthdayManager)
        }
        .sheet(item: $selectedDate) { selectedDate in
            BirthdayDetailView(date: selectedDate.date)
                .environmentObject(birthdayManager)
        }
    }

    private var headerView: some View {
        HStack {
            monthNavigationButton(systemName: "chevron.up", action: previousMonth)
            Spacer()
            Text(currentDate.formatted(.dateTime.month().year()))
                .font(.system(.title, design: .monospaced))
                .fontWeight(.bold)
            Spacer()
            monthNavigationButton(systemName: "chevron.down", action: nextMonth)
        }
        .padding(.horizontal)
    }

    private func monthNavigationButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(.title2, design: .monospaced))
                .foregroundColor(.white)
        }
    }

    private var weekdayHeaderView: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .frame(maxWidth: .infinity)
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
        }
    }

    private var calendarGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(daysInMonth(), id: \.self) { date in
                if let date = date {
                    dayView(for: date)
                        .onTapGesture {
                            selectedDate = IdentifiableDate(date: date)
                        }
                } else {
                    Color.clear.frame(height: 50)
                }
            }
        }
    }

    private func dayView(for date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let isCurrentMonth = calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        
        return ZStack {
            Text("\(calendar.component(.day, from: date))")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(isToday ? (Color(red: 0.1, green: 0.3, blue: 0.5)) : Color.clear)
                .background(Color.black.opacity(0.1))
                .foregroundColor(isToday ? .white : (isCurrentMonth ? .primary : .secondary))
                .font(isToday ? .system(.title3, design: .monospaced).bold() : .system(.body, design: .monospaced))
                .clipShape(Circle())
                .opacity(isCurrentMonth ? 1 : 0.5)
            
            if birthdayManager.birthdays(on: date).count > 0 {
                VStack {
                    Spacer()
                    Text("🎉")
                        .font(.system(.caption, design: .monospaced))
                        .padding(.top, 25)
                }
            }
        }
    }

    private var bottomBar: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    currentDate = Date()
                }) {
                    Text("Today")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 28)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(30)
                }
                Spacer()
            }
            .padding(.bottom, -80)
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.8))
                    .edgesIgnoringSafeArea(.bottom)
            )
            
            HStack {
                Spacer()
                Button(action: {
                    showingAddBirthday = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                        .padding(.trailing, 20)
                        .padding(.bottom, 0)
                }
            }
        }
    }

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        
        let firstDayOfMonth = monthInterval.start

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        let totalDays = calendar.range(of: .day, in: .month, for: currentDate)!.count + offsetDays
        let totalCells = ((totalDays - 1) / 7 + 1) * 7
        
        return (0..<totalCells).map { day in
            calendar.date(byAdding: .day, value: day - offsetDays, to: firstDayOfMonth)
        }
    }

    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }

    private var gradientBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.0, green: 0.1, blue: 0.2), Color(red: 0.6, green: 0.7, blue: 0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BirthdayManager())
            .previewDevice("iPhone 15")
            .preferredColorScheme(.dark)
    }
}









