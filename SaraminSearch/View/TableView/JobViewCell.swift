//
//  JobViewCell.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import UIKit

class JobViewCell: UITableViewCell {

//    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
