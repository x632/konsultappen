//
//  Register.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-24.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
struct Register {
    
    var milersattning : Int//per mil
    var resTid: Int         //per timme
    var arbetadTimme: Int
    
    
    init(milersattning: Int, resTid : Int, arbetadTimme: Int){
        self.milersattning = milersattning
        self.resTid = resTid
        self.arbetadTimme = arbetadTimme
    }
    
}
