//
//  ViewController.swift
//  Business Cards List
//
//  Created by Ilya on 30.11.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var vc = ViewController()

class ViewController: UIViewController, UITextFieldDelegate {

 
    @IBOutlet weak var tableView: UITableView!
    
    var coreImage: UIImage? = nil
    var cardsCore: [NSManagedObject] = []
    
    private var cards = [Card]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearData()
        downloadCards() { [weak self] in
            self?.fetch()
            self?.tableView.reloadData()
        }
//        print(cards)
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
//--------> CoreDataManager
    func fetch() {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Visitka")
        
        do {
            try managedObjectContext.save()
            cardsCore = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        
    }
    
    func downloadCards(completion: @escaping () -> Void) {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        API.loadCards { cardsArray in
            self.cards = cardsArray
            for cardEntity in cardsArray {
                guard let entity = NSEntityDescription.entity(forEntityName:"Visitka", in: managedObjectContext) else { return }
                let card = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                card.setValue(cardEntity.idCard, forKey: "idCard")
                card.setValue(cardEntity.name, forKey: "name")
                card.setValue(cardEntity.description, forKey: "descriptionText")
                card.setValue(cardEntity.imageString, forKey: "imageString")
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Couldn't save. \(error)")
                }
            }
            
            completion()
        }
        
    }
    
    func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Visitka.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    
    func save(imageString: String, name: String, description: String) {
        let uuid = UUID().uuidString
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Visitka", in: managedObjectContext) else { return }
        let card = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        card.setValue(name, forKey: "name")
        card.setValue(description, forKey: "descriptionText")
        card.setValue(uuid, forKey: "idCard")
        card.setValue(imageString, forKey: "imageString")
        do {
            try managedObjectContext.save()
            self.cardsCore.append(card)
            API.createCard(idCard: uuid, name: name, description: description, imageString: imageString) { result in
                guard result else { return }
            }
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    func update(indexPath: IndexPath, name: String, description: String, imageString: String) {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let card = cardsCore[indexPath.row]
        guard let idCard = card.value(forKey: "idCard") as? String else { return }
        card.setValue(name, forKey:"name")
        card.setValue(description, forKey: "descriptionText")
        card.setValue(imageString, forKey: "imageString")
        do {
            try managedObjectContext.save()
            cardsCore[indexPath.row] = card
            API.editCard(idCard: idCard, name: name, description: description, imageString: imageString) { result in
                guard result else { return }
            }
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }
    
    func delete(_ card: NSManagedObject, at indexPath: IndexPath) {
        let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        guard let idCard = card.value(forKey: "idCard") as? String else { return }
        managedObjectContext.delete(card)
        cardsCore.remove(at: indexPath.row)
        do {
            try managedObjectContext.save()
            API.deleteCard(idCard: idCard) { result in
                guard result else { return }
            }
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
        
    }

//-------> end CoreDataManager
    
    @IBAction func unwindToCardList(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? AddViewController {
            guard let name: String = viewController.name.text, let description: String = viewController.descriptionText.text, let imageString: String = viewController.imageStringData else { return }
            if name != "" && description != "" && imageString != "" {
                if let indexPath = viewController.indexPathForCard {
                    update(indexPath: indexPath, name: name, description: description, imageString: imageString)
                } else {
                    save(imageString: imageString, name: name, description: description)
                }
            }
            tableView.reloadData()
        } else if let viewController = segue.source as? CardViewController {
            if viewController.isDeleted {
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                let card = cardsCore[indexPath.row]
                delete(card, at: indexPath)
                tableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardDetail" {
            guard let navViewController = segue.destination as? UINavigationController else { return }
            guard let viewController = navViewController.topViewController as? CardViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let card = cardsCore[indexPath.row]
            viewController.card = card
            viewController.indexPath = indexPath
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cardsCore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
//        cell.setup(with: cards[indexPath.row])
        let card = cardsCore[indexPath.row]
        let imageString = card.value(forKey: "imageString") as! String
        let imageData = NSData(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data
        let imageCell: UIImage = UIImage(data: imageData)!
        cell.imageView?.image = imageCell
        cell.contentMode = .scaleAspectFill
        coreImage = imageCell
        cell.textLabel?.text = card.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
