//
//  TableViewShowData.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-12.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class TableViewShowData: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var minArray : [SparadDag]!
    var minSArray : [String]!
    var auth : Auth!
    var sammanlagdArbTid = 0
    var sammanlagdResTid = 0
    
    
    
    @IBOutlet weak var ArbetadeTimmar: UILabel!
    @IBOutlet weak var Restimmar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return minSArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = minSArray[indexPath.row]
        //print (minSArray[indexPath.row])
         return (cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s=minArray![indexPath.row]
        sammanlagdArbTid += (s.arbetadTid)
        sammanlagdResTid += (s.restTid)
        let a = makeHoursFormat(sammanlagdArbTid)
        let b = makeHoursFormat(sammanlagdResTid)
        ArbetadeTimmar.text = "Antal arbetstimmar (och minuter):  " + a
        Restimmar.text = "Antal restimmar (och minuter): " + b
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         let s=minArray![indexPath.row]
               sammanlagdArbTid -= (s.arbetadTid)
               sammanlagdResTid -= (s.restTid)
               let a = makeHoursFormat(sammanlagdArbTid)
               let b = makeHoursFormat(sammanlagdResTid)
               ArbetadeTimmar.text = "Antal arbetstimmar (och minuter): " + a
               Restimmar.text = "Antal restimmar (och minuter): " + b
    }
   
    func makeHoursFormat(_ a: Int) -> String{
        var timmar = 0
        var minuter = 0
        if a > 59 {
            timmar = Int(a / 60)
            minuter = a % 60
            }
        else{minuter = a}

        if minuter < 10 && timmar == 0 {
                    return ("0:0\(minuter)")
                
                    }
                    else if minuter > 9 && timmar == 0{
                    return ("0:\(minuter)")
                    }
        if timmar > 0 && timmar < 10 && minuter > 9{
            return ("\(timmar):\(minuter)")
        }else if timmar > 0 && minuter < 10{
            return ("\(timmar):0\(minuter)")
        }
       
    return "!"
    }
    
    
}
