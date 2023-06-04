//
//  QueryOrderVar.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-04.
//
import SwiftUI
struct QueryOrderVar{
    var startDate:Date?
    var endDate:Date?
    var queryOption:QueryOptions? = QueryOptions.QUERY_NONE
    var searchText:String = ""
    var selectedCategorie:String = ""
    var usertDidSelectDates:Bool = false
    
    mutating func setNewDates(_ startDate:Date,endDate:Date){
        self.startDate = startDate
        self.endDate = endDate
        usertDidSelectDates.toggle()
    }
}
