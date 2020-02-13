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
       
    // obs! ingen completion handler på sparningen - åtgärdat
    func saveToFirestore (){
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("dagar")
        let sparadObj = SparadDag(datum : datum, arbetadTid : arbetadTid, restTid : restTid, timeStamp: Date())
        itemRef.addDocument(data: sparadObj.toDict()) { err in
            if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added!")
                self.showArray()
                }
            }
        
       
       
        }
    
 
    func showArray(){
       for a in minArray {
            print(a)
        }
        performSegue(withIdentifier: "toOvercome", sender: self)
    }

}

//addDocument(data: sparadObj.toDict())
