//
//  CommentRowCell.swift
//  IGDB
//
//  Created by Nitzan Braham on 26/02/2018.
//  Copyright © 2018 Nitzan Braham. All rights reserved.
//

import UIKit

class CommentRowCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var comment: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
