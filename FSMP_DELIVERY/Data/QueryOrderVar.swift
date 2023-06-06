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
    var parsedDateOfCreation:Date?
    var parsedPhoneNumber:Int = 0
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
    
    mutating func tryBuildSearchTextAsDate() -> Bool{
        // wildcard("3/5-2023, pattern: "*/*-*"")
        // wildcard("3/5-2023, pattern: "?/?-????"")
        if let _ = searchText.range(of: #"^\d{1}/\d{1}-\d{4}$"#, options: .regularExpression),
           let searchDate = Date.fromInputString(searchText) {
            parsedDateOfCreation = searchDate
            return true
        }
        else if let _ = searchText.range(of: #"^\d{1}/\d{2}-\d{4}$"#, options: .regularExpression),
                let searchDate = Date.fromInputString(searchText) {
                parsedDateOfCreation = searchDate
                return true
        }
        else if let _ = searchText.range(of: #"^\d{2}/\d{1}-\d{4}$"#, options: .regularExpression),
                let searchDate = Date.fromInputString(searchText) {
                parsedDateOfCreation = searchDate
                return true
        }
        else if let _ = searchText.range(of: #"^\d{2}/\d{2}-\d{4}$"#, options: .regularExpression),
                let searchDate = Date.fromInputString(searchText) {
                parsedDateOfCreation = searchDate
                return true
        }
        return false
    }
    
    func wildcard(_ string: String, pattern: String) -> Bool {
        let pred = NSPredicate(format: "self LIKE %@", pattern)
        return !NSArray(object: string).filtered(using: pred).isEmpty
    }
    
    mutating func tryBuildSearchTextAsPhoneNumber() -> Bool{
        guard let parsedNumber = Int(searchText) else { return false }
        parsedPhoneNumber = parsedNumber
        return true
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
    
    mutating func removeWhiteSpace(){
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func clearStartDate(){
        startDate = nil
    }
    
    mutating func clearEndDate(){
        endDate = nil
    }
}
