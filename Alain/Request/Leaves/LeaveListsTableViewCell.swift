//
//  LeaveListsTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/12/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class LeaveListsTableViewCell: UITableViewCell {

    @IBOutlet weak var ViewBtn: UIButton!
    @IBOutlet weak var StatusLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var leave: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
