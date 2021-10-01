//
//  sideMenuViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/19/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class sideMenuViewController: UIViewController {

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var sidemenuTBV: UITableView!
    var firstlistNames = ["Home","My Profile","DMS","Applications"]
    var firstlistImgNames = ["home","user","user","document"]

    struct cellData {
        var Opened = Bool()
        var title = String()
        var sectionData = [String]()
    }
    var ImageArray = NSArray()
    var tableViewData = [cellData]()

    @IBOutlet weak var LogoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLbl.text = UserDefaults.standard.string(forKey: "firstName")
        let userEmail = UserDefaults.standard.string(forKey: "email")
        if userEmail == "null" {
            self.userEmailLbl.text = ""
        }else{
            self.userEmailLbl.text = userEmail
        }
        tableViewData = [cellData(Opened: false, title: "Home", sectionData: []),
                         cellData(Opened: false, title: "My Profile", sectionData: []),
                         cellData(Opened: false, title: "DMS", sectionData: []),
                         cellData(Opened: false, title: "Applications", sectionData: ["Housing Advance","Allowance/Reimbursement","Formality","Leave","Business Trip","Training","IT Support"])]
        
        ImageArray = ["home","user","dms1","Applications1"]

           DispatchQueue.main.async {
                 self.sidemenuTBV.delegate = self
                 self.sidemenuTBV.dataSource = self
                 self.sidemenuTBV.reloadData()
             }
    }
   
    @IBAction func ClickOnLogout(_ sender: Any)
    {
        let alert = UIAlertController(title: "My alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {
            (result : UIAlertAction) -> Void in
            UserDefaults.standard.removeObject(forKey: "UserName")
            UserDefaults.standard.removeObject(forKey: "NotificationCount")
            UserDefaults.standard.removeObject(forKey: "Password")
            UserDefaults.standard.removeObject(forKey: "Token")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "middleName")
            UserDefaults.standard.removeObject(forKey: "lastName")
            UserDefaults.standard.removeObject(forKey: "employeeId")
            UserDefaults.standard.removeObject(forKey: "userCode")
            UserDefaults.standard.removeObject(forKey: "employeeCategoryId")
            UserDefaults.standard.removeObject(forKey: "jobTitle")
            UserDefaults.standard.removeObject(forKey: "Department")
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "ViewController")as! ViewController

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController

                 self.navigationController?.pushViewController(vc, animated: true)

            }

        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
   
}
extension sideMenuViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableViewData.count == 0
        {
            return 0
        }else{
           return tableViewData.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableViewData[section].Opened == true {
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black
   
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 &&  tableViewData[indexPath.section].Opened == false{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell1") else { return CustomTableViewCell()}
            let imageView: UIImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = UIImage(named:"downarrow")
            imageView.contentMode = .scaleAspectFit
            imageView.transform = imageView.transform.rotated(by: CGFloat(-M_PI_2))
            if indexPath.section == 3 {
                cell.accessoryView = imageView
            }else{
                cell.accessoryView = .none
            }
           
            cell.backgroundColor = UIColor.black
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            cell.textLabel?.text = tableViewData[indexPath.section].title
            let origImage = UIImage.init(named: self.ImageArray[indexPath.section] as! String)
            let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.imageView?.image = (tintedImage)
            cell.imageView?.tintColor = .white
           
            return cell
        }else if indexPath.row == 0 &&  tableViewData[indexPath.section].Opened == true{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell1") else { return CustomTableViewCell()}

            let imageView: UIImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = UIImage(named:"downarrow")
            imageView.contentMode = .scaleAspectFit
            if indexPath.section == 3 {
                cell.accessoryView = imageView
            }else{
                cell.accessoryView = .none
            }
            cell.backgroundColor = UIColor.black
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.imageView?.image = UIImage.init(named: self.ImageArray[indexPath.section] as! String)
            
            return cell
        }else{
                    
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell1") else { return CustomTableViewCell()}
            cell.accessoryView = .none
            cell.backgroundColor = UIColor.black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.imageView?.image = UIImage.init(named: "black-box")
            return cell

                }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            DispatchQueue.main.async {
          
                if #available(iOS 13.0, *) {
                    let vc = self.storyboard?.instantiateViewController(identifier: "NotifiViewController")as! NotifiViewController
                    self.navigationController?.pushViewController(vc, animated: true)

                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotifiViewController")as! NotifiViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
        }else if indexPath.section == 1
        {
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                   let vc = self.storyboard?.instantiateViewController(identifier: "profileDashboardViewController")as! profileDashboardViewController
                   self.navigationController?.pushViewController(vc, animated: true)

               } else {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileDashboardViewController")as! profileDashboardViewController
                   self.navigationController?.pushViewController(vc, animated: true)
                   
               }
            }
        }else if indexPath.section == 2
        {
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                   let vc = self.storyboard?.instantiateViewController(identifier: "dmsReqViewController")as! dmsReqViewController
                   self.navigationController?.pushViewController(vc, animated: true)

               } else {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "dmsReqViewController")as! dmsReqViewController
                   self.navigationController?.pushViewController(vc, animated: true)
                   
               }
            }
        }
        else if indexPath.row == 0 {
            
        if tableViewData[indexPath.section].Opened == true {
            tableViewData[indexPath.section].Opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none) // play Around with this
            
        }else{
            tableViewData[indexPath.section].Opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            print(sections)
            tableView.reloadSections(sections, with: .none) // play Around with this
            
        }
        }else if indexPath.row == 1
        {
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "Allowance_ReqViewController")as! Allowance_ReqViewController
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Allowance_ReqViewController")as! Allowance_ReqViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.row == 2
        {
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "reimbursementReqViewController")as! reimbursementReqViewController
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "reimbursementReqViewController")as! reimbursementReqViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.row == 3
        {
          
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "formalitiesReqViewController")as! formalitiesReqViewController
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "formalitiesReqViewController")as! formalitiesReqViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.row == 4
        {
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "LeaveReqViewController")as! LeaveReqViewController
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaveReqViewController")as! LeaveReqViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.row == 5
        {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "BusinessTravelReqViewController")as! BusinessTravelReqViewController
               self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessTravelReqViewController")as! BusinessTravelReqViewController
                   self.navigationController?.pushViewController(vc, animated: true)
              }
    }else if indexPath.row == 6
        {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "TrainingViewController")as! TrainingViewController
               self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrainingViewController")as! TrainingViewController
                   self.navigationController?.pushViewController(vc, animated: true)
              }
    }else 
        {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "ItSupportViewController")as! ItSupportViewController
               self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItSupportViewController")as! ItSupportViewController
                   self.navigationController?.pushViewController(vc, animated: true)
              }
    }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
        
    }
    
    
}
