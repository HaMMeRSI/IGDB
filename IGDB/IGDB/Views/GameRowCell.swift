import UIKit

class GameRowCell: UITableViewCell {
    
    @IBOutlet weak var GameID: UILabel!
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
