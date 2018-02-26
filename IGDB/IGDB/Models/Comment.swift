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
    
    init(commentJson:[String:Any]) {
        self.id = commentJson["id"] as! String
        self.gameId = commentJson["gameId"] as! String
        self.text = commentJson["text"] as! String
        self.user = commentJson["user"] as! String
    }
    
    func toJson() -> [String:Any] {
        var commentJson = [String:Any]()
        commentJson["id"] = self.id
        commentJson["gameId"] = self.gameId
        commentJson["text"] = self.text
        commentJson["user"] = self.user
        
        return commentJson
    }
}


