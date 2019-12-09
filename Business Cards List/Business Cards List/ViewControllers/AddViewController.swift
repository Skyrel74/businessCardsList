//
//  AddViewController.swift
//  Business Cards List
//
//  Created by MacBook Pro on 02.12.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class AddViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var name: UITextField!
    
    var titleText = "Добавить Визитку"
    var card: NSManagedObject? = nil
    var indexPathForCard: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        if let card = self.card {
            name.text = card.value(forKey: "name") as? String
            descriptionText.text = card.value(forKey: "descriptionText") as? String
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveAndClose(_ sender: Any) {
        performSegue(withIdentifier: "unwindToCardList", sender: self)
    }
    
    @IBAction func close(_ sender: Any) {
        name.text = nil
        descriptionText.text = nil
        performSegue(withIdentifier: "unwindToCardList", sender: self)
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
