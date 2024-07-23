import SwiftUI

struct ContentView: View {
    @State private var currentDate = Date()
    private let calendar = Calendar.current
    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
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
            ForEach(weekdaySymbols.indices, id: \.self) { index in
                Text(weekdaySymbols[index])
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
        }
    }

    private var calendarGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(daysInMonth().indices, id: \.self) { index in
                if let date = daysInMonth()[index] {
                    dayView(for: date)
                } else {
                    Color.clear.frame(height: 50)
                }
            }
        }
    }

    private func dayView(for date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let isCurrentMonth = calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        
        return Text("\(calendar.component(.day, from: date))")
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(isToday ? Color.red : Color.clear)
            .foregroundColor(isToday ? .white : (isCurrentMonth ? .primary : .secondary))
            .font(isToday ? .title3.bold() : .title3)
            .clipShape(Circle())
            .opacity(isCurrentMonth ? 1 : 0.5)
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
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 28)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(30)
                }
                Spacer()
            }
            .padding(.top, 50)
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.8))
                    .edgesIgnoringSafeArea(.bottom)
            )
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
            .previewDevice("iPhone 15")
            .preferredColorScheme(.dark)
    }
}
