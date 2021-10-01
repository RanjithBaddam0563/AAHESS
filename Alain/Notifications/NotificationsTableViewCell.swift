//
//  NotificationsTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 8/1/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var NotiCustomView: CustomView!
    @IBOutlet weak var NotificationDeleteBtn: UIButton!
    @IBOutlet weak var NotificationTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
