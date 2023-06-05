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
    @Environment(\.dismiss) private var dismiss
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
                clearAndResetButton
                ordersFound
            }
            .alert(isPresented: $queryOrderVar.searchIsDissmissed, content: { onResultAlert() })
        }
        .navigationBarBackButtonHidden(true)
        .searchable(text: $queryOrderVar.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            executeNewSearchQuery()
        }
        .sheet(isPresented: $showingCalendar){
            CustomCalendarView(queryOrderVar:$queryOrderVar)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: closeAndRelaseData ) {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {showingCalendar.toggle()}) {
                    Image(systemName: "calendar")
                }
            }
        }
        .onChange(of: queryOrderVar.usertDidSelectDates){ value in
            showingCalendar.toggle()
            executeNewSearchQuery()
        }
    }
    
    var clearAndResetButton: some View{
        HStack{
            //Text("Återställ").foregroundColor(Color.systemGray)
            Spacer()
            Button(action: { print("återställ") }, label: {
                Text("Rensa").foregroundColor(Color.systemBlue)
            })
        }
        .modifier(CardModifier(size: 50.0 ))
        .opacity(firestoreVM.ordersSigned.count <= 0 ? 0.0 : 1.0)
        .disabled(firestoreVM.ordersSigned.count <= 0)
        .padding([.leading,.trailing])
    }
    
    var searchRange: some View {
        VStack(spacing:10.0){
            Color.white
            ToggleBox(toogleIsOn: $dateRangeIsShowing, label: "Tidsintervall")
            if dateRangeIsShowing {
                VStack(spacing:20){
                    getHeaderSubHeaderWithClearOption("Start datum: ",
                                                      subHeader: queryOrderVar.getStartDateString()){
                        queryOrderVar.clearStartDate()
                    }
                    getHeaderSubHeaderWithClearOption("Slut datum: ",
                                                      subHeader: queryOrderVar.getEndDateString()){
                        queryOrderVar.clearEndDate()
                    }
                }
            }
        }
        .hLeading()
        .padding([.leading])
        .modifier(CardModifier(size: getDateRangeSize() ))
   }
    
    
    var categories: some View{
        VStack(spacing:10.0){
            Color.white
            ToggleBox(toogleIsOn: $categoriesIsShowing, label: "Kategorier")
            if categoriesIsShowing {
                LazyVGrid(columns: layout, spacing: 20.0,pinnedViews: [.sectionHeaders]) {
                    ForEach(queryItem, id: \.self) { query in
                        getCategorieCell(query)
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
                if firestoreVM.ordersSigned.count > 0{
                    LazyVStack{
                        getSearchTitleResult()
                        ForEach(firestoreVM.ordersSigned, id: \.orderId) { order in
                            MediumOrderView(order:order)
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
    
    func getCategorieCell(_ query:QueryOptions) -> some View{
        return Text(query.rawValue)
            .frame(height: 33)
            .padding([.leading,.trailing],5.0)
            .background(.white)
            .cornerRadius(8)
            .background(
                 ZStack{
                     if query == queryOrderVar.queryOption{
                         RoundedRectangle(cornerRadius: 8)
                         .stroke(.black)
                         .matchedGeometryEffect(id: "SELECTEDCATEGORIE", in: animationOrder)
                     }
                     
                 }
            )
            .foregroundStyle(query == queryOrderVar.queryOption ? .primary : .tertiary)
            .onTapGesture {
                withAnimation{
                    queryOrderVar.queryOption = query
                }
            }
    }
    
    func getSearchTitleResult() -> some View{
        return VStack{
            Text("Sökresultat").font(.title).bold()
            Divider()
        }
        .foregroundColor(Color.systemGray)
        .hCenter()
    }
    
    func getDateRangeSize()->CGFloat{
        return dateRangeIsShowing ? 120.0 : 50.0
    }
    
    func getCategoriesSize()->CGFloat{
        return categoriesIsShowing ? 200.0 : 50.0
    }
    
    func closeAndRelaseData(){
        firestoreVM.closeAndReleaseOrderSignedData()
        dismiss()
    }
    
    func executeNewSearchQuery(){
        let dateQuery = queryOrderVar.getDateQuery()
        if dateQuery == .QUERY_ALL_DATES && queryOrderVar.queryOption == .QUERY_NONE{
            setQueryAlertMessage(title: "Sökning avbruten",
                                 message: "Välj kategori eller en tidsintervall")
            return
        }
        let queryOptions = [dateQuery,queryOrderVar.queryOption,.QUERY_SORT_BY_DATE_COMPLETION]
        firestoreVM.closeAndReleaseQueryData()
        firestoreVM.listenToOrdersSignedWithOptions(
            queryOptions: queryOptions,
            queryOrderVar: queryOrderVar)
    }
    
    private func setQueryAlertMessage(title:String,message:String){
        ALERT_TITLE = title
        ALERT_MESSAGE = message
        queryOrderVar.searchIsDissmissed.toggle()
    }
}

struct MediumOrderView:View{
    let order:Order
    @State var showMoreInfo:Bool = false
    
    var body: some View{
        VStack(spacing:10.0){
            Color.white
            ToggleBox(toogleIsOn: $showMoreInfo, label: order.orderId)
            if showMoreInfo {
                NavigationLink(destination:LazyDestination(destination: { FullOrderView(order:order) })) {
                    ZStack(alignment:.center){
                        Color.white
                        rightAlignChevronIcon(label: "chevron.right")
                        VStack{
                            getVertHeaderMessage("Kund",message: order.customer.name)
                            getVertHeaderMessage("Adress",message: order.customer.adress)
                            getVertHeaderMessage("Order registrerades",message: order.getInitDateWithTime())
                            getVertHeaderMessage("Order slutfördes",message: order.getcompletionDateWithTime())
                            getVertHeaderMessage("Order utfördes av",message: order.assignedUser ?? "Okänd")
                        }
                        .hLeading()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.systemGray,lineWidth: 1)
                    )
                    .padding([.trailing,.bottom])
                }
                
            }
        }
        .hLeading()
        .padding(.leading)
        .modifier(CardModifier(size: getCardSize() ))
    }
    
    func rightAlignChevronIcon(label:String) -> some View{
        return Image(systemName: label)
            .foregroundColor(Color.systemBlue)
            .hTrailing()
            .padding(.trailing)
    }
    
    func getCardSize() -> CGFloat{
        return showMoreInfo ? 350.0 : 50.0
    }
}

struct FullOrderView: View{
    @Namespace var animationFullOrder
    let order:Order
    @State var showMoreInfoAboutOrder:Bool = false
    @State var showMoreInfoAboutCustomer:Bool = false
    @State var showMoreInfoAboutEmployee:Bool = false
    
    func getSectionText(label:String,text:String) -> some View{
        return getHeaderSubHeader(label, subHeader: text)
    }
    
    var getSectionCustomer: some View{
        ZStack{
            Color.white
            VStack(spacing:10.0){
                ToggleBox(toogleIsOn: $showMoreInfoAboutCustomer, label: "Kund-Info")
                if showMoreInfoAboutCustomer {
                    LazyVStack{
                        getVertHeaderMessage("Namn", message: order.customer.name)
                        getVertHeaderMessage("Adress", message: order.customer.adress)
                        getVertHeaderMessage("Poskod", message: order.customer.postcode)
                        getVertHeaderMessage("Email", message: order.customer.email)
                        getVertHeaderMessage("Telefonnummer", message: "\(order.customer.phoneNumber)")
                        getVertHeaderMessage("Information", message: order.customer.description)
                        
                    }
                    .hLeading()
                    .matchedGeometryEffect(id: "SELECTEDSECTIONCUSTOMER", in: animationFullOrder)
                }
                Divider()
            }
        }
        .hLeading()
        .padding(.leading)
        .modifier(CardModifier(size: getSectionCustomerSize() ))
    }
    
    var getSectionOrder: some View{
        ZStack{
            Color.white
            VStack(spacing:10.0){
                ToggleBox(toogleIsOn: $showMoreInfoAboutOrder, label: "Order-Info")
                if showMoreInfoAboutOrder {
                    LazyVStack{
                        getVertHeaderMessage("Titel", message: order.ordername)
                        getVertHeaderMessage("Info", message: order.details)
                        getVertHeaderMessage("Id", message: order.orderId)
                        getVertHeaderMessage("Registrerades", message: order.initDate.formattedStringWithTime())
                        getVertHeaderMessage("Slutfördes", message: order.dateOfCompletion?.formattedStringWithTime() ?? "")
                    }
                    .hLeading()
                    .matchedGeometryEffect(id: "SELECTEDSECTIONORDER", in: animationFullOrder)
                }
                Divider()
            }
        }
        .hLeading()
        .padding(.leading)
        .modifier(CardModifier(size: getSectionOrderSize() ))
    }
    
    var getSectionEmployee: some View{
        ZStack{
            Color.white
            VStack(spacing:10.0){
                ToggleBox(toogleIsOn: $showMoreInfoAboutEmployee, label: "Anställd-Info")
                if showMoreInfoAboutEmployee {
                    LazyVStack{
                        getVertHeaderMessage("Id", message: order.assignedUser ?? "")
                    }
                    .hLeading()
                    .matchedGeometryEffect(id: "SELECTEDSECTIONEMPLOYEE", in: animationFullOrder)
                }
                Divider()
            }
        }
        .hLeading()
        .padding(.leading)
        .modifier(CardModifier(size: getSectionEmployeeSize() ))
    }
    
    var body: some View{
        VStack {
            ScrollView{
                LazyVStack {
                    getSectionOrder
                    getSectionCustomer
                    getSectionEmployee
                }
            }
        }
        .modifier(NavigationViewModifier(title: order.orderId))
    }
    
    func getSectionOrderSize() ->CGFloat{
        return showMoreInfoAboutOrder ? 400 : 50
    }
    
    func getSectionCustomerSize() ->CGFloat{
        return showMoreInfoAboutCustomer ? 400 : 50
    }
    
    func getSectionEmployeeSize() ->CGFloat{
        return showMoreInfoAboutEmployee ? 90 : 50
    }
}

struct NavigationViewModifier: ViewModifier {
    let title:String
    func body(content: Content) -> some View {
        content
        .scrollContentBackground(.hidden)
        .background( .white)
        .navigationBarTitle(Text(title),displayMode: .inline)
    }
}
