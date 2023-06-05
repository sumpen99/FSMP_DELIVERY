//
//  CustomCalendarView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-03.
//

import SwiftUI

var PAD_CALENDAR: Int = 0

struct Selected{
    var year: Int = Date().year()
    var month: String = Date().monthName()
    var day: Int = Date().day()
}

struct CustomCalendarView: View {
    @Namespace var animation
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var queryOrderVar:QueryOrderVar
    @State var selected:Selected = Selected()
    @State var userWillSaveDates: Bool = false
    let maxYear = Date().year()
    let months: [String] = Calendar.current.shortMonthSymbols
    let days = Calendar.getSwedishShortWeekdayNames()
    
    let columns = [ GridItem(.adaptive(minimum: 80))]

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
            ordersInfo
        }
        .actionSheet(isPresented: $userWillSaveDates) {
            getCorrectSaveActionSheet()
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
            .onChange(of: selected.year){ year in
                if year > maxYear{ return }
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
            queryOrdersSignedByYear()
        }
        .onDisappear{
            firestoreVM.closeListenerOrdersSignedQuery()
        }
    }
    
    var ordersInfo: some View{
        Form{
            Section(header: Text(getDateAsText())){
                if numberOfOrdersOnThisDay() != 0 {
                    ScrollView {
                        LazyVStack {
                            ForEach(ordersFromSelectedDay() ?? [],id:\.orderId){ order in
                                shortOrderInfo(order)
                            }
                        }
                    }
                }
                else{
                    Text("Ingen data att visa")
                    .foregroundColor(Color.placeholderText)
                }
            }
        }
        .scrollContentBackground(.hidden)
        //.frame( maxWidth: .infinity)
        //.edgesIgnoringSafeArea(.all)
        //.listStyle(GroupedListStyle())
        .frame(height:150.0)
    }
    
    func shortOrderInfo(_ order:Order) -> some View{
        VStack(spacing:10){
            getHeaderSubHeader("Kund: ", subHeader: order.customer.name)
            getHeaderSubHeader("Adress: ", subHeader: order.customer.adress)
            getHeaderSubHeader("Slutförd: ", subHeader: order.dateOfCompletion?.time() ?? "00:00:00")
            Divider()
        }
        .padding()
        //.foregroundColor(Color.placeholderText)
        //.hLeading()
    }
    
    // MARK: - YEAR VIEW
    var topButtonRow: some View{
        HStack {
            Button(action: {
                if selected.year > FSMP_RELEASE_YEAR{
                    selected.year -= 1
                }
            },label: {Text("\(Image(systemName: "chevron.left"))")})
            Text(String(selected.year))
                     .fontWeight(.bold)
                     .transition(.move(edge: .trailing))
            Button(action: {
                selected.year += 1
            },label: {Text("\(Image(systemName: "chevron.right"))")})
            Spacer()
            HStack(spacing:20){
                Button(action: {
                    closeView()
                },label: {Text("Avbryt")})
                Button(action: {
                    saveDate()
                },label: {Text("Hämta")})
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
                   if thisMonthHaveOrders(month){
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
                 if month == selected.month{
                     RoundedRectangle(cornerRadius: 8)
                      .stroke(.black)
                      .matchedGeometryEffect(id: "CURRENTMONTH", in: animation)
                 }
             }
        )
        .foregroundStyle(month == selected.month ? .primary : .tertiary)
        .onTapGesture {
            withAnimation{
                selected.month = month
            }
        }
    }
    
    func getBadgeMonth(_ month:String) -> some View{
        return ZStack{
            Circle()
                .fill(month == selected.month ? .black : Color.tertiarySystemFill)
                .frame(width: 10, height: 10,alignment: .trailing)
        }
        .foregroundStyle(month == selected.month ? .primary : .tertiary)
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
                    if let num = numberOfOrdersOnThisDay(day),num != 0{
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
                         if newDay == selected.day{
                             Circle()
                              .stroke(.black)
                              .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                         }
                     }
                )
                .onTapGesture {
                    withAnimation{
                        selected.day = day - PAD_CALENDAR
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
        .foregroundStyle(newDay == selected.day ? .primary : .tertiary)
        .padding([.trailing],-5)
        .padding([.bottom],-5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .opacity(showDay ? 1.0 : 0.0)
    }
    
    // MARK: - ACTIONSHEET
    func getCorrectSaveActionSheet() -> ActionSheet{
        if numberOfOrdersOnThisDay() != 0{
            return ActionSheet(title: Text("Välj tidsperiod"), message: Text("Ni kan välja att hämta data från år,månad eller dag."), buttons: [
                .default(Text("Hela året")) { setDateThisYear() },
                .default(Text(getCapitalizedMonth())) { setDateThisMonth() },
                .default(Text(getDateAsText())) { setDateThisDay() },
                .cancel()
            ])
        }
        else if thisMonthHaveOrders(selected.month){
            return ActionSheet(title: Text("Välj tidsperiod"), message: Text("Ni kan välja att hämta data från år eller månad."), buttons: [
                .default(Text("Hela året")) { setDateThisYear() },
                .default(Text(getCapitalizedMonth())) { setDateThisMonth() },
                .cancel()
            ])
        }
        else if thisYearHaveOrders(selected.year){
            return ActionSheet(title: Text("Välj tidsperiod"), message: Text("Det finns ingen data att hämta från \(selected.month) månad men ni kan välja hela året istället"), buttons: [
                .default(Text("Hämta hela året")) { setDateThisYear() },
                .cancel()
            ])
        }
        else {
            return ActionSheet(title: Text("Välj tidsperiod"), message: Text("Det finns ingen data att hämta från det här året"), buttons: [
                .default(Text("Ok")) {  },
            ])
        }
    }
    
    // MARK: - HELPER METHODS
    func daysInCurrentMonth() -> Int {
        let monthNumber = (months.firstIndex(of: selected.month) ?? 0) + 1
        var dateComponents = DateComponents()
        dateComponents.year = selected.year
        dateComponents.month = monthNumber
        guard let date = Calendar.current.date(from: dateComponents),
              let interval = Calendar.current.dateInterval(of: .month, for: date),
              let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        else{ return 0 }
        
        PAD_CALENDAR = date.getFirstWeekdayInMonth() - 1
        return days + PAD_CALENDAR
    }
    
    func saveDate(){
        userWillSaveDates.toggle()
        //queryOrdersSignedByYear()
        //queryOrdersSignedByMonth()
        //queryOrdersSignedByDay()
    }
    
    func closeView(){
        dismiss()
    }
    
    func queryOrdersSignedByYear(){
        guard let startDate = Date.from(selected.year, 1, 1),
              let endDate = Date.from(selected.year+1,1,1) else { return }
        firestoreVM.closeListenerOrdersSignedQuery()
        firestoreVM.releaseOrderSignedQueryData()
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func queryOrdersSignedByMonth(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selected.year, month, 1),
              let endDate = Date.from(selected.year,month+1,1) else { return }
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func queryOrdersSignedByDay(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selected.year, month, selected.day),
              let endDate = Date.from(selected.year,month,selected.day+1) else { return }
        firestoreVM.queryOrdersSignedByDateRange(startDate: startDate, endDate: endDate)
    }
    
    func setDateThisYear(){
        guard let startDate = Date.from(selected.year, 1, 1),
              let endDate = Date.from(selected.year+1,1,1) else { return }
        queryOrderVar.setNewDates(startDate, endDate: endDate)
    }
    
    func setDateThisMonth(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selected.year, month, 1),
              let endDate = Date.from(selected.year,month+1,1) else { return }
        queryOrderVar.setNewDates(startDate, endDate: endDate)
    }
    
    func setDateThisDay(){
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selected.year, month, selected.day),
              let endDate = Date.from(selected.year,month,selected.day+1) else { return }
        queryOrderVar.setNewDates(startDate, endDate: endDate)
        
    }
    
    func getCapitalizedMonth() -> String{
        return selected.month.capitalizingFirstLetter()
    }
    
    func getSelectedMonthIndex() -> Int{
        guard let selectedMonthIndex = months.firstIndex(of: selected.month) else { return -1 }
        return  selectedMonthIndex + 1
    }
    
    func getSelectedMonthIndex(_ month:String) -> Int{
        guard let selectedMonthIndex = months.firstIndex(of: month) else { return -1 }
        return  selectedMonthIndex + 1
    }
    
    func thisYearHaveOrders(_ year:Int) -> Bool{
        return firestoreVM.ordersSignedYearHaveData(year)
    }
    
    func thisMonthHaveOrders(_ month:String) -> Bool{
        return firestoreVM.ordersSignedMonthHaveData(getSelectedMonthIndex(month), year: selected.year)
    }
    
    func numberOfOrdersOnThisDay(_ day:Int) -> Int? {
        return firestoreVM.ordersSignedDayHaveData(day-PAD_CALENDAR,
                                                     month:getSelectedMonthIndex(),
                                                     year: selected.year)
    }
    
    func numberOfOrdersOnThisDay() -> Int {
        return firestoreVM.ordersSignedDayHaveData(selected.day,
                                                     month:getSelectedMonthIndex(),
                                                     year: selected.year)
    }
    
    func ordersFromSelectedDay() -> [Order]? {
        return firestoreVM.ordersFromThisDay(selected.day,
                                             month:getSelectedMonthIndex(),
                                             year: selected.year)
    }
    
    func getDateAsText() -> String{
        let month = getSelectedMonthIndex()
        guard let startDate = Date.from(selected.year, month, selected.day) else {
            return "\(selected.day)" + " " + "\(selected.month)" + " " + "\(selected.year)"
        }
        let weekday = startDate.dayName()
        return "\(weekday)" + " " + "\(selected.day)" + " " + "\(selected.month)" + " " + "\(selected.year)"
    }
}
