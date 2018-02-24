import UIKit

class GameTableViewController: UITableViewController {
    
    let data: [Game] = [Game()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
