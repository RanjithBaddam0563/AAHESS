//
//  DMSReqApprovalViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/24/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class DMSReqApprovalViewController: UIViewController {

    var ListCount = ["1"]

    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationController?.navigationBar.tintColor = UIColor.white

      let logo = UIImage(named: "logo1")
      let imageView = UIImageView(image:logo)
      imageView.contentMode = .scaleAspectFit
      imageView.setImageColor(color: UIColor.white)
      self.navigationItem.titleView = imageView
        self.TBV.layer.borderWidth = 1.2
        self.TBV.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    

    @IBAction func ClickOnSubmitBtn(_ sender: Any)
    {
        if #available(iOS 13.0, *) {
          let vc = self.storyboard?.instantiateViewController(identifier: "reimbursementReqViewController")as! reimbursementReqViewController
          self.navigationController?.pushViewController(vc, animated: true)

        } else {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "reimbursementReqViewController")as! reimbursementReqViewController
          self.navigationController?.pushViewController(vc, animated: true)
          
      }
       
    }

}
extension DMSReqApprovalViewController : UITableViewDataSource,UITableViewDelegate
   {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if ListCount.count == 0
           {
               return 0
           }else{
               return ListCount.count
           }
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = self.TBV.dequeueReusableCell(withIdentifier: "CustomTableViewCell44")as!CustomTableViewCell
           

           return cell
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.TBV.frame.size.height/2.6
       }
       func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
   }
