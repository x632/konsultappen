//
//  Dag.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-25.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
struct Dag {
     var entries = [TimePost]()
    
    var count : Int {
        return entries.count
    }
    
    
    
    mutating func add(entry: TimePost) {
        entries.append(entry)
    }
    
    
    
    func entry(index: Int) -> TimePost? {
            if index >= 0 && index < entries.count {
                return entries[index]
            }
            
            return nil
        }
    }

