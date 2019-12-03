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
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var name: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveCard(_ sender: Any) {
        let id = "Test"
        let name = self.name.text!
        let descriptiontext = self.descriptionText.text!
        save(id: id, name: name, descriptiontext: descriptiontext)
        
    }
    
    func save(id: String, name: String, descriptiontext: String) {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Visitka", in: managedObjectContext) else { return }
        let visitka = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        visitka.setValue(id, forKey: "id")
        visitka.setValue(name, forKey: "name")
        visitka.setValue(descriptiontext, forKey: "descriptiontext")
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
        
    }

    func delete(_ visitka: NSManagedObject, at indexPath: IndexPath) {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        managedObjectContext.delete(visitka)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
        
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
