//
//  formalityListTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/21/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class formalityListTableViewCell: UITableViewCell {

       @IBOutlet weak var formalityTypeLbl: UILabel!
       @IBOutlet weak var ViewBtn: UIButton!
       @IBOutlet weak var StatusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
