import UIKit

class NewGameViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var GameName: UITextField!
    @IBOutlet weak var GameGenre: UITextField!
    @IBOutlet weak var GameDescription: UITextView!
    @IBOutlet weak var GameScore: UITextField!
    @IBOutlet weak var GamePicture: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        
        self.GameScore.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isStrictSuperset(of: characterSet)
    }
    
    @IBAction func imageClick(recognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            })
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        self.GamePicture.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGame(sender: UIButton) {
        
        if GameName.text == "" || GameGenre.text == "" || GameScore.text == ""
            || GamePicture.image == nil || GameDescription.text == "" {
            
            let alert = UIAlertController(title: "Incorrect form",
                                          message: "Make sure all fields are full",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let score = Int(GameScore.text!)!
        if score < 0 || score > 100 {
            let alert = UIAlertController(title: "Incorrect score",
                                          message: "score has to be between 0 and 100",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        let key: String! = model.getAutoKey(table: "Games")
        
        let newGame: Game = Game(id:key,
                                 name:self.GameName.text!,
                                 description:self.GameDescription.text!,
                                 score: score,
                                 genre: self.GameGenre.text!);

        model.saveImageToFirebase(image:self.GamePicture.image!, name: key ,callback: { (url) in
            self.model.addItemToTable(table: "Games", key: key, value: newGame.toJson())
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.performSegue(withIdentifier: "unwinedFromNew", sender: self)
        })
    }
}
