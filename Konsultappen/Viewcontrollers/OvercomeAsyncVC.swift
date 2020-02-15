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
              
    
    @IBOutlet weak var krPerArbTim: UITextField!
    
    @IBOutlet weak var krPerMil: UITextField!
  
    @IBOutlet weak var krPerResTim: UITextField!
    
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
              let mil : Int
              let arb : Int
              let res : Int
              //let annan : Int
              if let a = Int(krPerMil.text!){
                  mil = a}
              else {mil = 0}
              if let a = Int(krPerArbTim.text!){
                  arb = a}
              else {arb = 0}
              if let a = Int(krPerResTim.text!){
                  res = a}
              else {res = 0}
        let destVC = segue.destination as! TableViewShowData
         destVC.minArray = minArray
         destVC.minSArray = minSArray
        destVC.krPerArbTim = mil
        destVC.krPerResTim = arb
        destVC.krPerMil = res
      }
    
    @IBAction func vidareTapped(_ sender: UIButton) {
        if klar{
     self.performSegue(withIdentifier: "toVisaData", sender: self)
        }
    }
    
}
    
    

    

