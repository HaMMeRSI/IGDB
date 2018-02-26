import Foundation

class Comment {
    
    var id: String
    var gameId: String
    var user:String
    var text: String
    
    init(id:String, gameId:String, text:String, user:String) {
        self.id = id
        self.gameId = gameId
        self.text = text
        self.user = user
    }
    
    init(gameJson:[String:Any]) {
        self.id = gameJson["id"] as! String
        self.gameId = gameJson["gameId"] as! String
        self.text = gameJson["text"] as! String
        self.user = gameJson["user"] as! String
    }
    
    func toJson() -> [String:Any] {
        var gameJson = [String:Any]()
        gameJson["id"] = self.id
        gameJson["gameId"] = self.gameId
        gameJson["text"] = self.text
        gameJson["user"] = self.user
        
        return gameJson
    }
}


