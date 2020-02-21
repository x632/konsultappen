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
    var startTime : Date?
    var endTime : Date?
    var GPS : [Int]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }
    
    @IBAction func frammePressed(_ sender: UIButton) {
        getFromFirestore()
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let dagObject = createObject()
        createFirestoreTimePostObject()
        startTime = Date()
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
           db.collection("users").document(user.uid).collection("tidpunkt").document("from").setData(["from" : "DagenIgang"])
           { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
    }
    
    func createFirestoreTimePostObject(){
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
                    self.performSegue(withIdentifier: "toDagenIgang", sender: self)
                }
            }
        }
    }    
}
