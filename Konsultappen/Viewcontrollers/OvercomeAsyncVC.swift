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
    var docIDArray : [String] = []
    var auth : Auth!
    var klar = false
    var docID : [String]!
    var utfort = false
    var kommitVanligaVagen : Bool?
    
    override func viewDidLoad() {
      //radera Timposts collection om kommit från tableview 1
        if kommitVanligaVagen != nil{
            super.viewDidLoad()
            let max = docID.count
            var id = ""
            var index = 0
            while index < max{
                id = ("\(docID![index])")
                let b = eraseCollection(ID: id)
                print (b)
                index += 1
            }
        }
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
                    self.docIDArray.append(document.documentID)
                    self.minArray.append(datat)
                    self.minSArray.append("\(datat.datum) Rest tid: \(datat.restTid)min Arbetad tid: \(datat.arbetadTid)min")
                }
                
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
        if utfort == true {
            docID = []
        }
        let destVC = segue.destination as! TableViewShowData
        destVC.minArray = minArray
        destVC.minSArray = minSArray
        destVC.krPerArbTim = arb
        destVC.krPerResTim = res
        destVC.krPerMil = mil
        destVC.docIDArray = docIDArray
    }
    
    @IBAction func vidareTapped(_ sender: UIButton) {
        if klar{
            self.performSegue(withIdentifier: "toVisaData", sender: self)
        }else {
            print ("Håller på och laddar data, vänta ett ögonblick!")
        }
    }
    func eraseCollection(ID : String) -> Bool{
        
        auth = Auth.auth()
        if let user = auth.currentUser {
            utfort = false
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).collection("timeposts").document(ID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    self.utfort = false
                } else {
                    print("Document successfully removed from cloud")
                    self.utfort = true
                }
            }
        }
        
        return utfort
    }
    
}





