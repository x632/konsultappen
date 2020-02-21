//
//  HemResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-25.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class HemResa: UIViewController {
    
    var dagObject : Dag?
    var startTime : Date!
    var endTime : Date?
    var auth: Auth!
    //var minArray = [SparadDag]()
    var minSArray : [String] = []
    var docIDArray : [String] = []
    var testArray = [TimePost]()
    
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
                print("Document 'tidpunkt' successfully written!")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func avslutaDagenTapped(_ sender: Any) {
        getFromFirestore() //ta startpunkt från firestore
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            print ("från prepare for segue")
        
        
        if segue.identifier == "toTableview" {
             let destinationVC = segue.destination as! Tableview
             destinationVC.dagObject = dagObject
            destinationVC.testArray = testArray
        }
        
    }
    func createFirestoreTimePostObject(){//tar skuttiden och sparar ett firestoretimepostobjekt
        endTime = Date()
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("timeposts")
        
        let post = TimePost(startTime: startTime!, endTime: endTime!,namn: "Resa")
        
        itemRef.addDocument(data: post.toDict()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Timepost document added to cloud!")
                print(post)
                self.getAllFromFirestore()
                
                //self.performSegue(withIdentifier: "toTableview", sender: self)
            }
        }
    }
    //Ladda ner alla Timepostobject från firestore och lägg in dem i en Dagarray
    func getAllFromFirestore() {
          
            auth = Auth.auth()
          guard let user = auth.currentUser else { return }
          let db = Firestore.firestore()
            let itemRef = db.collection("users").document(user.uid).collection("timeposts").whereField("startTime", isLessThan: Date())
          itemRef.getDocuments{ (snapshot, error) in
          
            if error == nil && snapshot != nil {
                print("snapshot successfylly taken!")
                  for document in snapshot!.documents {
                     
                    let datat = TimePost(snapshot: document)
                    self.testArray.append(datat)
                    //self.dagObject = self.createObject(timepost: datat)
                    //self.docIDArray.append(document.documentID)
                
                }
                print(self.testArray)
                self.performSegue(withIdentifier: "toTableview", sender: self)
           
            }
        }
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
                    self.createFirestoreTimePostObject()
                }
            }
        }
    }
        
//    func createObject(timepost: TimePost) -> Dag{
//
//
//            let entry = timepost
//            var dagObject = Dag()
//            dagObject.add(entry: entry)
//
//           let a = dagObject.entries[dagObject.count-1]
//            print ("från createobject Typ: \(a.namn!) Starttid: \(a.formStartTime!) Sluttid: \(a.formEndTime!) Sekunder: \(a.duration!)")
////
//            return dagObject
//            }
   
        
        
        
    
}
