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
    @State var showingCalendar:Bool = false
    
    
    var body: some View{
        NavigationStack {
            Section{
                TextField("Adress", text: $adress).padding()
            }
        }
        .sheet(isPresented: $showingCalendar){
            CustomCalendarView()
        }
        .toolbar {
            ToolbarItemGroup{
                Button(action: {showingCalendar.toggle()}) {
                    Label("", systemImage: "calendar")
                }
            }
        }
        .onAppear{
            //firestoreVM.initializeListenerOrdersSigned()
        }
        .onDisappear{
            //firestoreVM.closeListenerOrdersSigned()
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
