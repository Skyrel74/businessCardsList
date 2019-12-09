import Foundation

typealias JSON = [String : Any]

enum API {
    
    static var identifier: String { return "GroupNapoleon-IT2"}
    static var baseURL: String { return "https://ios-napoleonit.firebaseio.com/data/\(identifier)/" }
    
    static func createCard(idCard: String, name: String, description: String, complition: @escaping (Bool) -> Void){
        let params = [
            "idCard": idCard,
            "name": name,
            "description": description,
            ]
        let url = URL(string: baseURL + "/cards/\(idCard)/.json")!
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
    
    static func editCard(idCard: String, name: String, description: String, completion: @escaping (Bool) -> Void) {
        let params = [
            "idCard": idCard,
            "name": name,
            "description": description,
        ]
        
        let url = URL(string: baseURL + "/cards/\(idCard)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
    
    static func deleteCard(idCard: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/cards/\(idCard)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
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
            
            let cardsJSON = json!["cards"] as! JSON
            var cards = [Card]()
            
            for card in cardsJSON{
                cards.append(Card(data: card.value as! JSON))
            }
            
            DispatchQueue.main.async{
                completion(cards)
            }
            
        }
        task.resume()
    }
    
}
