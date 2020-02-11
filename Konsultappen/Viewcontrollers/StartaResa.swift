//
//  StartaResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit


class StartaResa: UIViewController {
   
    
    var startTime: Date?
    var calendar : Calendar?
    var GPS : [Int]? = [1,2,3]
    
    override func viewDidLoad() {
          super.viewDidLoad()
//        print ("Arbetad timme utskriven från StartaResa", reg.arbetadTimme, reg.milersattning)
      }
    
    @IBAction func startaResaPressed(_ sender: UIButton) {
          performSegue(withIdentifier: "toAvslutaResa", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        calendar = Calendar.current
         startTime = Date()
        if segue.identifier == "toAvslutaResa" {
            let destinationVC = segue.destination as! AvslutaResa
            destinationVC.startTime = startTime
            destinationVC.calendar = calendar
            destinationVC.GPS = GPS
         }
    }
}

