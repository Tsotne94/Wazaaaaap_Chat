//
//  Timestamp+Formater.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import Firebase
import Foundation

#warning("gpt used here")
extension Date {
    func formattedTimestamp() -> String {
        let currentDate = Date()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            return timeFormatter.string(from: self)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: self)
        }
    }
}

