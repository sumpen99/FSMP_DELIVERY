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
    var queryOption:QueryOptions = QueryOptions.QUERY_NONE
    var searchText:String = ""
    var usertDidSelectDates:Bool = false
    var searchIsDissmissed:Bool = false
    
    func getDateQuery() -> QueryOptions{
        if startDate == nil && endDate == nil { return .QUERY_ALL_DATES }
        if endDate == nil { return .QUERY_FROM_START_DATE }
        if startDate == nil { return .QUERY_TO_END_DATE }
        return .QUERY_DATES
    }
    
    mutating func setNewDates(_ startDate:Date,endDate:Date){
        self.startDate = startDate
        self.endDate = endDate
        usertDidSelectDates.toggle()
    }
    
    func getStartDateString() -> String{
        guard let startDate = startDate else { return "Inget datum valt"}
        return startDate.formattedString()
    }
    
    func getEndDateString() -> String{
        guard let endDate = endDate else { return "Inget datum valt" }
        return endDate.formattedString()
    }
    
    mutating func clearStartDate(){
        startDate = nil
    }
    
    mutating func clearEndDate(){
        endDate = nil
    }
}
