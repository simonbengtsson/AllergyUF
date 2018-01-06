//
//  AllergyCell.swift
//  Allergy
//
//  Created by Tim Johansson on 2018-01-06.
//  Copyright © 2018 Tim Johansson. All rights reserved.
//

import UIKit

class AllergyCell: UITableViewCell {

    @IBOutlet weak var allergyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
