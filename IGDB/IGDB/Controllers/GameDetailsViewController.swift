import UIKit

class GameDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var data: [Comment] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentRowCell = tableView.dequeueReusableCell(withIdentifier: "comment_row_cell", for: indexPath) as! CommentRowCell
        
        let content = data[indexPath.row]
        
        cell.userName.text = content.user
        cell.comment.text = content.text
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let game = game {
            GameName.text = game.name
            GameGenre.text = game.genre
            GameDescription.text = game.description
            GameImage.image = image
            GameScore.text = String(game.score)
            self.gameId = game.id
            
            model.ref!.child("Comments").queryOrdered(
                byChild: "gameId").queryEqual(
                    toValue: gameId!).observe(.childAdded, with: { (snapshot) in
                if let value = snapshot.value as? [String:Any] {
                        let comment = Comment(commentJson: value)
                        self.data.insert(comment, at: 0)
                        self.commentTableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                         with: UITableViewRowAnimation.automatic)

                }
            })
            
            commentTableView.delegate = self
            commentTableView.dataSource = self
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
    
    @IBAction func addComment() {
        let alert = UIAlertController(title: "New Comment", message: "Write your comment", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter comment"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { action in
            let textField = alert.textFields![0] as UITextField
            let key:String! = self.model.getAutoKey(table: "Comments")
            let user:String! = self.model.connectedUser()!.email!
            let comment = Comment(id:key,
                                  gameId: self.gameId!,
                                  text: textField.text!,
                                  user: user)
            self.model.addItemToTable(table: "Comments", key: key, value: comment.toJson())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
