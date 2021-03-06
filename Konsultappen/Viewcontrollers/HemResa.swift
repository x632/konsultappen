//
//  HemResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-25.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

class HemResa: UIViewController, CLLocationManagerDelegate {
    
 
    var index : Int = -1
    var totalDistance : Double = 0.0
    var startTime : Date?
    var endTime : Date?
    var auth: Auth!
    var minSArray : [String] = []
    var docID : [String] = []
    var testArray = [TimePost]()
    var manager: CLLocationManager?
    var Locations : [CLLocation] = []
    var firstLocation : CLLocation?
    var lastLocation : CLLocation?
    var harTryckt : Bool = true
    var bugfix : Bool = false
    
    @IBOutlet weak var resaLabel: UILabel!
    
    // startar GPS
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.distanceFilter = 50
        manager?.allowsBackgroundLocationUpdates = true
        manager?.startUpdatingLocation()
        
        
        getFromFirestore()
    }
    
    @IBAction func avslutaDagenTapped(_ sender: Any) {
        //hanterar buggen att hinna trycka två gånger vid dålig uppkoppling
        if harTryckt {
        manager?.stopUpdatingLocation()
        self.createFirestoreTimePostObject()
            harTryckt = false}
    }
    // distansberäkningen
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if locations.last != nil {
            if bugfix == false && totalDistance != 0.0{
                           totalDistance = 0.0
                           bugfix = true
            }
             
             Locations.append(locations.last!)
             index += 1
             if index == 0 {
             firstLocation = Locations[index]
             }
             else {
             firstLocation = Locations[index-1]
             lastLocation = Locations[index]
            
             let distanceBetweenLocations =  lastLocation!.distance(from: firstLocation!)
             totalDistance += distanceBetweenLocations
             resaLabel.text = ("mil: \(String(format: "%.2f", totalDistance/10000))")
             }
         }
         
     }
    //Skicka med array med timeposts och array med id:n till tableview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTableview" {
             let destinationVC = segue.destination as! Tableview
             destinationVC.docID = docID
            destinationVC.testArray = testArray
        }
        
    }
    //tar sluttiden och sparar ett firestoretimepostobjekt
    func createFirestoreTimePostObject(){
        endTime = Date()
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("timeposts")
        
       let post = TimePost(startTime: startTime!, endTime: endTime!,namn: "Tillbakaresa", milersattning: totalDistance)
        
        itemRef.addDocument(data: post.toDict()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Timepost document added to cloud!")
                //print(post)
                self.getAllFromFirestore()
                
            }
        }
    }
    //Ladda ner alla Timepostobject från firestore och lägg in dem i
    //en dagarray(testArray). Gör också en array med ID:s för att senare kunna radera dessa dokument
    func getAllFromFirestore() {
          
            auth = Auth.auth()
          guard let user = auth.currentUser else { return }
          let db = Firestore.firestore()
            let itemRef = db.collection("users").document(user.uid).collection("timeposts").whereField("startTime", isLessThan: Date())
          itemRef.getDocuments{ (snapshot, error) in
          
            if error == nil && snapshot != nil {
                print("snapshot successfylly taken!")
                  for document in snapshot!.documents {
                     
                    let datat = TimePost(snapshot: document)
                    self.testArray.append(datat)
                    self.docID.append(document.documentID)
                
                }
                self.performSegue(withIdentifier: "toTableview", sender: self)
           
            }
        }
      }
    //ladda ner starttid från firestore
    func getFromFirestore() {
        auth = Auth.auth()
        let db = Firestore.firestore()
        
        guard let user = auth.currentUser else { return }
        let itemRef = db.collection("users").document(user.uid).collection("tidpunkt").document("tid")
        
        itemRef.getDocument { (document, error) in
            if error == nil{
                
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let ts = documentData!["tidpunkt"] as! Timestamp
                    self.startTime = ts.dateValue()
                    print("Document succefully read: \(self.startTime!)")
                   
                }
            }
        }
    }
}
