//
//  Reg.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-08.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//


import Foundation
import Firebase

class Reg {
    
    var krPerMil : String
    var krPerRes : String
    var krPerArb : String
    
    init(krPerMil : String, krPerRes : String, krPerArb : String ) {
        self.krPerMil = krPerMil
        self.krPerRes = krPerRes
        self.krPerArb = krPerArb
    }
    
    
    // en contructor som tar in ett firestore document och skapar ett object utifrån det
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        krPerMil = snapshotValue["krPerMil"] as! String
        krPerRes = snapshotValue["krPerRes"] as! String
        krPerArb = snapshotValue["krPerArb"] as! String
    }
    
//    func switchDone() {
//        done = !done
//    }
    
    // gör om ett object till en dictionary som kan laddas upp på firestore
    func toDict() -> [String : Any] {
        return ["krPerMil" : krPerMil,
                "krPerRes" : krPerRes,
                "krPerArb" : krPerArb]
    }
    
}

