//
//  TableViewShowData.swift
//  Konsultappen
//
//  Created by Andreas Svedstedt on 2020-02-12.
//  Copyright © 2020 Andreas Svedstedt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class TableViewShowData: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var minArray : [SparadDag]!
    var minSArray : [String]!
    var auth : Auth!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return minSArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = minSArray[indexPath.row]
        //print (minSArray[indexPath.row])
         return (cell)
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
