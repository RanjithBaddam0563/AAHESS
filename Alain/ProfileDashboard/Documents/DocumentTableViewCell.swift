//
//  DocumentTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/9/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var salarySlipAction: UIButton!
    @IBOutlet weak var salarySlipYearLbl: UILabel!
    @IBOutlet weak var salarySlipMonthLbl: UILabel!
    @IBOutlet weak var DocumentDeleteBtn: UIButton!
    @IBOutlet weak var DocumentNameLbl: UILabel!
    @IBOutlet weak var DocumentDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
