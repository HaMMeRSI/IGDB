import UIKit

class GameTableViewController: UITableViewController {
    
    var data: [Game] = []
    let model: FireBaseModel = FireBaseModel()
    @IBOutlet var tableInfoGames: UITableView!
    @IBOutlet weak var newBarButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        self.tableInfoGames.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newBarButton.isEnabled = true
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        model.ref?.child("Games").observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]] {
                var gamesArray = [Game]()
                for stJson in values {
                    let game = Game(gameJson: stJson.value)
                    gamesArray.insert(game, at: 0)
                }
                self.data = gamesArray
                self.tableInfoGames.reloadData()
            }
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GameRowCell = tableView.dequeueReusableCell(withIdentifier: "game_row_cell", for: indexPath) as! GameRowCell

        let content = data[indexPath.row]

        cell.GameName.text = content.name
        cell.GameScore.text = String(content.score)
        cell.GameImage.image = UIImage(named: content.image)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.newBarButton.isEnabled = false
        if (segue.identifier == "showDetails"){
            let gameViewController:GameDetailsViewController = segue.destination as! GameDetailsViewController
            let content = data[selctedRow!];
            gameViewController.game = content
        }
    }
    
    var selctedRow:Int?
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func unwinedFromNew(segue: UIStoryboardSegue) {
//        self.newBarButton.isEnabled = true
    }
}
