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
    var krPerMil : Int!
    var krPerArbTim : Int!
    var krPerResTim : Int!
    var docIDArray : [String]!
    var selectArray : [Bool] = []
    
    @IBOutlet weak var ArbetadeTimmar: UILabel!
    
    @IBOutlet weak var Restimmar: UILabel!
    
    @IBOutlet weak var Summa: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...minSArray.count-1{
            selectArray.append (false)
        }
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
        var c = 0.0
        var d = 0.0
        var e = 0.0
        let s = minArray![indexPath.row]
        sammanlagdArbTid += (s.arbetadTid)
        sammanlagdResTid += (s.restTid)
        selectArray[indexPath.row] = true
        //c = avrundaMinuter(tid: sammanlagdArbTid)
        //d = avrundaMinuter(tid: sammanlagdResTid)
        //e = (c * Double(krPerArbTim)) + (d * Double(krPerResTim))
        
        c = (Double(sammanlagdResTid)) * ((Double(krPerResTim)/60))
        d = (Double(sammanlagdArbTid) * (Double(krPerArbTim)/60))
        e = c + d
        let f = Double(round(100*e)/100)
        Summa.text = "\(f)kr"
        let a = makeHoursFormat(sammanlagdArbTid)
        let b = makeHoursFormat(sammanlagdResTid)
        ArbetadeTimmar.text = a
        Restimmar.text = b
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let s = minArray![indexPath.row]
        var c = 0.0
        var d = 0.0
        var e = 0.0
        sammanlagdArbTid -= (s.arbetadTid)
        sammanlagdResTid -= (s.restTid)
        selectArray[indexPath.row] = false
        //c = avrundaMinuter(tid: sammanlagdArbTid)
        //d = avrundaMinuter(tid: sammanlagdResTid)
        //e = (c * Double(krPerArbTim)) + (d * Double(krPerResTim))
        //e = (Double(sammanlagdResTid) * (krPerResTim/60)) + (Double(sammanlagdArbTid)*(krPerArbTim/60))
        c = (Double(sammanlagdResTid)) * ((Double(krPerResTim)/60))
        d = (Double(sammanlagdArbTid) * (Double(krPerArbTim)/60))
        e = c + d
        let f = Double(round(100*e)/100)
        Summa.text = "\(f)kr"
        let a = makeHoursFormat(sammanlagdArbTid)
        let b = makeHoursFormat(sammanlagdResTid)
        ArbetadeTimmar.text = a
        Restimmar.text = b
    }
   
    
    
    func makeHoursFormat(_ a: Int) -> String{
        var timmar = 0
        var minuter = 0
        
        timmar = Int(a / 60)
        minuter = a % 60
        
        if minuter < 10 {
            return ("\(timmar):0\(minuter)")
        }
        else{
            return ("\(timmar):\(minuter)")
        }
    }
    
    func avrundaMinuter(tid :Int)->Double{
        // räkna ut så att minuter avrundas till 4:dedelstimmar och att detta adderas till timmar, returnera.
        var minutTillTimme = 0.0
        var timmar = 0
        var minuter = 0
        var avrTimMinuter = 0.0
        
        minuter = tid % 60
        if minuter < 8 && minuter >= 0{
            minutTillTimme = 0
        }
        if minuter < 23 && minuter > 7 {
            minutTillTimme = 0.25
        }
        if minuter > 22 && minuter < 38 {
            minutTillTimme = 0.5
        }
        if minuter > 37 && minuter < 53 {
            minutTillTimme = 0.75
        }
        if minuter > 52 {
            minutTillTimme = 1.0
        }
        timmar = Int(tid / 60) // om det finns timmar så extraheras de här
        avrTimMinuter = Double(timmar) + minutTillTimme
        
        return avrTimMinuter
    }
    
    
}


