//
//  ViewController2.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-18.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var krPerMil: UITextField!

    @IBOutlet weak var krPerRes: UITextField!
    
    @IBOutlet weak var krPerArb: UITextField!
    
    @IBOutlet weak var krPerTAnnan: UITextField!
    
    var milErsattning = ""
    var arbetsTimme = ""
    var resTimme = ""
    var annanTimme = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    @IBAction func SparaPressed(_ sender: Any) {
        self.milErsattning = krPerMil.text!
        self.arbetsTimme = krPerArb.text!
        self.resTimme = krPerRes.text!
        self.annanTimme = krPerTAnnan.text!
        
        print(milErsattning)
        print(arbetsTimme)
        print(resTimme)
        print(annanTimme)
        
        performSegue(withIdentifier: "toStartaResa", sender: self)
    }
    

}

