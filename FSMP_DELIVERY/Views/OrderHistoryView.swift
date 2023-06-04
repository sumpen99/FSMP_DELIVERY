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
    
    private var mockData:[String] = ["Order 1","Order 2"]
    
    private var categorieItem = [
        "Id-Anställd",
        "Id-Order",
        "Namn",
        "Adress",
        "Email",
        "Titel",
        "Mottagen",
        "Fritext",
        "Ingen",
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
            print("searching \(queryOrderVar.searchText)")
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
                    ForEach(categorieItem, id: \.self) { cat in
                        getCategorieCell(cat)
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
                if mockData.count != 0{
                    LazyVStack{
                        ForEach(mockData, id: \.self) { item in
                            Text("\(item)")
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
