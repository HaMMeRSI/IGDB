import UIKit

class GameDetailsViewController: UIViewController {
    var game:Game? {
        didSet {
            if let game = game {
                if (GameName != nil){
                    GameName.text = game.name
                }
                
                if (GameGenre != nil){
                    GameGenre.text = game.genre
                }
                
                if (GameDescription != nil){
                    GameDescription.text = game.description
                }
                
                if (GameScore != nil){
                    GameScore.text = String(game.score)
                }
            }
        }
    }
    
    var image:UIImage? {
        didSet {
            if let image = image {
                if (GameImage != nil){
                    GameImage.image = image
                }
            }
        }
    }
    
    let model: FireBaseModel = FireBaseModel()
    var gameId:String?
    
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var GameGenre: UILabel!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let game = game {
            GameName.text = game.name
            GameGenre.text = game.genre
            GameDescription.text = game.description
            GameImage.image = image
            GameScore.text = String(game.score)
            self.gameId = game.id
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func deleteGame() {
        model.removeItemFromTable(table: "Games", key: self.gameId!)
        performSegue(withIdentifier: "unwindFromDetails", sender: nil)
    }
}
