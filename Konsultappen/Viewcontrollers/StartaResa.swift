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
    
    var auth: Auth!
    var startTime: Date?
    var GPS : [Int]? = [1,2,3]
    var namn : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startaResaPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAvslutaResa", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        startTime = Date()
        if segue.identifier == "toAvslutaResa" {
            let destinationVC = segue.destination as! AvslutaResa
            destinationVC.startTime = startTime
            destinationVC.GPS = GPS
        }
    }
}

