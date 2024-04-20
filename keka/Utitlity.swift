//
// Utitlity.swift
// Cityflo
//
// Created by Anshul Gupta on 20/04/24.
// Copyright © Cityflo. All rights reserved.
//


import Foundation

class DateConverter {
    static func convertDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            let monthYearFormatter = DateFormatter()
            monthYearFormatter.dateFormat = "MMMM yyyy"
            return monthYearFormatter.string(from: date)
        } else {
            return "Invalid date format"
        }
    }
    
    static func convertDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
}
