//
//  SparadDag.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-09.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct SparadDag {
    var datum : String
    var arbetadTid : Int
    var restTid : Int
    var timeStamp : Date
    var mil : Double
    
    init(datum : String, arbetadTid: Int, restTid : Int, timeStamp : Date, mil: Double){
        self.datum = datum
        self.arbetadTid = arbetadTid
        self.restTid = restTid
        self.timeStamp = Date()
        self.mil = mil
    }
    // en contructor som tar in ett firestore document och skapar ett object utifrån det
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        datum = snapshotValue["datum"] as! String
        arbetadTid = snapshotValue["arbetadTid"] as! Int
        restTid = snapshotValue["restTid"] as! Int
        let tS = snapshotValue["timeStamp"] as! Timestamp
        timeStamp = tS.dateValue()
        mil = snapshotValue["mil"] as! Double
    }
    

      // gör om ett object till en dictionary som kan laddas upp på firestore
      func toDict() -> [String : Any] {
          return ["datum" : datum,
            "arbetadTid" : arbetadTid,
            "restTid" : restTid,
            "timeStamp" : Timestamp(date:Date()),
            "mil" : mil]
            
      }
}
