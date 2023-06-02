//
//  CustomCalendarView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-03.
//

import SwiftUI

var PAD_CALENDAR: Int = 0

struct CustomCalendarView: View {
    @State var selectedYear: Int = Date().year()
    @State var selectedMonth: String = Date().monthName()
    @State var selectedDay: Int = 0
    
    let months: [String] = Calendar.current.shortMonthSymbols
    let columns = [ GridItem(.adaptive(minimum: 80))]
    let days = Calendar.getSwedishShortWeekdayNames()
    
    let layout = [
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40))
        ]
    
    
    var body: some View {
        ScrollView{
            VStack {
                yearView
                monthView
                daysNameView
                daysView
                 
            }
        }
    }
    
    var yearView: some View{
        HStack {
            Button(action: {
                if selectedYear > FSMP_RELEASE_YEAR{
                    selectedYear -= 1
                    //var dateComponent = DateComponents()
                    //dateComponent.year = -1
                    //selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)
                }
            },label: {Text("\(Image(systemName: "chevron.left"))")})
            Text(String(selectedYear))
                     .fontWeight(.bold)
                     .transition(.move(edge: .trailing))
            Button(action: {
                selectedYear += 1
                //var dateComponent = DateComponents()
                //dateComponent.year = 1
                //selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)
                //print(selectedDate)
            },label: {Text("\(Image(systemName: "chevron.right"))")})
            Spacer()
        }
        .padding(15)
    }
    
    var monthView: some View{
        LazyVGrid(columns: columns, spacing: 20) {
           ForEach(months, id: \.self) { item in
               ZStack{
                   Text(item)
                   .font(.headline)
                   .frame(width: 60, height: 33)
                   .bold()
                   .background(.white)
                   .cornerRadius(8)
                   .overlay(
                       RoundedRectangle(cornerRadius: 8)
                        .stroke(item == selectedMonth ?  .green : Color.gray,lineWidth: 1)
                   )
                   .onTapGesture {
                       //var dateComponent = DateComponents()
                       //dateComponent.day = 1
                       //dateComponent.month =  months.firstIndex(of: item) ?? 0 + 1
                       //dateComponent.year = Int(selectedDate.year())
                       //print(item)
                       //selectedDate = Calendar.current.date(from: dateComponent)!
                       //print(selectedDate)
                       selectedMonth = item
                   }
                   ZStack{
                       Circle()
                           .fill(.red)
                           .frame(width: 20, height: 20,alignment: .trailing)
                       Text("1").font(.caption)
                   }
                   .padding([.trailing],5)
                   .padding([.bottom],-5)
                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
               }
           }
        }
        .padding(.horizontal)
    }
    
    var daysNameView: some View{
        LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
            ForEach(days, id: \.self) { item in
                Text("\(item)")
           }
        }
        .padding([.horizontal,.top])
    }
    
    var daysView: some View{
        LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
            ForEach(1...daysInCurrentMonth(
                monthNumber: (months.firstIndex(of: selectedMonth) ?? 0) + 1,
                year: selectedYear), id: \.self) { item in
                    getPositionOfDay(item)
                    .onTapGesture {
                        selectedDay = item
                    }
           }
        }
        .padding([.horizontal,.top])
    }
    
    func getPositionOfDay(_ day:Int) -> some View{
        let newDay = day - PAD_CALENDAR
        if newDay >= 1{
            return Text("\(newDay)")
                    .frame(width: 30, height: 30)
                    .overlay( Circle().stroke(day == selectedDay ? .green : .clear,lineWidth: 1) )
                    .disabled(false)
        }
        else{
            return Text("")
                    .frame(width: 30, height: 30)
                    .overlay( Circle().stroke(.clear,lineWidth: 1) )
                    .disabled(true)
        }
    }
    
    func daysInCurrentMonth(monthNumber: Int,year: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = monthNumber
        guard let date = Calendar.current.date(from: dateComponents),
              let interval = Calendar.current.dateInterval(of: .month, for: date),
              let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        else{ return 0 }
        
        PAD_CALENDAR = date.getFirstWeekdayInMonth() - 1
        
        return days + PAD_CALENDAR
    }
    
}
