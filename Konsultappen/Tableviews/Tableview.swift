//
//  Tableview.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-31.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class Tableview: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var dagObject : Dag!
    
    var list : [String] = []
    var arbetadTid = 0
    var restTid = 0
    var datum = ""
    var auth : Auth!
    var minArray = [SparadDag]()
    var minSArray : [String] = []
    var testArray: [TimePost]!
    var docID : [String]!
    var kommitVanligaVagen = true
    var sammanlagdMilersattning : Double = 0.0
    var mil : Double = 0.0
    var comment = ""
   
    
    @IBOutlet weak var sComment: UITextField!
    
    //sätter "bokmärke" (ej relevant just här efter att gps tillkommit, sparar på firestore
    //Går igenom testArrayn och skapar "listArrayn" för tableviewn
    //utifrån det
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        auth = Auth.auth()
        let db = Firestore.firestore()
        guard let user = auth.currentUser else { return }
        db.collection("users").document(user.uid).collection("tidpunkt").document("from").setData(["from" : "tableview"])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        for n in 0...(testArray.count-1){
            var b = ""
            
            if "\(testArray[n].namn!)" == "Paus"{
                b = ("\(testArray[n].namn!)")
            } else if "\(testArray[n].namn!)" == "Ditresa"{
                let c = testArray[n].milersattning!/10000
                b = ("\(testArray[n].namn!) \(testArray[n].formStartTime!) - \(testArray[n].formEndTime!) mil: \(String(format: "%.2f", c))")
            }
            else if "\(testArray[n].namn!)" == "Tillbakaresa"{
                let c = testArray[n].milersattning!/10000
                b = ("\(testArray[n].namn!) \(testArray[n].formStartTime!) - \(testArray[n].formEndTime!) mil: \(String(format: "%.2f", c))")
            }
            else{
                b = ("\(testArray[n].namn!) \(testArray[n].formStartTime!) - \(testArray[n].formEndTime!)")
            }
            if "\(testArray[n].namn!)" == "Arbetstid"{
                arbetadTid += testArray[n].duration!
            }
            if "\(testArray[n].namn!)" == "Ditresa" || "\(testArray[n].namn!)" == "Tillbakaresa"{
                restTid += testArray[n].duration!
                sammanlagdMilersattning += testArray[n].milersattning!
            }
            datum = testArray[n].justDate!
            list.append(b)
            titleLabel?.text = datum
            
        }
        
        list.append("*************************************")
        let a = makeHoursFormat(restTid)
        list.append("RESTID: \(a)min")
        let b = makeHoursFormat(arbetadTid)
        list.append("ARBETAD TID: \(b)min")
        let c = sammanlagdMilersattning/10000
        list.append("RESTA MIL: \(String(format: "%.2f", c))")
       //tar med denna till TVshowData
        mil = c
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return (cell)
    }
    @IBAction func sparaTapped(_ sender: Any) {
        saveToFirestore()
    }
    
    //spara dagen (arbtid, restid, mil, kommentar) i Firestore
    func saveToFirestore (){
        if sComment.text! != ""{
            comment = sComment.text!}
        
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("dagar")
        let sparadObj = SparadDag(datum : datum, arbetadTid : arbetadTid, restTid : restTid, timeStamp: Date(), mil: mil, comment : comment)
        itemRef.addDocument(data: sparadObj.toDict()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added to cloud!")
                self.showArray()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOvercome" {
            let destinationVC = segue.destination as! OvercomeAsyncVC
            destinationVC.docID = docID
            destinationVC.kommitVanligaVagen = kommitVanligaVagen
        }
    }
    
    // användes förut för att printa arrayn i consolen
    func showArray(){
        performSegue(withIdentifier: "toOvercome", sender: self)
    }
    @objc func dismissKeyboard(){
           sComment.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
           sComment.resignFirstResponder()
           return true
       }
    
}


