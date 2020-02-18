//
//  HemResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-25.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import UIKit

class HemResa: UIViewController {
 
    var startTime : Date!
    var endTime : Date?
    var dagObject : Dag!
    
override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
   }
    @IBAction func avslutaDagenTapped(_ sender: Any) {
    endTime = Date()
          let entry = TimePost(startTime: startTime, endTime: endTime!,namn: "Resa")
          dagObject.add(entry: entry)
          
        let a = dagObject.entries[dagObject.count-1]
          print ("Typ: \(a.namn!) starttid: \(a.formStartTime!) sluttid: \(a.formEndTime!) sekunder: \(a.duration!)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toTableView"{
             let destinationVC = segue.destination as! Tableview
             destinationVC.dagObject = dagObject
        }
        
    }
}
