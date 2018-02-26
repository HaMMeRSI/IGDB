import UIKit

class EditGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var GameName: UITextField!
    @IBOutlet weak var GameGenre: UITextField!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UITextField!
    @IBOutlet weak var GamePicture: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    var game:Game? {
        didSet {
            if let game = game {
                if self.GameName != nil {
                    self.GameName.text = game.name
                }
                
                if self.GameName != nil {
                    self.GameGenre.text = game.genre
                }
                
                if self.GameName != nil {
                    self.GameDescription.text = game.description
                }
                
                if self.GameName != nil {
                    self.GameScore.text = String(game.score)
                }
            }
        }
    }
    
    var image:UIImage? {
        didSet {
            if let image = image {
                if (GamePicture != nil){
                    GamePicture.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        if let game = game {
            GameName.text = game.name
            GameGenre.text = game.genre
            GameDescription.text = game.description
            GamePicture.image = image
            GameScore.text = String(game.score)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageClick(recognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        self.GamePicture.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGame(sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let key = self.game!.id
        let editedGame: Game = Game(id:key,
                                 name:self.GameName.text!,
                                 description:self.GameDescription.text!,
                                 score:Int(self.GameScore.text!)!,
                                 genre: self.GameGenre.text!);
        
        model.addItemToTable(table: "Games", key: key, value: editedGame.toJson())
        
        model.saveImageToFirebase(image:self.GamePicture.image!, name: key ,callback: { (url) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.performSegue(withIdentifier: "unwinedFromNew", sender: self)
        })
    }
}

