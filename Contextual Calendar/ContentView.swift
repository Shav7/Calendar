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
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols // Change to shortWeekdaySymbols

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
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 {
                            // Swipe left
                            nextMonth()
                        } else if value.translation.width > 0 {
                            // Swipe right
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
            monthNavigationButton(systemName: "chevron.left", action: previousMonth)
            Spacer()
            Text(currentDate.formatted(.dateTime.month().year()))
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            monthNavigationButton(systemName: "chevron.right", action: nextMonth)
        }
        .padding(.horizontal)
    }

    private func monthNavigationButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(.red)
        }
    }

    private var weekdayHeaderView: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
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
                .background(isToday ? Color.red : Color.clear)
                .foregroundColor(isToday ? .white : (isCurrentMonth ? .primary : .secondary))
                .font(isToday ? .title3.bold() : .title3)
                .clipShape(Circle())
                .opacity(isCurrentMonth ? 1 : 0.5)
            
            if birthdayManager.birthdays(on: date).count > 0 {
                VStack {
                    Spacer()
                    Text("🎉")
                        .font(.caption)
                        .padding(.top, 25)
                }
            }
        }
    }

    private var bottomBar: some View {
        VStack {
            Spacer()
            HStack {
                Spacer() // This will push the "Today" button to the center
                Button(action: {
                    currentDate = Date()
                }) {
                    Text("Today")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 28)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(30)
                }
                Spacer() // This will push the "+" button to the right corner
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
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BirthdayManager())
            .previewDevice("iPhone 15")
            .preferredColorScheme(.dark)
    }
}


