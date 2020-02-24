//
//  AvslutaResa.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-01-22.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

class AvslutaResa: UIViewController,CLLocationManagerDelegate {
    
    var auth: Auth!
    var startTime : Date?
    var endTime : Date?
    var index : Int = -1
    var manager: CLLocationManager?
    var Locations : [CLLocation] = []
    var totalDistance : Double = 0.0
    var firstLocation : CLLocation?
    var lastLocation : CLLocation?
    
    @IBOutlet weak var resaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        //manager?.distanceFilter = 50
    }
    
    @IBAction func frammePressed(_ sender: UIButton) {
        manager?.stopUpdatingLocation()
        getFromFirestore()
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        createFirestoreTimePostObject()
        startTime = Date()
           auth = Auth.auth()
           let db = Firestore.firestore()
           guard let user = auth.currentUser else { return }
           db.collection("users").document(user.uid).collection("tidpunkt").document("tid").setData(["tidpunkt" : startTime!])
           { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document 'tidpunkt' successfully written!")
               }
           }
           db.collection("users").document(user.uid).collection("tidpunkt").document("from").setData(["from" : "DagenIgang"])
           { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
    }
    
    func createFirestoreTimePostObject(){
        endTime = Date()
        auth = Auth.auth()
        guard let user = auth.currentUser else { return }
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document(user.uid).collection("timeposts")
        
        let post = TimePost(startTime: startTime!, endTime: endTime!,namn: "Ditresa", milersattning: totalDistance)
        
        itemRef.addDocument(data: post.toDict()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Timepost document added to cloud!")
                print(post)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            
            Locations.append(locations.last!)
            index += 1
            if index == 0 {
            firstLocation = Locations[index]
            }
            else {
            firstLocation = Locations[index-1]
            lastLocation = Locations[index]
           
            let  distanceBetweenLocations =  lastLocation!.distance(from: firstLocation!)
            totalDistance += distanceBetweenLocations
                
                resaLabel.text = ("mil: \(String(format: "%.2f", totalDistance/10000))")
            }
        }
        
    }
 
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
                    self.performSegue(withIdentifier: "toDagenIgang", sender: self)
                }
            }
        }
    }    
}
