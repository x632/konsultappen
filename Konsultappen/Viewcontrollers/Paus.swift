//
//  Paus.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import UIKit

class Paus: UIViewController {
      
    var startTime : Date!
    var endTime : Date?
    //var calendar : Calendar!
    var dagObject : Dag!
   override func viewDidLoad() {
               super.viewDidLoad()
    }
    @IBAction func avslutaPausTapped(_ sender: UIButton) {
           endTime = Date()
                let entry = TimePost(startTime: startTime, endTime: endTime!, namn: "Paus")
                dagObject.add(entry: entry)
                
        let a = dagObject.entries[dagObject.count-1]
                print ("Typ: \(a.namn!) Starttid: \(a.formStartTime!) Sluttid: \(a.formEndTime!) sekunder: \(a.duration!)")
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToDagenIgang"{
            let destinationVC = segue.destination as! DagenIgang
            destinationVC.startTime = endTime
            destinationVC.dagObject = dagObject
        }
    }
        
    
    
   
}
       
        
        
        
        


