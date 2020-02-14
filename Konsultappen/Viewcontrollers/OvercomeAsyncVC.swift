//
//  OvercomeAsyncVC.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-13.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class OvercomeAsyncVC: UIViewController {
   
    var minArray = [SparadDag]()
             var minSArray : [String] = []
             var auth : Auth!
            var klar = false
    override func viewDidLoad() {
    
              super.viewDidLoad()
                  getFromFirestore()
                 }
              
    
    
        
          func getFromFirestore(){
              auth = Auth.auth()
              guard let user = auth.currentUser else { return }
              let db = Firestore.firestore()
              
              
              let itemRef = db.collection("users").document(user.uid).collection("dagar").whereField("timeStamp", isLessThan: Date())
              itemRef.getDocuments{ (snapshot, error) in
                  if error == nil && snapshot != nil {
                      for document in snapshot!.documents {
                          let datat = SparadDag(snapshot: document)
                          self.minArray.append(datat)
                          self.minSArray.append("\(datat.datum) Rest tid: \(datat.restTid)min Arbetad tid: \(datat.arbetadTid)min")
                      }
                      print("min Array: ", self.minArray)
                      print("min SArray: ", self.minSArray)
                    self.klar = true
                  }
              }
          }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destVC = segue.destination as! TableViewShowData
         destVC.minArray = minArray
         destVC.minSArray = minSArray
      }
    
    @IBAction func vidareTapped(_ sender: UIButton) {
        if klar{
     self.performSegue(withIdentifier: "toVisaData", sender: self)
        }
    }
    
}
    
    

    

