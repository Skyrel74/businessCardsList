import Foundation

typealias JSON = [String : Any]

enum API {
    
    static var identifier: String { return "GroupNapoleon-IT2"}
    static var baseURL: String { return "https://ios-napoleonit.firebaseio.com/data/\(identifier)/" }
    
    static func createCard(name: String, description: String, complition: @escaping (Bool) -> Void){
        let params = [
            "name": name,
            "description": description,
            ]
        let url = URL(string: baseURL + "/notes.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) {
            data,response,
            error in
            complition(error == nil)
        }
        task.resume()
        
    }
    static func loadCards(completion: @escaping ([Card]) -> Void) {
        let url = URL(string: baseURL + ".json")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error
            in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    as? JSON
                else{return}
            
            let cardsJSON = json!["notes"] as! JSON
            var cards = [Card]()
            
            for card in cardsJSON{
                cards.append(Card(id: card.key, data: card.value as! JSON))
            }
            
            DispatchQueue.main.async{
                completion(cards)
            }
            
        }
        task.resume()
    }
    
}
