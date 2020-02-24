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
    var sammanlagdaMil = 0.0
    var krPerMil : Int!
    var krPerArbTim : Int!
    var krPerResTim : Int!
    var docIDArray : [String]!
    var selectArray : [Bool] = []
    

    @IBOutlet weak var ArbetadeTimmar: UILabel!
    
    @IBOutlet weak var Restimmar: UILabel!
    
    @IBOutlet weak var Summa: UILabel!    
 
    @IBOutlet weak var Antalmil: UILabel!
    
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
        return (cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var c = 0.0
        var d = 0.0
        var e = 0.0
        var g = 0.0
        let s = minArray![indexPath.row]
        sammanlagdArbTid += (s.arbetadTid)
        sammanlagdResTid += (s.restTid)
        sammanlagdaMil += (s.mil)
        print("direkt från uträkningen \(s.mil)")
        selectArray[indexPath.row] = true
      
        c = (Double(sammanlagdResTid)) * ((Double(krPerResTim)/60))
        d = (Double(sammanlagdArbTid) * (Double(krPerArbTim)/60))
        g = sammanlagdaMil * (Double(krPerMil))
        e = c + d + g
        let f = Int(e)
        Summa.text = "\(f)kr"
        let a = makeHoursFormat(sammanlagdArbTid)
        let b = makeHoursFormat(sammanlagdResTid)
        ArbetadeTimmar.text = a
        Restimmar.text = b
        Antalmil.text = "\(String(format: "%.1f", sammanlagdaMil))"
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let s = minArray![indexPath.row]
        var c = 0.0
        var d = 0.0
        var e = 0.0
        var g = 0.0
        sammanlagdArbTid -= (s.arbetadTid)
        sammanlagdResTid -= (s.restTid)
        sammanlagdaMil -= (s.mil)
        selectArray[indexPath.row] = false
       
        c = (Double(sammanlagdResTid)) * ((Double(krPerResTim)/60))
        d = (Double(sammanlagdArbTid) * (Double(krPerArbTim)/60))
        g = sammanlagdaMil * (Double(krPerMil))
        e = c + d + g
        let f = Double(round(1*e)/1)
        Summa.text = "\(f)kr"
        let a = makeHoursFormat(sammanlagdArbTid)
        let b = makeHoursFormat(sammanlagdResTid)
        ArbetadeTimmar.text = a
        Restimmar.text = b
        Antalmil.text = "\(String(format: "%.1f", sammanlagdaMil))"
        
        
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        minSArray.remove(at: indexPath.row)
        minArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
    db.collection("users").document(user.uid).collection("dagar").document(docIDArray[indexPath.row]).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed from cloud")
                self.docIDArray.remove(at:indexPath.row)
                self.sammanlagdArbTid = 0
                self.sammanlagdResTid = 0
                self.sammanlagdaMil = 0.0
            }
        }
        
        
        
        
        }
    }

   
    @IBAction func raderaTapped(_ sender: Any) {
    
    
    }
}


