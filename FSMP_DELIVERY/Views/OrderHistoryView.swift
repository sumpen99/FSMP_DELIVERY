//
//  OrderHistoryView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-02.
//

import SwiftUI

struct ToggleBox: View{
    @Binding var toogleIsOn:Bool
    let label:String
    var body: some View{
        HStack{
            Text(label).foregroundColor(Color.systemGray)
            Spacer()
            Toggle("", isOn: $toogleIsOn.animation())
                .foregroundColor(Color.systemBlue)
                .toggleStyle(ButtonToogleStyle(
                    isShowingText: Text("\(Image(systemName: "chevron.up"))"),
                    isClosedtext: Text("\(Image(systemName: "chevron.down"))")))
                .frame(alignment: .leading)
        }
        .padding(.trailing)
    }
}

struct OrderHistoryView: View{
    @EnvironmentObject var firestoreVM: FirestoreViewModel
    @Environment(\.isSearching)
    private var isSearching: Bool
    @Environment(\.dismissSearch)
    private var dismissSearch
    @State var showingCalendar:Bool = false
    @State var queryOrderVar = QueryOrderVar()
    @State var dateRangeIsShowing:Bool = false
    @State var categoriesIsShowing:Bool = false
    @Namespace var animationOrder
    
    
    let layout = [
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
            GridItem(.flexible(minimum: 40)),
        ]
   
    private var queryItem:[QueryOptions] = [
        QueryOptions.QUERY_ID_EMPLOYEE,
        QueryOptions.QUERY_ID_ORDER,
        QueryOptions.QUERY_CUSTOMER_NAME,
        QueryOptions.QUERY_CUSTOMER_ADRESS,
        QueryOptions.QUERY_CUSTOMER_EMAIL,
        QueryOptions.QUERY_CUSTOMER_PHONENUMBER,
        QueryOptions.QUERY_ORDER_TITLE,
        QueryOptions.QUERY_ORDER_CREATED,
        QueryOptions.QUERY_NONE,
    ]
    
    var body: some View{
        NavigationView {
            VStack{
                searchRange
                categories
                ordersFound
            }
        }
        .searchable(text: $queryOrderVar.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: queryOrderVar.searchText) { value in
            if queryOrderVar.searchText.isEmpty && !isSearching {
                //Search cancelled here
            }
        }
        .onSubmit(of: .search) {
            print("searching \(queryOrderVar.searchText) \(queryOrderVar.queryOption)")
        }
        .sheet(isPresented: $showingCalendar){
            CustomCalendarView(queryOrderVar:$queryOrderVar)
        }
        .toolbar {
            ToolbarItemGroup{
                Button(action: {showingCalendar.toggle()}) {
                    Label("", systemImage: "calendar")
                }
            }
        }
        .onChange(of: queryOrderVar.usertDidSelectDates){ value in
            showingCalendar.toggle()
            firestoreVM.closeAndReleaseQueryData()
            firestoreVM.listenToOrdersSignedWithOptions(
                queryOptions: [.QUERY_DATE],
                queryOrderVar: queryOrderVar)
        }
        .onAppear{
            //firestoreVM.initializeListenerOrdersSigned()
        }
        .onDisappear{
            //firestoreVM.closeListenerOrdersSigned()
        }
    }
    
    var searchRange: some View {
        VStack(spacing:10.0){
            Color.white
            ToggleBox(toogleIsOn: $dateRangeIsShowing, label: "Tidsintervall")
            if dateRangeIsShowing {
                VStack(spacing:10){
                    getHeaderSubHeader("Start datum: ", subHeader: "230602")
                    getHeaderSubHeader("Slut datum: ", subHeader: "230602")
                }
            }
        }
        .hLeading()
        .padding(.leading)
        .modifier(CardModifier(size: getDateRangeSize() ))
   }
    
    
    var categories: some View{
        VStack(spacing:10.0){
            Color.white
            ToggleBox(toogleIsOn: $categoriesIsShowing, label: "Kategorier")
            if categoriesIsShowing {
                LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
                    ForEach(queryItem, id: \.self) { query in
                        getCategorieCell(query.rawValue)
                   }
                }
                .padding([.horizontal,.top])
            }
        }
        .hLeading()
        .padding([.top,.bottom,.leading])
        .modifier(CardModifier(size: getCategoriesSize() ))
    }
 
    
    var ordersFound:some View{
        ZStack{
            ScrollView{
                if firestoreVM.ordersSigned.count != 0{
                    LazyVStack{
                        ForEach(firestoreVM.ordersSigned, id: \.orderId) { order in
                            Text("\(order.orderId)").hLeading()
                        }
                        
                    }
                }
                else{
                    Text("Ingen data att visa")
                    .foregroundColor(Color.placeholderText)
                }
            }
        }
        .matchedGeometryEffect(id: "ORDERSFOUND", in: animationOrder)
    }
    
    func getCategorieCell(_ categorie:String) -> some View{
        return Text(categorie)
            .frame(height: 33)
            .padding([.leading,.trailing],5.0)
            .background(.white)
            .cornerRadius(8)
            .background(
                 ZStack{
                     if categorie == queryOrderVar.selectedCategorie{
                         RoundedRectangle(cornerRadius: 8)
                         .stroke(.black)
                         .matchedGeometryEffect(id: "SELECTEDCATEGORIE", in: animationOrder)
                     }
                     
                 }
            )
            .foregroundStyle(categorie == queryOrderVar.selectedCategorie ? .primary : .tertiary)
            .onTapGesture {
                withAnimation{
                    queryOrderVar.queryOption = QueryOptions(rawValue: categorie)
                    queryOrderVar.selectedCategorie = categorie
                }
            }
    }
    
    func getDateRangeSize()->CGFloat{
        return dateRangeIsShowing ? 90.0 : 50.0
    }
    
    func getCategoriesSize()->CGFloat{
        return categoriesIsShowing ? 200.0 : 50.0
    }
}
