//
//  DagenIgang.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-12.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit

class DagenIgang: UIViewController {
    
    var startTime : Date!
    var calendar : Calendar!
    var endTime : Date?
    var dagObject : Dag!
    override func viewDidLoad() {
             super.viewDidLoad()
    }
        
    
        @IBAction func unwindToDagenIgang(_ sender: UIStoryboardSegue){}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dagenToPaus" || segue.identifier == "toHemresa"{
                dagObject = createObject()
            calendar = Calendar.current
            startTime = Date()
            
            if segue.identifier == "dagenToPaus"{
                let destinationVC = segue.destination as! Paus
                destinationVC.startTime = startTime
                destinationVC.calendar = calendar
                destinationVC.dagObject = dagObject
            }
            else{
                let destinationVC = segue.destination as! HemResa
                destinationVC.startTime = startTime
                destinationVC.calendar = calendar
                destinationVC.dagObject = dagObject
            }
        }
            
        
    }
    func createObject() -> Dag{
           endTime = Date()
       let entry = TimePost(startTime: startTime, endTime: endTime!, calendar: calendar,namn: "Arbetad tid")
             dagObject.add(entry: entry)
             
        let a = dagObject.entries[dagObject.count-1]
             print ("Typ: \(a.namn!) Starttid: \(a.formStartTime!) Sluttid: \(a.formEndTime!) Sekunder: \(a.duration!)")
           return dagObject
       }
}
