//
//  RegAuth.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-07.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestoreSwift


class RegAuth: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // var db: Firestore!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var db: Firestore!
    var auth :Auth!
    let segueID = "toInloggning"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        errorLabel.alpha = 0
    }
    
    // skapar ny användare
    @IBAction func sparaPressed(_ sender: UIButton) {
        
        let email : String
        let password : String
        if emailTextField.text != "" && passwordTextField.text != ""{
            email = emailTextField.text!
            password = passwordTextField.text!
        }
        else{ showError("You need to fill in both fields!" )
            return
            
        }
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil{
               self.errorLabel.text = err!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                print("Successfully created user!")
                self.performSegue(withIdentifier: "toInloggning", sender: self)
            }
        }
        
    }
    
    //Visa felmeddelande - felaktig epost eller lösenord
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

