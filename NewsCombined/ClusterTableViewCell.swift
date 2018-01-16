//
//  ClusterTableViewCell.swift
//  NewsCombined
//
//  Created by admin on 16/01/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class ClusterTableViewCell: UITableViewCell {

    @IBOutlet weak var clusterImage: UIImageView!
    @IBOutlet weak var clusterTitle: UILabel!
    @IBOutlet weak var clusterCommentCounter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
