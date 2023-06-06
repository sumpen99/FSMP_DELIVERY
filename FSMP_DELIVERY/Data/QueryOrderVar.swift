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
        if userHaveNotSelectedDates() { return .QUERY_ALL_DATES }
        if endDate == nil { return .QUERY_FROM_START_DATE }
        if startDate == nil { return .QUERY_TO_END_DATE }
        return .QUERY_DATES
    }
    
    mutating func setNewDates(_ startDate:Date,endDate:Date){
        self.startDate = startDate
        self.endDate = endDate
        usertDidSelectDates.toggle()
    }
    
    func tryBuildSearchTextAsDate() -> Bool{
        // accepted 3/5-2023
        // accepted 3 maj 2023
        return false
    }
    
    func wildcard(_ string: String, pattern: String) -> Bool {
        let pred = NSPredicate(format: "self LIKE %@", pattern)
        return !NSArray(object: string).filtered(using: pred).isEmpty
    }
    
    func tryBuildSearchTextAsPhoneNumber() -> Bool{
        // accepted int
        return false
    }
    
    func getStartDateString() -> String{
        guard let startDate = startDate else { return "Inget datum valt"}
        return startDate.formattedString()
    }
    
    func getEndDateString() -> String{
        guard let endDate = endDate else { return "Inget datum valt" }
        return endDate.formattedString()
    }
    
    func userHaveNotSelectedDates() -> Bool{
        return startDate == nil && endDate == nil
    }
    
    func userHaveSelectedDates() -> Bool{
        return startDate != nil || endDate != nil
    }
    
    mutating func clearStartDate(){
        startDate = nil
    }
    
    mutating func clearEndDate(){
        endDate = nil
    }
}
