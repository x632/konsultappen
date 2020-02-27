//
//  StartaResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestoreSwift

class StartaResa: UIViewController {
    
    @IBOutlet weak var felLabel: UILabel!
    
    var auth: Auth!
    var startTime: Date?
    var GPS : [Int]? = [1,2,3]
    var testArray : [String] = []
    var felMeddelande : String = ""
    var harTryckt = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startaResaPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toAvslutaResa", sender: self)
    }
    
    // möjlighet att gå till tidigare sparade poster
    @IBAction func seSparadePosterTap(_ sender: UIButton) {
        
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        
        let itemRef = db.collection("users").document(user.uid).collection("dagar")
        
        itemRef.getDocuments{ (snapshot, error) in
            
            if error == nil && snapshot != nil{
                for document in snapshot!.documents {
                    
                    let datat = SparadDag(snapshot: document)
                    self.performSegue(withIdentifier: "toData", sender: self)
                    self.harTryckt = false
                }
            }
            if self.harTryckt {
                self.omIngaDokument()
            }
        }
    }
    
    func omIngaDokument(){
        if harTryckt{
            felLabel.text = "Det finns inga poster i databasen!"
            felLabel.alpha = 1
        }
    }
    
    //spara tidpunkt och "bokmärke" på firestore som blir startpunkt sedan
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAvslutaResa" {
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
            db.collection("users").document(user.uid).collection("tidpunkt").document("from").setData(["from" : "AvslutaResa"])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}


