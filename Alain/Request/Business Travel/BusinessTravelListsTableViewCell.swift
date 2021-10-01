//
//  BusinessTravelListsTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/13/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class BusinessTravelListsTableViewCell: UITableViewCell {

    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var DestinationLbl: UILabel!
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
