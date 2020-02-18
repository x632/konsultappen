//
//  AvslutaResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift

class AvslutaResa: UIViewController {
       
    var auth: Auth!
    var startTime : Date!
    var endTime : Date?
    var GPS : [Int]?
   
       
    override func viewDidLoad() {
            super.viewDidLoad()
              auth = Auth.auth()
              let db = Firestore.firestore()
              guard let user = auth.currentUser else { return }
            db.collection("users").document(user.uid).collection("tidpunkt").document("tid").setData(["tidpunkt" : startTime!])
              { err in
                  if let err = err {
                      print("Error writing document: \(err)")
                  } else {
                      print("Document successfully written!")
                  }
              }
              
        }
    
    @IBAction func frammePressed(_ sender: UIButton) {
       getFromFirestore()
       
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dagObject = createObject()
    let destinationVC = segue.destination as! DagenIgang
        destinationVC.startTime = endTime
        destinationVC.dagObject = dagObject
    }
    func createObject() -> Dag{
        endTime = Date()
    
    let entry = TimePost(startTime: startTime!, endTime: endTime!,namn: "Resa")
       
          var dagObject = Dag()
          dagObject.add(entry: entry)
          
        let a = dagObject.entries[dagObject.count-1]
          print ("Typ: \(a.namn!) Starttid: \(a.formStartTime!) Sluttid: \(a.formEndTime!) Sekunder: \(a.duration!)")
        return dagObject
    }
    func getFromFirestore() {
              auth = Auth.auth()
              let db = Firestore.firestore()
              guard let user = auth.currentUser else { return }
         let itemRef = db.collection("users").document(user.uid).collection("tidpunkt").document("tid")
         
              itemRef.getDocument { (document, error) in
                 if error == nil{
                     
                     if document != nil && document!.exists {
                         let documentData = document!.data()
                         let ts = documentData!["tidpunkt"] as! Timestamp
                        self.startTime = ts.dateValue()
                        print("Document succefully read: \(self.startTime!)")
                        self.performSegue(withIdentifier: "toDagenIgang", sender: self)
                 }
              }
         }
     }
     
}
