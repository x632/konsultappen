//
//  SparadDag.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-09.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import Firebase

struct SparadDag {
    var datum : String
    var arbetadTid : Int
    var restTid : Int
 
    
    init(datum : String, arbetadTid: Int, restTid : Int){
        self.datum = datum
        self.arbetadTid = arbetadTid
        self.restTid = restTid
    }
    // en contructor som tar in ett firestore document och skapar ett object utifrån det
      init(snapshot: QueryDocumentSnapshot) {
          let snapshotValue = snapshot.data() as [String : Any]
          datum = snapshotValue["datum"] as! String
          arbetadTid = snapshotValue["arbetadTid"] as! Int
          restTid = snapshotValue["restTid"] as! Int
      }
      

      // gör om ett object till en dictionary som kan laddas upp på firestore
      func toDict() -> [String : Any] {
          return ["datum" : datum,
            "arbetadTid" : arbetadTid,
            "restTid" : restTid]
      }
}
