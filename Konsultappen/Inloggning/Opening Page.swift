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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
    }
  
    
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
}


