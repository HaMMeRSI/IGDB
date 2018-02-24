import Foundation

class Game {

    var id: String
    var name: String
    var image: String
    var description: String
    var score: Int
    var genre: String

    init() {
        id = "1"
        name = "aaa"
        image = "home"
        description = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        score = 50
        genre = "action"
    }
    
    init(id:String, name:String, image:String, description:String, score:Int, genre:String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.score = score
        self.genre = genre
    }
    
    init(gameJson:[String:Any]) {
        self.id = gameJson["id"] as! String
        self.name = gameJson["name"] as! String
        self.image = gameJson["image"] as! String
        self.description = gameJson["description"] as! String
        self.score = gameJson["score"] as! Int
        self.genre = gameJson["genre"] as! String
    }
    
    func toJson() -> [String:Any] {
        var gameJson = [String:Any]()
        gameJson["id"] = self.id
        gameJson["name"] = self.name
        gameJson["image"] = self.image
        gameJson["description"] = self.description
        gameJson["score"] = self.score
        gameJson["genre"] = self.genre
        
        return gameJson
    }
}

