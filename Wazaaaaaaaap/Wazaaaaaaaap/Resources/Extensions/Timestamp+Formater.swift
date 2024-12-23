//
//  Timestamp+Formater.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 23.12.24.
//
import Firebase
import Foundation

extension Timestamp {
#warning("gpt used here")
    func formattedTimestamp() -> String {
        let messageDate = self.dateValue()
        let currentDate = Date()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(messageDate) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            return timeFormatter.string(from: messageDate)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: messageDate)
        }
    }
}
