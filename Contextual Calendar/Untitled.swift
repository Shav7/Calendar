import SwiftUI

struct WeekView: View {
    @State private var currentDate = Date()
    private let calendar = Calendar.current
    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols

    var body: some View {
        VStack(spacing: 20) {
            headerView
            weekdayHeaderView
            weekGridView
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .overlay(bottomBar, alignment: .bottom)
    }

    private var headerView: some View {
        HStack {
            monthNavigationButton(systemName: "chevron.left", action: previousWeek)
            Spacer()
            Text(currentDate.formatted(.dateTime.month().day().year()))
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            monthNavigationButton(systemName: "chevron.right", action: nextWeek)
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

    private var weekGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(daysInWeek().indices, id: \.self) { index in
                if let date = daysInWeek()[index] {
                    dayView(for: date)
                } else {
                    Color.clear.frame(height: 50)
                }
            }
        }
    }

    private func dayView(for date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let isCurrentWeek = calendar.isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
        
        return Text("\(calendar.component(.day, from: date))")
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(isToday ? Color.red : Color.clear)
            .foregroundColor(isToday ? .white : (isCurrentWeek ? .primary : .secondary))
            .font(isToday ? .title3.bold() : .title3)
            .clipShape(Circle())
            .opacity(isCurrentWeek ? 1 : 0.5)
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
                        .padding(.bottom, 2)  // Push the button up by 2 pixels
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

    private func daysInWeek() -> [Date?] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentDate) else { return [] }
        
        let firstDayOfWeek = weekInterval.start
        let totalDays = 7  // Always 7 days in a week
        
        return (0..<totalDays).map { day in
            calendar.date(byAdding: .day, value: day, to: firstDayOfWeek)
        }
    }

    private func previousWeek() {
        currentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
    }
    
    private func nextWeek() {
        currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
            .previewDevice("iPhone 15")
            .preferredColorScheme(.dark)
    }
}
//
//  Untitled.swift
//  Contextual Calendar
//
//  Created by Shahvir Sarkary on 2024-07-23.
//

