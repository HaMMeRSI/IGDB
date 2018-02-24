import UIKit

class NewGameViewController: UIViewController {
    
    @IBOutlet weak var GameName: UITextField!
    @IBOutlet weak var GameGenre: UITextField!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UITextField!
    @IBOutlet weak var GameImage: UITextField!
    
    let model: FireBaseModel = FireBaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveGame(sender: UIButton) {
        let key: String! = model.ref?.child("Games").childByAutoId().key
        
        let newGame: Game = Game(id:key,
                                 name:self.GameName.text!,
                                 image:self.GameImage.text!,
                                 description:self.GameDescription.text!,
                                 score:Int(self.GameScore.text!)!,
                                 genre: self.GameGenre.text!);
        
        model.ref?.child("Games").child(key).setValue(newGame.toJson())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelSave(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
