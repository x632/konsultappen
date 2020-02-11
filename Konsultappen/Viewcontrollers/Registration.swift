//
//  ViewController2.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-18.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit

class Registration: UIViewController {
    
    var reg : Register?
   
    @IBOutlet weak var krPerMil: UITextField!
    @IBOutlet weak var krPerRes: UITextField!
    @IBOutlet weak var krPerArb: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
    }
    @IBAction func sparaPressed(_ sender: UIButton) { 
      //  performSegue(withIdentifier: "toStartaResa", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mil : Int
        let arb : Int
        let res : Int
        //let annan : Int
        if let a = Int(krPerMil.text!){
            mil = a}
        else {mil = 0}
        if let a = Int(krPerArb.text!){
            arb = a}
        else {arb = 0}
        if let a = Int(krPerRes.text!){
            res = a}
        else {res = 0}
    //  if let a = Int(krPerAnnan.text!){
    //  annan = a}
    //  else {annan = 0}
        
        reg = Register(milersattning: mil, resTid: res,arbetadTimme: arb)
        print("från Register", reg!.milersattning)
        
        //let destinationVC = segue.destination as! StartaResa
        //destinationVC.reg = reg
        
    }
}
