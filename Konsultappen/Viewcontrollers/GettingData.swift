//
//  GettingData.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-11.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class GettingData: UIViewController {
    
    var minArray = [SparadDag]()
    var minSArray = [String]()
    
    var auth : Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("dagar")
        itemRef.getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    //let documentData = document.data()
                    let datat = SparadDag(snapshot: document)
                    self.minArray.append(datat)
                    self.minSArray.append("\(datat.datum) Rest tid: \(datat.restTid) Arbetad tid: \(datat.arbetadTid)")
                    
                }
                self.showArray()
            }
        }
        
        
    }
    func showArray(){
        for a in minSArray {
            print(a)
        }
    }
}


