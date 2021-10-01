//
//  DMSListTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/13/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class DMSListTableViewCell: UITableViewCell {
    @IBOutlet weak var RefrenceNumberLbl: UILabel!
       @IBOutlet weak var ProcessNameLbl: UILabel!
       @IBOutlet weak var FileNameLbl: UILabel!
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
