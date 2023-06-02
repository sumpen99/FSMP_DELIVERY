//
//  OrderHistoryView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-02.
//

import SwiftUI

struct OrderHistoryView: View{
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @State var adress:String = ""
    @State var selectedDate:Date = Date()
    
    
    var body: some View{
        NavigationStack{
            YearMonthPickerView()
        }
    }
    
    var fillSectionWithData: some View{
        return ScrollView(.vertical,showsIndicators: false){
            LazyVStack(alignment: .leading,spacing: 10.0){
                ForEach((1...20).reversed(), id: \.self) {
                        Text("\($0)…")
                }
            }
            .padding()
        }
    }
}

struct YearMonthPickerView: View {
    @State var selectedYear: Int = Date().year()
    @State var selectedMonth: String = Date().monthName()
    @State var selectedDay: Int = 0
    
    let months: [String] = Calendar.current.shortMonthSymbols
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
                   .background(item == selectedMonth ?  .green : .white)
                   .cornerRadius(8)
                   .overlay(
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.gray,lineWidth: 1)
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
    
    var daysView: some View{
        LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
            ForEach(1...daysInCurrentMonth(
                monthNumber: (months.firstIndex(of: selectedMonth) ?? 0) + 1,
                year: selectedYear), id: \.self) { item in
                    Text("\(item)")
           }
        }
        .padding([.horizontal,.top])
    }
    
    var body: some View {
        VStack {
            yearView
            monthView
            daysView
            
        }
    }
}

/*struct HeaderSubHeaderView: View{
    let header:String
    let subHeader:String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header).sectionHeader()
            Text(subHeader).fontWeight(.regular)
        }
    }
}*/
