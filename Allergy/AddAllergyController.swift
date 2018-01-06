//
//  AddAllergyController.swift
//  Allergy
//
//  Created by Tim Johansson on 2018-01-06.
//  Copyright © 2018 Tim Johansson. All rights reserved.
//

import UIKit

class AddAllergyController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var allergyList = [String]()
    let defaults = UserDefaults.standard
    let allergyListKey = "allergyListKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let tempallergyList = defaults.object(forKey: allergyListKey) {
            allergyList = tempallergyList as! [String]
        }
    }

    @IBAction func addAllergyToList(_ sender: Any) {
        if let text = textField.text {
            if text != "" {
                allergyList.append(text)
                defaults.set(allergyList, forKey: allergyListKey)
                textField.text?.removeAll()
                tableView.reloadData()
            }
        }
        textField.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergyList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllergyCell", for: indexPath) as! AllergyCell
        cell.allergyName.text = allergyList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.allergyList.remove(at: indexPath.row)
            defaults.set(allergyList, forKey: allergyListKey)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
