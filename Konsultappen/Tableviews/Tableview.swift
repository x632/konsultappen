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
    
        override func viewDidLoad() {
            super.viewDidLoad()
         
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
                                } else{
                                b = ("\(testArray[n].namn!) \(testArray[n].formStartTime!) - \(testArray[n].formEndTime!)")
                                }
                                if "\(testArray[n].namn!)" == "Arbetstid"{
                                    arbetadTid += testArray[n].duration!
                                }
                                if "\(testArray[n].namn!)" == "Resa"{
                                    restTid += testArray[n].duration!
                                }
                                datum = testArray[n].justDate!
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
    
 
    func showArray(){
       for a in minArray {
            print(a)
        }
        performSegue(withIdentifier: "toOvercome", sender: self)
    }

}

//addDocument(data: sparadObj.toDict())
