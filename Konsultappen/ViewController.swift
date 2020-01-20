//
//  ViewController.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-17.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var haveRegistered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapped(_ sender: Any) {
        if haveRegistered {
            performSegue(withIdentifier: "haveRegToStart", sender: self)
        }
        else {
            performSegue(withIdentifier: "toRegistration", sender: self)
        }
    }
}
