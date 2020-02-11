//
//  Inloggning.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-10.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class Inloggning: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var feluppgifterLbl: UILabel!
    var auth :Auth!
    let segueID = "toStarta"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        feluppgifterLbl.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoggaInPressed(_ sender: UIButton) {
     
        let email : String
        let password : String
        
        if emailTextField.text != "" && passwordTextField.text != "" {
        email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        } else {
            self.showError("You nned to fill in the fields!")
                return
            }
            
        auth.signIn(withEmail: email, password: password) {
            (result, error) in
               
            if error != nil {
                self.feluppgifterLbl.text = error!.localizedDescription
                self.feluppgifterLbl.alpha = 1
            
            } else {
            
                    self.performSegue(withIdentifier: self.segueID, sender: self)
                }
            }
        } 
        
        func showError(_ message: String){
            feluppgifterLbl.text = message
            feluppgifterLbl.alpha = 1
        }
}
    



