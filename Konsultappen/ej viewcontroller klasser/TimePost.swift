//
//  Resa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-27.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
struct TimePost {
    
    var startTime : Date
    var endTime: Date
    var calendar : Calendar
    var namn : String?
    var duration : Int!
    
    private let dateFormatter = DateFormatter()
    var formStartTime : String?
    var formEndTime : String?
    var count : Int = -1
    var justDate : String?
     
    init (startTime: Date, endTime: Date, calendar: Calendar, namn: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.calendar = calendar
        self.namn = namn
        self.duration = calendar.dateComponents([.second], from: startTime, to: endTime).second
        dateFormatter.dateFormat = "HH:mm:ss"
        self.formStartTime = dateFormatter.string(from: startTime)
         //dateFormatter.dateFormat = "HH:mm:ss"
        self.formEndTime = dateFormatter.string(from: endTime)
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.justDate = dateFormatter.string(from: startTime)
        self.count += 1
    }

}

