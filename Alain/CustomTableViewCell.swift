//
//  CustomTableViewCell.swift
//  Alain
//
//  Created by MicroExcel on 5/19/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material

class CustomTableViewCell: UITableViewCell {

    //Reim
    @IBOutlet weak var ReimUploadBtn: UIButton!
    @IBOutlet weak var ReimAppToDateBTn: UIButton!
    @IBOutlet weak var ReimAppFromDateBTn: UIButton!
    @IBOutlet weak var ReimpaticBtn: UIButton!
    @IBOutlet weak var remarksTF: TextField!
     @IBOutlet weak var appToDateTF: TextField!
     @IBOutlet weak var appFromDateTF: TextField!
     @IBOutlet weak var balanceTF: TextField!
     @IBOutlet weak var eligibilityTF: TextField!
     @IBOutlet weak var amountTF: TextField!
     @IBOutlet weak var paticularTF: TextField!
    
    @IBOutlet weak var frUploadFileView: UIView!
    @IBOutlet weak var frRemoveBtn: UIButton!
    @IBOutlet weak var uploadFileView: UIView!

    @IBOutlet weak var formalityUploadBtn: UIButton!
    @IBOutlet weak var formalityPurposeTF: TextField!
    @IBOutlet weak var formalityPurposeBtn: UIButton!
    @IBOutlet weak var formalityDetailsReqTF: TextField!
    @IBOutlet weak var formalityDetailsReqBtn: UIButton!
    @IBOutlet weak var formalityPaticularBtn: UIButton!
    @IBOutlet weak var formalityPaticularTF: TextField!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var sideMenuTxtLbl: UILabel!
    @IBOutlet weak var sideMenuIcon: UIImageView!
    @IBOutlet weak var approvalBtn: UIButton!
    @IBOutlet weak var responseLbl: UILabel!
    @IBOutlet weak var reqTypeLbl: UILabel!
    @IBOutlet weak var reqNameLbl: UILabel!
    @IBOutlet weak var uploadTimePathNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
