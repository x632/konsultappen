//
//  ViewController3.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-19.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
   
    var date : Date?
    var calendar : Calendar?
    let segueToDisplayId = "toDagenIgang"
    
    override func viewDidLoad() {
          super.viewDidLoad()
      
          // Do any additional setup after loading the view.
      }


    
    @IBAction func StartTripPressed(_ sender: UIButton) {
        getCurrentDateTime()
        performSegue(withIdentifier: "toDagenIgang", sender: self)
    }
   
    func getCurrentDateTime(){
        
        calendar = Calendar.current
        date = Date()
        
        // In Ints
//        let hours = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
//        let day = calendar.component(.day, from: date)
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
        
        //Stringify
        //tiden = "\(hours):\(minutes):\(seconds)"
        //datumet = "\(year)-\(month)-\(day)"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == segueToDisplayId {
            let destinationVC = segue.destination as! ViewController4
            destinationVC.receivingDate = date
            destinationVC.receivingCalendar = calendar
         }
    }
}
