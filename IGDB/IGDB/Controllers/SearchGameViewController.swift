import UIKit

class SearchGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var data: [Game] = []
    var imageData: [String:UIImage] = [:]
    let model: FireBaseModel = FireBaseModel.getInstance()
    
    @IBOutlet var tableInfoGames: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GameRowCell = tableView.dequeueReusableCell(withIdentifier: "game_row_cell", for: indexPath) as! GameRowCell
        
        let content = data[indexPath.row]
        
        cell.GameName.text = content.name
        cell.GameScore.text = String(content.score)
        cell.GameImage.image = self.imageData[content.id]
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSearch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        tableInfoGames.delegate = self
        tableInfoGames.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwinedToSearch(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSearchDetails"){
            let selectedRowPath = self.tableInfoGames.indexPathForSelectedRow!
            let gameViewController:GameDetailsViewController = segue.destination as! GameDetailsViewController
            let content = data[selectedRowPath.row];
            gameViewController.game = content
            gameViewController.image = self.imageData[content.id]
            gameViewController.isFromSearch = true
            self.tableInfoGames.deselectRow(at: selectedRowPath, animated: true)
        }
    }
    
    private func performSearch() {
        if let searchBar = self.searchBar {
            if let text = searchBar.text {
                if text != "" {
                    self.data.removeAll()
                    self.tableInfoGames.reloadData()
                    
                    self.spinner.startAnimating()
                    self.spinner.isHidden = false
                    
                    model.ref!.child("Games").observeSingleEvent(of: .value) { (snapshot) in
                        if let values = snapshot.value as? [String:[String:Any]] {
                            for stJson in values {
                                let game = Game(gameJson: stJson.value)
                                
                                if game.name.contains(self.searchBar.text!) {
                                    self.model.downloadImage(name: game.id, callback: {(image) in
                                        self.imageData[game.id] = image
                                        self.data.insert(game, at: 0)
                                        self.tableInfoGames.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                       with: UITableViewRowAnimation.automatic)
                                        
                                        self.spinner.stopAnimating()
                                        self.spinner.isHidden = true
                                    })
                                } else {
                                    self.spinner.stopAnimating()
                                    self.spinner.isHidden = true
                                }
                            }
                        } else {
                            self.spinner.stopAnimating()
                            self.spinner.isHidden = true
                        }
                    }
                }
            }
        }
    }
}
