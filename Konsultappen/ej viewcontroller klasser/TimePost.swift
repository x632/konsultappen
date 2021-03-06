//
//  Resa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-27.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TimePost {
    
    var startTime : Date
    var endTime: Date
    var calendar = Calendar.current
    var namn : String?
    var duration : Int!
    var milersattning : Double?
    private let dateFormatter = DateFormatter()
    var formStartTime : String?
    var formEndTime : String?
    var justDate : String?
    
    
    init (startTime: Date, endTime: Date, namn: String, milersattning: Double) {
        self.startTime = startTime
        self.endTime = endTime
        self.namn = namn
        let calendar = Calendar.current
        self.duration = calendar.dateComponents([.minute], from: startTime, to: endTime).minute
        self.milersattning = milersattning
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        
        
        let snapshotValue = snapshot.data() as [String : Any]
        
        let tS = snapshotValue["startTime"] as! Timestamp
        self.startTime = tS.dateValue()
        let aS = snapshotValue["endTime"] as! Timestamp
        self.endTime = aS.dateValue()
        self.namn = snapshotValue["namn"] as! String
        self.milersattning = snapshotValue["milersattning"] as! Double
        self.duration = snapshotValue["duration"] as? Int
        dateFormatter.dateFormat = "HH:mm:ss"
        self.formStartTime = dateFormatter.string(from: startTime)
        
        self.formEndTime = dateFormatter.string(from: endTime)
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.justDate = dateFormatter.string(from: startTime)
        
        
        
        
    }
    
    func toDict() -> [String : Any] {
        return ["startTime" : startTime,
                "endTime" : endTime,
                "namn" : namn!,
                "duration" : duration!,
                "milersattning" : milersattning!]
    }
    
}

