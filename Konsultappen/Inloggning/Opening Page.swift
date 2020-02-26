//
//  ViewController.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-17.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class OpeningPage: UIViewController {
    var db: Firestore!
    var haveReg = false
    var auth :Auth!
    var stannatVid = ""
    var startTime : Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        getFromFirestore()
    }
    
    // logga ut användaren
    @IBAction func signOutTapped(_ sender: UIButton) {
        if let user = self.auth.currentUser {
            print(user.email!, "has signed out")
            
            do {
                try auth.signOut()
            } catch {
                print("Error signing out")
            }
        }
    }
    // Kollar om användaren är inloggad - i så fall går direkt till start
    // annars gå till registrering
    @IBAction func Tapped(_ sender: UITapGestureRecognizer) {
        if let user = self.auth.currentUser {
            print(user.email!, "is signed in!")
            self.haveReg = true
        }
        if haveReg {
            performSegue(withIdentifier: "haveLoggedToStart", sender: self)
        }
        else {
            performSegue(withIdentifier: "toRegistration", sender: self)
        }
    }
    
    // Kolla först att det inte har avslutats mitt i..
    // om så är fallet så skickas användaren dit där han slutade
    func getFromFirestore() {
        auth = Auth.auth()
        let db = Firestore.firestore()
        
        guard let user = auth.currentUser else { return }
        let itemRef = db.collection("users").document(user.uid).collection("tidpunkt").document("from")
        
        itemRef.getDocument { (document, error) in
            if error == nil{
                
                if document != nil && document!.exists {
                      let documentData = document!.data()
                    self.stannatVid = documentData!["from"] as! String
                    print("\(self.stannatVid)")
                    self.navigating()
                }
            }
        }
    }
    //användaren skickas till där han slutade
    func navigating(){
        if stannatVid == "AvslutaResa"{
            performSegue(withIdentifier: "tillAvslutaResa", sender: self)
        }
        if stannatVid == "DagenIgang"{
            performSegue(withIdentifier: "tillDagenIgang", sender: self)
        }
        if stannatVid == "Paus"{
                   performSegue(withIdentifier: "tillPaus", sender: self)
        }
        if stannatVid == "Hemresa"{
                          performSegue(withIdentifier: "tillHemresa", sender: self)
        }
    }
}

