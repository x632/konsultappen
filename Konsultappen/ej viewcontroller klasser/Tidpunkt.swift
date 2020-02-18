//
//  Tidpunkt.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-18.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TidPunkt {
    var tidpunkt : Date
    var namn : String
    
    init(tidpunkt : Date, namn : String){
        
        self.tidpunkt = tidpunkt
        self.namn = namn
    }
    // en contructor som tar in ett firestore document och skapar ett object utifrån det
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        let tS = snapshotValue["timeStamp"] as! Timestamp
        tidpunkt = tS.dateValue()
        namn = snapshotValue["namn"] as! String
        
    }
    

      // gör om ett object till en dictionary som kan laddas upp på firestore
      func toDict() -> [String : Any] {
          return ["namn" : namn,
                  "tidpunkt" : Timestamp(date:tidpunkt)]
            
      }
}
