//
//  CardViewController.swift
//  Business Cards List
//
//  Created by MacBook Pro on 09.12.2019.
//  Copyright © 2019 Ilya. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController {
    var card: NSManagedObject? = nil
    var isDeleted: Bool = false
    var indexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageString = card?.value(forKey: "imageString") as! String
        let imageData = NSData(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data
        let imageCell: UIImage = UIImage(data: imageData)!
        imageCard.image = imageCell
        imageCard.contentMode = .scaleAspectFit
        print(card?.value(forKey: "name") as! String)
        nameLabel.text = card?.value(forKey:"name") as? String
        descriptionTextLabel.text = card?.value(forKey:"descriptionText") as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var imageCard: UIImageView!
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToCardList", sender: self)
    }
    
    
    @IBAction func deleteCard(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToCardList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCard" {
            guard let viewController = segue.destination as? AddViewController else { return }
            viewController.titleText = "Изменить Визитку"
            viewController.addPhotoText = "Изменить Фото"
            viewController.card = card
            viewController.indexPathForCard = self.indexPath!
        }
    }
    
    //test
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
