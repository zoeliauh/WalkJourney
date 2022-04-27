//
//  DataHelper.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/20.
//

import Foundation

extension Date {
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
                
        return formatter
    }
    
    static func yearFormat() -> String {
        
        let today = Date()
        
        let yearFormatter = DateFormatter()
        
        yearFormatter.dateFormat = "yyyy"
        
        let year = yearFormatter.string(from: today)
        
        return year
    }
    
    static func monthFormat() -> String {
        
        let today = Date()
        
        let monthFormatter = DateFormatter()
        
        monthFormatter.dateFormat = "MM"
        
        let month = monthFormatter.string(from: today)
        
        return month
    }
    
    static func yearMonthFormat() -> String {
        
        let today = Date()
        
        let yearMonthFormatter = DateFormatter()
        
        yearMonthFormatter.dateFormat = "yyyy.MM"
        
        let yearMonth = yearMonthFormatter.string(from: today)
        
        return yearMonth
    }
    
    static func dateFormat() -> String {
        
        let today = Date()
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = "yyyy.MM.dd"
        
        let date = dateFormat.string(from: today)
        
        return date
    }
}
