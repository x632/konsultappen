//
//  AvslutaResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//


import UIKit

class AvslutaResa: UIViewController {
       
    
    var startTime : Date!
    var calendar : Calendar!
    var endTime : Date?
    var GPS : [Int]?
    
       
    override func viewDidLoad() {
             super.viewDidLoad()
        }
    
    
    
    @IBAction func frammePressed(_ sender: UIButton) {
    performSegue(withIdentifier: "toDagenIgang", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dagObject = createObject()
    let destinationVC = segue.destination as! DagenIgang
        destinationVC.calendar = calendar
        destinationVC.startTime = endTime
        destinationVC.dagObject = dagObject
    }
    func createObject() -> Dag{
        endTime = Date()
    let entry = TimePost(startTime: startTime, endTime: endTime!, calendar: calendar,namn: "Resa")
       
          var dagObject = Dag()
          dagObject.add(entry: entry)
          
        let a = dagObject.entries[dagObject.count-1]
          print ("Typ: \(a.namn!) Starttid: \(a.formStartTime!) Sluttid: \(a.formEndTime!) Sekunder: \(a.duration!)")
        return dagObject
    }
}
