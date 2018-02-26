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
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    var gameId:String?
    
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var GameGenre: UILabel!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var editGameButtonItem: UIBarButtonItem!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.editGameButtonItem.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.editGameButtonItem.isEnabled = false
        if (segue.identifier == "editGame"){
            let editGameViewController:EditGameViewController = segue.destination as! EditGameViewController
            editGameViewController.game = game
            editGameViewController.image = GameImage.image
        }
    }
    
    @IBAction func deleteGame() {
        let alert = UIAlertController(title: "Delete Game", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { action in
            self.model.removeItemFromTable(table: "Games", key: self.gameId!)
            self.performSegue(withIdentifier: "unwindFromDetails", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
