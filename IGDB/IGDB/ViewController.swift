import UIKit

class ViewController: UIViewController {
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register() {
        let email = self.emailField.text
        let password = self.passwordField.text
        if email != "" {
            if password != "" {
                if password!.count < 6 {
                    self.openMessageBox(title: "Password too short", message: "has to be more than 6 characters")
                } else {
                    self.spinner.isHidden = false
                    self.spinner.startAnimating()
                    model.registerUser(email: email!, password: password!, callback: { (user) in
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                        if user != nil {
                            self.model.initRefs()
                            self.performSegue(withIdentifier: "loginToApp", sender: self)
                        } else {
                            self.openMessageBox(title: "Failed", message: "registaration failed")
                        }
                    })
                }
            } else {
                self.openMessageBox(title: "Empty password", message: "password can't be empty")
            }
        } else {
            self.openMessageBox(title: "Empty email", message: "email can't be empty")
        }
    }
    
    @IBAction func signIn() {
        let email = self.emailField.text
        let password = self.passwordField.text
        if email != "" {
            if password != "" {
                self.spinner.isHidden = false
                self.spinner.startAnimating()
                model.signIn(email: email!, password: password!, callback: { (user) in
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    if user != nil {
                        self.model.initRefs()
                        self.performSegue(withIdentifier: "loginToApp", sender: self)
                    } else {
                        self.openMessageBox(title: "Failed", message: "login failed")
                    }
                })
            } else {
                self.openMessageBox(title: "Empty password", message: "password can't be empty")
            }
        } else {
            self.openMessageBox(title: "Empty email", message: "email can't be empty")
        }
    }
    
    func openMessageBox(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

