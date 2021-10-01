//
//  MyDMSReqViewTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 7/14/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class MyDMSReqViewTableViewCell: UITableViewCell {
    @IBOutlet weak var ApproverNameLbl : UILabel!
    @IBOutlet weak var ApprovalLbl: UILabel!
    @IBOutlet weak var DateTimeLbl: UILabel!
    @IBOutlet weak var CommentsLbl: UILabel!
    @IBOutlet weak var signatureImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
