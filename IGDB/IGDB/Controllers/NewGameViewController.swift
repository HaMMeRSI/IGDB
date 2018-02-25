import UIKit

class NewGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var GameName: UITextField!
    @IBOutlet weak var GameGenre: UITextField!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UITextField!
    @IBOutlet weak var GamePicture: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let model: FireBaseModel = FireBaseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        // Do any additional setup after loading the view.
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
        
        let key: String! = model.getAutoKey(table: "Games")
        
        let newGame: Game = Game(id:key,
                                 name:self.GameName.text!,
                                 description:self.GameDescription.text!,
                                 score:Int(self.GameScore.text!)!,
                                 genre: self.GameGenre.text!);
        
        model.addItemToTable(table: "Games", key: key, value: newGame.toJson())

        model.saveImageToFirebase(image:self.GamePicture.image!, name: key ,callback: { (url) in
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.performSegue(withIdentifier: "unwinedFromNew", sender: self)
        })
    }
}
