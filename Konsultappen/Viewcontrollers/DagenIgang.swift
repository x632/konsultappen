//
//  DagenIgang.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-12.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class DagenIgang: UIViewController {
    
    var startTime : Date!
    var endTime : Date?
    var auth: Auth!
    
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
    @IBAction func pausTapped(_ sender: UIButton) {
        getFromFirestore(a: true )
    }
    
    @IBAction func startaHemresaTapped(_ sender: UIButton) {
      getFromFirestore(a: false)
    }
  
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dagenToPaus" {
            createFirestoreTimePostObject()
            let destinationVC = segue.destination as! Paus
            destinationVC.startTime = endTime
        }
        else{
            createFirestoreTimePostObject()
            let destinationVC = segue.destination as! HemResa
            destinationVC.startTime = endTime
           
        }
    }
    func createFirestoreTimePostObject(){
        endTime = Date()
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("timeposts")
        
        let post = TimePost(startTime: startTime!, endTime: endTime!,namn: "Arbetstid")
        
        itemRef.addDocument(data: post.toDict()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Timepost document added to cloud!")
                print(post)
            }
        }
    }
    func getFromFirestore( a: Bool) {
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
                    print("Document succefully read from cloud: \(self.startTime!)")
                    if a {
                        self.performSegue(withIdentifier: "dagenToPaus", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "toHemresa", sender: self)
                    }
                }
            }
        }
    }
}
