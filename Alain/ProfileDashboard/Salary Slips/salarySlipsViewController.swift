//
//  salarySlipsViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/9/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON


class salarySlipsViewController: UIViewController {
    var salarySlipId : String = ""
    var salarySlipsDetails : [SalarySlipModel] = []

    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchSalarySlipInfoDetails()
        // Do any additional setup after loading the view.
    }
   

    struct Connectivity {
           static let sharedInstance = NetworkReachabilityManager()!
           static var isConnectedToInternet:Bool {
               return self.sharedInstance.isReachable
           }
       }
       func FetchSalarySlipInfoDetails()
       {
        self.salarySlipsDetails.removeAll()
               if Connectivity.isConnectedToInternet {
                   DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self.view, animated: true)
                   }
                   let userId = UserDefaults.standard.integer(forKey: "employeeId")
                   let par = MyStrings().SalarySlipsInfo
                   let params = par + "/" + String(userId)
                   print(params)
                   let token =  UserDefaults.standard.string(forKey: "Token")!
                   var request = URLRequest(url: URL(string: params)!,timeoutInterval: Double.infinity)
                  request.addValue(token, forHTTPHeaderField: "Authorization")

                  request.httpMethod = "GET"

                  let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   DispatchQueue.main.async {
                   MBProgressHUD.hide(for: self.view, animated: true)
                   }
                    if error?.localizedDescription == "The request timed out."
                    {
                       DispatchQueue.main.async {
                        let alert = UIAlertController(title: "My alert", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            (result : UIAlertAction) -> Void in
                        }))
                        self.present(alert, animated: true, completion: nil)
                       }
                    }
                    guard let data = data else {
                      print(String(describing: error))
                      return
                    }
                    print(String(data: data, encoding: .utf8)!)
                   let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                   print(json)
                    for (index,subJson):(String, JSON) in json {
                        print(index)
                        print(subJson)
                        let details = SalarySlipModel.init(json: subJson)
                        self.salarySlipsDetails.append(details)
                    }
                   DispatchQueue.main.async {
                    self.TBV.dataSource = self
                    self.TBV.delegate = self
                    self.TBV.reloadData()
                       
                   }
                  
                  }

                  task.resume()
                   
               
                   }else{
                           DispatchQueue.main.async {

                                let alert = UIAlertController(title: "My alert", message: "Internet not available, Cross check your internet connectivity and try again", preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                    (result : UIAlertAction) -> Void in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                   }
           }
    @objc func salarySlipAction(sender: UIButton!)
    {
     self.salarySlipId = String(self.salarySlipsDetails[sender.tag].salarySlipId)
     
         if #available(iOS 13.0, *) {
          let vc = self.storyboard?.instantiateViewController(identifier: "webViewViewController")as! webViewViewController
            vc.navTitle = "Salary Slip"
            vc.salarySlipId = self.salarySlipId
          self.navigationController?.pushViewController(vc, animated: true)

          } else {
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "webViewViewController")as! webViewViewController
            vc.navTitle = "Salary Slip"
            vc.salarySlipId = self.salarySlipId
              self.navigationController?.pushViewController(vc, animated: true)

         }
     
    }

}
extension salarySlipsViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if salarySlipsDetails.count == 0
        {
        return 0
        }else{
           return salarySlipsDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TBV.dequeueReusableCell(withIdentifier: "SalarySlipsTableViewCell")as! DocumentTableViewCell
        
        let m = self.salarySlipsDetails[indexPath.row].month
        let monthName = DateFormatter().monthSymbols[m - 1]
        cell.salarySlipMonthLbl.text = monthName
        cell.salarySlipYearLbl.text = self.salarySlipsDetails[indexPath.row].year
        cell.salarySlipAction.tag = indexPath.row
        cell.salarySlipAction.addTarget(self, action: #selector(self.salarySlipAction), for: .touchUpInside)

        

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
