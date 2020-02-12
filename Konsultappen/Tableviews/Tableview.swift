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
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
           
        //plussar på tiderna, skapar
            for n in 0...(dagObject.count-1){
             
                var b = ""
                let a = dagObject.entries[n]
                if "\(a.namn!)" == "Paus"{
                b = ("\(a.namn!)")
                } else{
                b = ("\(a.namn!) \(a.formStartTime!) - \(a.formEndTime!)")
                }
                if "\(a.namn!)" == "Arbetad tid"{
                    arbetadTid += a.duration!
                }
                if "\(a.namn!)" == "Resa"{
                    restTid += a.duration!
                }
                datum = a.justDate!
                list.append(b)
                titleLabel?.text = datum
                
               
            }
            list.append("***************************")
            list.append("RESTID: \(restTid)min")
            list.append("ARBETAD TID: \(arbetadTid)min")
        
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
       
    // obs! ingen completion handler på sparaningen
    func saveToFirestore (){
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("dagar")
        let sparadObj = SparadDag(datum : datum, arbetadTid : arbetadTid, restTid : restTid, timeStamp: Date())
        itemRef.addDocument(data: sparadObj.toDict())
        getFromFirestore()
    }
    func getFromFirestore(){
                    auth = Auth.auth()
                    guard let user = auth.currentUser else { return }
                    let db = Firestore.firestore()
                    let itemRef = db.collection("users").document(user.uid).collection("dagar")
                        itemRef.getDocuments { (snapshot, error) in
                            if error == nil && snapshot != nil {
                                for document in snapshot!.documents {
                                    let datat = SparadDag(snapshot: document)
                                    self.minArray.append(datat)
                                    self.minSArray.append("\(datat.datum) Rest tid: \(datat.restTid) Arbetad tid: \(datat.arbetadTid)")
        
                                }
                                self.showArray()
                            }
                        }
        
    }
    func showArray(){
       for a in minSArray {
            print(a)
        }
        performSegue(withIdentifier: "toSaved", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
              if segue.identifier == "toSaved" {
                  let destinationVC = segue.destination as! TableViewShowData
                  destinationVC.minArray = minArray
                  destinationVC.minSArray = minSArray
               }
    }
}

