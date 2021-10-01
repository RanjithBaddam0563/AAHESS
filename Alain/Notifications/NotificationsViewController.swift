//
//  NotificationsViewController.swift
//  Alain
//
//  Created by MicroExcel on 8/1/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class NotificationsViewController: UIViewController {
    var NotificationsListDetails : [NotificationsListModel] = []

    var ResponseID : String = ""
    
    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        NotificationHistory()
        // Do any additional setup after loading the view.
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    

    func NotificationHistory()
    {
                self.NotificationsListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().NotificationsAlerts
                    let token =  UserDefaults.standard.string(forKey: "Token")!
                    var request = URLRequest(url: URL(string: par)!,timeoutInterval: Double.infinity)
                   request.addValue(token, forHTTPHeaderField: "Authorization")
                   request.httpMethod = "GET"
                   let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    }
                     guard let data = data else {
                       print(String(describing: error))
                        let alert = UIAlertController(title: "My alert", message: (String(describing: error)), preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            (result : UIAlertAction) -> Void in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                       return
                     }
                     
                     print(String(data: data, encoding: .utf8)!)
                     let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                     print(json)
                    if json.count == 0
                    {
                       let alert = UIAlertController(title: "My alert", message: "Notification list empty", preferredStyle: UIAlertController.Style.alert)

                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                           (result : UIAlertAction) -> Void in
                       }))
                       self.present(alert, animated: true, completion: nil)
                       
                      return
                    }else{
                   for (index,subJson):(String, JSON) in json {
                      print(index)
                      print(subJson)
                      let details1 = NotificationsListModel.init(json: subJson)
                      self.NotificationsListDetails.append(details1)
                   }
                    print(self.NotificationsListDetails)
                    DispatchQueue.main.async {
                     self.TBV.dataSource = self
                     self.TBV.delegate = self
                     self.TBV.reloadData()
                        
                    }
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
    @objc func NotificationDeleteBtnAction(sender: UIButton!)
    {
        if Connectivity.isConnectedToInternet {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
//        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "  {\n        \"alertId\": \(self.NotificationsListDetails[sender.tag].alertId),\n        \"created\": \"\(self.NotificationsListDetails[sender.tag].created)\",\n        \"category\": \"\(self.NotificationsListDetails[sender.tag].category)\",\n        \"text\": \"\(self.NotificationsListDetails[sender.tag].text)\",\n        \"read\": \(self.NotificationsListDetails[sender.tag].read),\n        \"detailsLink\": \"\(self.NotificationsListDetails[sender.tag].detailsLink)\",\n        \"detailsText\": \"\(self.NotificationsListDetails[sender.tag].detailsText)\",\n        \"applicationType\": \"\(self.NotificationsListDetails[sender.tag].applicationType)\",\n        \"applicationId\": \(self.NotificationsListDetails[sender.tag].applicationId),\n        \"employeeId\": \(self.NotificationsListDetails[sender.tag].employeeId),\n        \"employee\": null\n    }"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: MyStrings().DeleteNotificationsAlerts + String(self.NotificationsListDetails[sender.tag].alertId))!,timeoutInterval: Double.infinity)
        let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("citrix_ns_id=ADET5gL7x8w2OmuZpSbP3hj2oJE0001", forHTTPHeaderField: "Cookie")

        request.httpMethod = "PUT"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {() -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                })
          guard let data = data else {
            print(String(describing: error))
            DispatchQueue.main.async(execute: {() -> Void in
              Toast.show(message: (String(describing: error)), controller: self)
          })
            return
          }
          print(String(data: data, encoding: .utf8)!)
            print("response = \(String(describing: response))")
                       if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 204 {           // check for http errors
                           print("statusCode should be 204, but is \(httpStatus.statusCode)")
                           DispatchQueue.main.async(execute: {() -> Void in
                               Toast.show(message: "Service not available please try again", controller: self)
                           })
                       }else{
                           DispatchQueue.main.async {
                             self.AskConfirmation(title: "My Alert", message: "DMS Request Deleted Successfully") { (result) in
                             if result {
                             self.navigationController?.popViewController(animated: true)
                             } else {

                             }
                             }
                                }
                       }
//          semaphore.signal()
        }

        task.resume()
//        semaphore.wait()
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
    func removeSpecialCharsFromString(text: String) -> String {
           let okayChars = Set("1234567890")
           return text.filter {okayChars.contains($0) }
       }

}
extension NotificationsViewController: UITableViewDataSource,UITableViewDelegate {


func numberOfSections(in tableView: UITableView) -> Int {
        if self.NotificationsListDetails.count == 0
        {
            return 0
        }else{
            
            return self.NotificationsListDetails.count
        }
    }
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
   return 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath)as! NotificationsTableViewCell
    cell.NotificationTitleLbl.text = self.NotificationsListDetails[indexPath.section].text
    let text = self.NotificationsListDetails[indexPath.section].text
    if text.contains("rejected"){
        cell.NotiCustomView.borderColor = UIColor.red
    }else if text.contains("approved"){
        cell.NotiCustomView.borderColor = UIColor.green
    }else{
        cell.NotiCustomView.borderColor = UIColor.darkGray

    }
    
    cell.NotificationDeleteBtn.tag = indexPath.section
    cell.NotificationDeleteBtn.addTarget(self, action: #selector(self.NotificationDeleteBtnAction), for: .touchUpInside)

    
    return cell
}


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 1000
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let approval = self.NotificationsListDetails[indexPath.section].detailsLink
        let theURL = URL(string: approval)  //use your URL
        let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
        let fileNameLessExt = theURL?.deletingPathExtension().lastPathComponent //somePDF
        self.ResponseID = String(fileNameLessExt!)
        print(self.ResponseID)
        
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiDMSReqApprovalViewController")as! NotiDMSReqApprovalViewController
                vc.ResponseID = self.ResponseID
                vc.FromcheckStr = "FromcheckStr"

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiDMSReqApprovalViewController")as! NotiDMSReqApprovalViewController
                vc.ResponseID = self.ResponseID
                vc.FromcheckStr = "FromcheckStr"

                 self.navigationController?.pushViewController(vc, animated: true)

            }
    }

   
   
}
