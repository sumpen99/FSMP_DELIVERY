//
//  CustomCalendarView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-03.
//

import SwiftUI

var PAD_CALENDAR: Int = 0

struct CustomCalendarView: View {
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @Environment(\.dismiss) private var dismiss
    let maxYear = Date().year()
    @State var selectedYear: Int = Date().year()
    @State var selectedMonth: String = Date().monthName()
    @State var selectedDay: Int = Date().day()
    @Namespace var animation
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
        VStack(spacing:20){
            calendar
            Divider()
            ordersLightVersion
        }
    }
    
    var calendar: some View{
        ScrollView{
            LazyVStack {
                topButtonRow
                monthGridView
                weekdaysName
                daysGridView
                
                 
            }
            .onChange(of: selectedYear){ year in
                if year > maxYear{ print("nej nej nej ");return}
                queryOrdersSignedByYear()
            }
            /*.onChange(of: selectedMonth){ month in
                if selectedYear > maxYear{ print("nej nej nej ");return}
                queryOrdersSignedByMonth()
            }
            .onChange(of: selectedDay){ day in
                if selectedYear > maxYear{ print("nej nej nej ");return}
                queryOrdersSignedByDay()
            }*/
        }
        .onAppear{
            //queryOrdersSignedByYear()
        }
        .onDisappear{
            firestoreVM.closeListenerOrdersSignedQuery()
        }
    }
    
    var ordersLightVersion: some View{
        ScrollView {
            LazyVStack {
                ForEach(100...120,id:\.self){ value in
                    Text("\(value)").frame( maxWidth: .infinity)
                }
            }
        }
        //.frame( maxWidth: .infinity)
        //.edgesIgnoringSafeArea(.all)
        //.listStyle(GroupedListStyle())
        .frame(height:150.0)
    }
    
    // MARK: - YEAR VIEW
    var topButtonRow: some View{
        HStack {
            Button(action: {
                if selectedYear > FSMP_RELEASE_YEAR{
                    selectedYear -= 1
                }
            },label: {Text("\(Image(systemName: "chevron.left"))")})
            Text(String(selectedYear))
                     .fontWeight(.bold)
                     .transition(.move(edge: .trailing))
            Button(action: {
                selectedYear += 1
            },label: {Text("\(Image(systemName: "chevron.right"))")})
            Spacer()
            HStack(spacing:20){
                Button(action: {
                    closeView()
                },label: {Text("Avbryt")})
                Button(action: {
                    saveDate()
                },label: {Text("Spara")})
            }
        }
        .padding(15)
    }
    
    // MARK: - MONTH GRIDVIEW
    var monthGridView: some View{
        LazyVGrid(columns: columns, spacing: 20) {
           ForEach(months, id: \.self) { month in
               ZStack{
                   getMonthCell(month)
                   if firestoreVM.ordersSignedMonthHaveData(getSelectedMonthIndex(month), year: selectedYear){
                       getBadgeMonth(month)
                   }
                  
               }
           }
        }
        .padding(.horizontal)
    }
    
    func getMonthCell(_ month:String) -> some View{
        return Text(month)
        .font(.headline)
        .frame(width: 60, height: 33)
        .bold()
        .background(.white)
        .cornerRadius(8)
        .background(
             ZStack{
                 if month == selectedMonth{
                     RoundedRectangle(cornerRadius: 8)
                      .stroke(.green)
                      .matchedGeometryEffect(id: "CURRENTMONTH", in: animation)
                 }
             }
        )
        .foregroundStyle(month == selectedMonth ? .primary : .tertiary)
        .onTapGesture {
            withAnimation{
                selectedMonth = month
            }
        }
    }
    
    func getBadgeMonth(_ month:String) -> some View{
        return ZStack{
            Circle()
                .fill(month == selectedMonth ? .black : Color.tertiarySystemFill)
                .frame(width: 10, height: 10,alignment: .trailing)
        }
        .foregroundStyle(month == selectedMonth ? .primary : .tertiary)
        .padding([.trailing],10)
        //.padding([.bottom],5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    
    // MARK: - DAYS NAME VIEW
    var weekdaysName: some View{
        LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
            ForEach(days, id: \.self) { item in
                Text("\(item)")
           }
        }
        .padding([.horizontal,.top])
    }
    
    // MARK: - DAYS GRIDVIEW
    var daysGridView: some View{
        LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
            ForEach(1...daysInCurrentMonth(), id: \.self) { day in
                ZStack{
                    getDayCell(day)
                    if let num = firestoreVM.ordersSignedDayHaveData(day-PAD_CALENDAR,
                                                                 month:getSelectedMonthIndex(),
                                                                 year: selectedYear)
                        ,num != 0{
                        getBadgeDay(day,num:num)
                    }
                }
           }
        }
        .padding([.horizontal,.top])
    }
    
    func getDayCell(_ day:Int) -> some View{
        let newDay = day - PAD_CALENDAR
        let showDay = newDay >= 1
        return Text(showDay ? "\(newDay)" : "")
                .frame(width: 30, height: 30)
                .background(
                     ZStack{
                         if newDay == selectedDay{
                             Circle()
                              .stroke(.green)
                              .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                         }
                     }
                )
                .onTapGesture {
                    withAnimation{
                        selectedDay = day - PAD_CALENDAR
                    }
                }
    }
    
    func getBadgeDay(_ day:Int,num:Int) -> some View{
        let newDay = day - PAD_CALENDAR
        let showDay = newDay >= 1
        return ZStack{
            Circle()
                .fill(.red)
                .frame(width: 20, height: 20,alignment: .trailing)
            Text("\(num)").font(.caption)
        }
        .foregroundStyle(newDay == selectedDay ? .primary : .tertiary)
        .padding([.trailing],-5)
        .padding([.bottom],-5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .opacity(showDay ? 1.0 : 0.0)
    }
    
    
    // MARK: - HELPER METHODS
    func daysInCurrentMonth() -> Int {
        let monthNumber = (months.firstIndex(of: selectedMonth) ?? 0) + 1
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = monthNumber
        guard let date = Calendar.current.date(from: dateComponents),
              let interval = Calendar.current.dateInterval(of: .month, for: date),
              let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        else{ return 0 }
        
        PAD_CALENDAR = date.getFirstWeekdayInMonth() - 1
        return days + PAD_CALENDAR
    }
    
    func saveDate(){
        //queryOrdersSignedByYear()
        //queryOrdersSignedByMonth()
        //queryOrdersSignedByDay()
    }
    
    func closeView(){
        dismiss()
    }
    
    func queryOrdersSignedByYear(){
        guard let startDate = Date.from(selectedYear, 1, 1),let endDate = Date.from(selectedYear+1,1,1) else { return }
        firestoreVM.closeListenerOrdersSignedQuery()
        firestoreVM.releaseOrderSignedQueryData()
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func queryOrdersSignedByMonth(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selectedYear, month, 1),
              let endDate = Date.from(selectedYear,month+1,1) else { return }
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func queryOrdersSignedByDay(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selectedYear, month, selectedDay),
              let endDate = Date.from(selectedYear,month,selectedDay+1) else { return }
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func getSelectedMonthIndex() -> Int{
        guard let selectedMonthIndex = months.firstIndex(of: selectedMonth) else { return -1 }
        return  selectedMonthIndex + 1
    }
    
    func getSelectedMonthIndex(_ month:String) -> Int{
        guard let selectedMonthIndex = months.firstIndex(of: month) else { return -1 }
        return  selectedMonthIndex + 1
    }
    
}
