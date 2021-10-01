//
//  AccountingInfoViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/8/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class AccountingInfoViewController: UIViewController {

    var AccountingListId : String = ""


    @IBOutlet weak var branchNameTF: TextField!
    @IBOutlet weak var accountNumTF: TextField!
    @IBOutlet weak var bankNameTF: TextField!
    @IBOutlet weak var salaryTF: TextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        FetchAccountingInfoDetails()
        // Do any additional setup after loading the view.
        self.branchNameTF.backgroundColor = .lightGray
        self.accountNumTF.backgroundColor = .lightGray
        self.bankNameTF.backgroundColor = .lightGray
        self.salaryTF.backgroundColor = .lightGray
        
    }
    
    @IBAction func ClickOnEditBtn(_ sender: Any)
       {
           if  self.submitBtn.isHidden == true
           {
               self.submitBtn.isHidden = false
               self.editBtn.setTitle("Cancel", for: .normal)
               self.branchNameTF.isUserInteractionEnabled = false
               self.accountNumTF.isUserInteractionEnabled = false
               self.bankNameTF.isUserInteractionEnabled = false
               self.salaryTF.isUserInteractionEnabled = false
               
               
               self.branchNameTF.backgroundColor = .lightGray
                      self.accountNumTF.backgroundColor = .lightGray
                      self.bankNameTF.backgroundColor = .lightGray
                      self.salaryTF.backgroundColor = .lightGray
                      
               
              
           }else{
               self.submitBtn.isHidden = true
                self.editBtn.setTitle("Edit", for: .normal)
              self.branchNameTF.isUserInteractionEnabled = false
              self.accountNumTF.isUserInteractionEnabled = false
              self.bankNameTF.isUserInteractionEnabled = false
              self.salaryTF.isUserInteractionEnabled = false
              
               self.branchNameTF.backgroundColor = .lightGray
               self.accountNumTF.backgroundColor = .lightGray
               self.bankNameTF.backgroundColor = .lightGray
               self.salaryTF.backgroundColor = .lightGray
               
               
           }
       }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    func FetchAccountingInfoDetails()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().AccountingInfo
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
                 guard let data = data else {
                   print(String(describing: error))
                   return
                 }
                 print(String(data: data, encoding: .utf8)!)
                let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                print(json)
                DispatchQueue.main.async {
                    self.AccountingListId  = String(json["employeeAccountingInfoId"].intValue)
                    self.salaryTF.text = String(json["salary"].intValue)

                    self.bankNameTF.text = json["bankName"].stringValue
                    self.accountNumTF.text = json["bankAccountNumber"].stringValue
                    self.branchNameTF.text = json["bankBranch"].stringValue
                    
                    
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
    @IBAction func ClickOnSubmitBtn(_ sender: UIButton)
    {
        if Connectivity.isConnectedToInternet {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
//        var semaphore = DispatchSemaphore (value: 0)
        let userId = UserDefaults.standard.integer(forKey: "employeeId")

        let parameters = "{\n    \"employeeAccountingInfoId\": \((self.AccountingListId)),\"employeeMOIID\": null,\"fathersName\": \"test\",\"imprestCode\": null,\"hardFurnishingCode\": null,\"salary\": \"\(self.salaryTF.text!)\",\"employeeCode\": null,\"staffAdvanceCode\": null,\"companyEmpCode\": null,\"branchOffice\": null,\"blockFinancialEntry\": null,\"bankName\": \"\(self.bankNameTF.text!)\",\"bankAccountNumber\": \"\(self.accountNumTF.text!)\",\"bankBranch\": \"\(self.branchNameTF.text!)\",\"employeeId\": \(userId),\"employee\": null\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: MyStrings().PostAccountingInfo + "/" + AccountingListId)!,timeoutInterval: Double.infinity)
        let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("citrix_ns_id=YJLheug0SzBE9nxW6CmH2m+hHJM0001", forHTTPHeaderField: "Cookie")

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
                             self.AskConfirmation(title: "My Alert", message: "Profile Accounting Info updated successfully") { (result) in
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
    
}
