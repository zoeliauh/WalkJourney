//
//  TimeManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import Foundation

class TimeManager {
    // MARK: - get days in month
    static let shared = TimeManager()
    
    func getDaysInMonth(month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        guard let startDate = calendar.date(from: startComps) else { return 1 }
        guard let endDate = calendar.date(from: endComps) else { return 28 }
        
        let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        
        return diff.day
    }
}
