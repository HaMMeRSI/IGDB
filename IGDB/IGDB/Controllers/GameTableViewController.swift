import UIKit

class GameTableViewController: UITableViewController {
    
    var data: [Game] = []
    var imageData: [String:UIImage] = [:]
    let model: FireBaseModel = FireBaseModel.getInstance()
    let numberOfRecentGames:UInt = 20
    
    @IBOutlet var tableInfoGames: UITableView!
    @IBOutlet weak var newBarButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newBarButton.isEnabled = true
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
        cell.GameImage.image = self.imageData[content.id]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.newBarButton.isEnabled = false
        if (segue.identifier == "showDetails"){
            let gameViewController:GameDetailsViewController = segue.destination as! GameDetailsViewController
            let content = data[selctedRow!];
            gameViewController.game = content
            gameViewController.image = self.imageData[content.id]
        }
    }
    
    var selctedRow:Int?
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row \(indexPath.row) was selected")
        selctedRow = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func unwinedToGameTable(segue: UIStoryboardSegue) {
        
    }
    
    private func addObservers() {
        model.ref!.child("Games").queryLimited(toLast: numberOfRecentGames).observe(.childAdded, with: { (snapshot) in
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            if let value = snapshot.value as? [String:Any] {
                let game = Game(gameJson: value)
                self.model.downloadImage(name: game.id, callback: {(image) in
                    self.imageData[game.id] = image
                    self.data.insert(game, at: 0)
                    self.tableInfoGames.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                   with: UITableViewRowAnimation.automatic)
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                })
            }
        })
        
        model.ref!.child("Games").queryLimited(toLast: numberOfRecentGames).observe(.childRemoved, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                let game = Game(gameJson: value)
                if self.imageData.keys.contains(game.id) {
                    self.imageData.removeValue(forKey: game.id)
                }
                
                let index = self.data.index(where: { (curr) -> Bool in
                    return curr.id == game.id
                })

                if index != nil {
                    self.data.remove(at: index!)
                    self.tableInfoGames.deleteRows(at: [IndexPath(row: index!, section: 0)],
                                                   with: UITableViewRowAnimation.automatic)
                }
            }
        })
        
        model.ref!.child("Games").queryLimited(toLast: numberOfRecentGames).observe(.childChanged, with: { (snapshot) in
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            if let value = snapshot.value as? [String:Any] {
                let game = Game(gameJson: value)
                self.model.downloadImage(name: game.id, callback: {(image) in
                    let index = self.data.index(where: { (curr) -> Bool in
                        return curr.id == game.id
                    })
                    
                    if index != nil {
                        self.imageData[game.id] = image
                        self.data[index!] = game
                        self.tableInfoGames.reloadRows(at: [IndexPath(row: index!, section: 0)],
                                                       with: UITableViewRowAnimation.automatic)
                    }
                    
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                })
            }
        })
    }
}
