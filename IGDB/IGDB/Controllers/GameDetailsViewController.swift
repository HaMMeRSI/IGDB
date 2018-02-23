import UIKit

class GameDetailsViewController: UIViewController {
    var gameNameText:String?{
        didSet{
            if let gameNameText = gameNameText {
                if (gameName != nil){
                    gameName.text = gameNameText
                }
            }
        }
    }
    
    @IBOutlet weak var GameID: UILabel!
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gameNameText = gameNameText{
            gameName.text = gameNameText
        }        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
