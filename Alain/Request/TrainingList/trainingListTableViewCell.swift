//
//  trainingListTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 10/6/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class trainingListTableViewCell: UITableViewCell {

    @IBOutlet var viewBtn: UIButton!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var trainingNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
