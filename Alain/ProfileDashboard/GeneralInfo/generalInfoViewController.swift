//
//  generalInfoViewController.swift
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

class generalInfoViewController: UIViewController {

    var employeeCategoryID = Int()
    var signURL : String = ""

    var selectedorNot = Bool()
    
    @IBOutlet weak var mobileNumTF: TextField!
    @IBOutlet weak var homePhoneTF: TextField!
    @IBOutlet weak var countryTF: TextField!
    @IBOutlet weak var streetNumTF: TextField!
    @IBOutlet weak var streetTF: TextField!
    @IBOutlet weak var branchTF: TextField!
    @IBOutlet weak var departmentTF: TextField!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var jobTitleTF: TextField!
    @IBOutlet weak var lastNameTF: TextField!
    @IBOutlet weak var middleNameTF: TextField!
    @IBOutlet weak var firstNameTF: TextField!
    @IBOutlet weak var userCodeTF: TextField!
    @IBOutlet weak var empIdTF: TextField!
    @IBOutlet weak var SapEmpNoTF: TextField!
    @IBOutlet weak var ActiveBtn: UIButton!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var SubmitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.empIdTF.backgroundColor = .lightGray
        self.jobTitleTF.backgroundColor = .lightGray
        self.departmentTF.backgroundColor = .lightGray
        self.branchTF.backgroundColor = .lightGray
        self.middleNameTF.backgroundColor = .lightGray
           self.lastNameTF.backgroundColor = .lightGray
           self.SapEmpNoTF.backgroundColor = .lightGray
           self.emailTF.backgroundColor = .lightGray
           
           self.userCodeTF.backgroundColor = .lightGray
           self.firstNameTF.backgroundColor = .lightGray
           self.streetTF.backgroundColor = .lightGray
           self.streetNumTF.backgroundColor = .lightGray
           
           self.countryTF.backgroundColor = .lightGray
           self.homePhoneTF.backgroundColor = .lightGray
           self.mobileNumTF.backgroundColor = .lightGray
           self.ActiveBtn.backgroundColor = .lightGray
        
        FetchGeneralInfoDetails()
    }
    @IBAction func ClickOnActiveBtn(_ sender: Any)
    {
        if self.ActiveBtn.isSelected == true {
            self.ActiveBtn.isSelected = false
        }
        else {
            self.ActiveBtn.isSelected = true
        }
    }
    
    @IBAction func ClickOnSubmitBtn(_ sender: Any)
    {
        if self.ActiveBtn.isSelected == true {
            self.selectedorNot = true
        }
        else {
            self.selectedorNot = false
        }
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                //adUserName,position,stdCode
                let semaphore = DispatchSemaphore (value: 0)
//\"laFinancialYear\": \"\(self.financialYearTF.text!)\"
                let parameters = "{\n    \"employeeId\": \(userId),\"adUserName\": \"\(self.empIdTF.text!)\",\"jobTitle\": \"\(self.jobTitleTF.text!)\",\"position\": \"\("")\",\"department\": \"\(self.departmentTF.text!)\",\"branch\": \"\(self.branchTF.text!)\",\"userCode\": \"\(self.userCodeTF.text!)\",\"firstName\": \"\(self.firstNameTF.text!)\",\"middleName\": \"\(self.middleNameTF.text!)\",\"lastName\": \"\(self.lastNameTF.text!)\",\"stdCode\": \"\("")\",\"homePhone\": \"\(self.homePhoneTF.text!)\",\"mobileNumber\": \"\(self.mobileNumTF.text!)\",\"fax\": null,\"email\": \"\(self.emailTF.text!)\",\"street\": \"\(self.streetTF.text!)\",\"streetNumber\": \"\(self.streetNumTF.text!)\",\"block\": \"\("")\",\"buildingFloor\": \"\("")\",\"zipCode\": \"\("")\",\"city\": \"\("")\",\"state\": \"\("")\",\"country\": \"\(self.countryTF.text!)\",\"sapEmployeeNumber\": \"\(self.SapEmpNoTF.text!)\",\"isActive\": \"\(self.selectedorNot)\",\"signURL\": \"\(self.signURL)\",\"employeePersonalInfo\": \"\("")\",\"employeeAdminInfo\": \"\("")\",\"employeeAccountingInfo\": \"\("")\",\"employeeCategoryId\": \(employeeCategoryID),\"employeeCategory\": \"\("")\",\"employeeGroups\": \"\("")\"\n}"
               let postData = parameters.data(using: .utf8)
                let token =  UserDefaults.standard.string(forKey: "Token")!

                var request = URLRequest(url: URL(string: MyStrings().PostGeneralInfo + "/" + String(userId))!,timeoutInterval: Double.infinity)
               request.addValue(token, forHTTPHeaderField: "Authorization")
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.addValue("citrix_ns_id=L31sAq1EKwI3Tb7QRRSfV6a7JAc0000", forHTTPHeaderField: "Cookie")

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
                                    self.AskConfirmation(title: "My Alert", message: "Profile General Info updated successfully") { (result) in
                                    if result {
                                    self.navigationController?.popViewController(animated: true)
                                    } else {

                                    }
                                    }
                                       }
                              }
                 semaphore.signal()
               }

               task.resume()
               semaphore.wait()
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
    
    @IBAction func ClickonEditBtn(_ sender: Any)
    {
        
        if  self.SubmitBtn.isHidden == true
        {
            self.SubmitBtn.isHidden = false
            self.EditBtn.setTitle("Cancel", for: .normal)
            
            self.empIdTF.isUserInteractionEnabled = false
             self.jobTitleTF.isUserInteractionEnabled = false
             self.departmentTF.isUserInteractionEnabled = false
             self.branchTF.isUserInteractionEnabled = false
            
            
            self.middleNameTF.isUserInteractionEnabled = true
            self.lastNameTF.isUserInteractionEnabled = true
            self.SapEmpNoTF.isUserInteractionEnabled = true
            self.emailTF.isUserInteractionEnabled = true
            
            self.userCodeTF.isUserInteractionEnabled = true
            self.firstNameTF.isUserInteractionEnabled = true
            self.streetTF.isUserInteractionEnabled = true
            self.streetNumTF.isUserInteractionEnabled = true
            
            self.countryTF.isUserInteractionEnabled = true
            self.homePhoneTF.isUserInteractionEnabled = true
            self.mobileNumTF.isUserInteractionEnabled = true
            self.ActiveBtn.isUserInteractionEnabled = true
             
            self.middleNameTF.backgroundColor = .white
            self.lastNameTF.backgroundColor = .white
            self.SapEmpNoTF.backgroundColor = .white
            self.emailTF.backgroundColor = .white
            
            self.userCodeTF.backgroundColor = .white
            self.firstNameTF.backgroundColor = .white
            self.streetTF.backgroundColor = .white
            self.streetNumTF.backgroundColor = .white
            
            self.countryTF.backgroundColor = .white
            self.homePhoneTF.backgroundColor = .white
            self.mobileNumTF.backgroundColor = .white
            self.ActiveBtn.backgroundColor = .white
        }else{
            self.SubmitBtn.isHidden = true
             self.EditBtn.setTitle("Edit", for: .normal)
            
            self.jobTitleTF.isUserInteractionEnabled = false
              self.empIdTF.isUserInteractionEnabled = false
              self.departmentTF.isUserInteractionEnabled = false
              self.branchTF.isUserInteractionEnabled = false
              
              self.middleNameTF.isUserInteractionEnabled = false
              self.lastNameTF.isUserInteractionEnabled = false
              self.SapEmpNoTF.isUserInteractionEnabled = false
              self.emailTF.isUserInteractionEnabled = false
              
              self.userCodeTF.isUserInteractionEnabled = false
              self.firstNameTF.isUserInteractionEnabled = false
              self.streetTF.isUserInteractionEnabled = false
              self.streetNumTF.isUserInteractionEnabled = false
              
              self.countryTF.isUserInteractionEnabled = false
              self.homePhoneTF.isUserInteractionEnabled = false
              self.mobileNumTF.isUserInteractionEnabled = false
              self.ActiveBtn.isUserInteractionEnabled = false
              
            self.middleNameTF.backgroundColor = .lightGray
            self.lastNameTF.backgroundColor = .lightGray
            self.SapEmpNoTF.backgroundColor = .lightGray
            self.emailTF.backgroundColor = .lightGray
            
            self.userCodeTF.backgroundColor = .lightGray
            self.firstNameTF.backgroundColor = .lightGray
            self.streetTF.backgroundColor = .lightGray
            self.streetNumTF.backgroundColor = .lightGray
            
            self.countryTF.backgroundColor = .lightGray
            self.homePhoneTF.backgroundColor = .lightGray
            self.mobileNumTF.backgroundColor = .lightGray
            self.ActiveBtn.backgroundColor = .lightGray
        }
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    func FetchGeneralInfoDetails()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let token =  UserDefaults.standard.string(forKey: "Token")!
                print(MyStrings().MyGeneralInfo)
                var request = URLRequest(url: URL(string: MyStrings().MyGeneralInfo)!,timeoutInterval: Double.infinity)
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
                    self.SapEmpNoTF.text = String(json["sapEmployeeNumber"].intValue)
                    self.empIdTF.text = json["adUserName"].stringValue
                    let userCode = String(json["userCode"].stringValue)
                    let trimmed = userCode.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.userCodeTF.text = trimmed
                    self.firstNameTF.text = json["firstName"].stringValue
                    self.middleNameTF.text = json["middleName"].stringValue
                    self.lastNameTF.text = json["lastName"].stringValue
                    self.jobTitleTF.text = json["jobTitle"].stringValue
                    self.emailTF.text = json["email"].stringValue
                    let Dep = json["department"].stringValue
                    let trimmed1 = Dep.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.departmentTF.text = trimmed1
                    self.branchTF.text = json["branch"].stringValue
                    self.streetTF.text = json["street"].stringValue
                    self.streetNumTF.text = String(json["streetNumber"].intValue)
                    self.countryTF.text = json["country"].stringValue
                    self.homePhoneTF.text = json["homePhone"].stringValue
                    self.mobileNumTF.text = json["mobileNumber"].stringValue
                    self.employeeCategoryID = json["employeeCategoryId"].intValue
                    let isActive = json["isActive"].boolValue
                    self.signURL = json["signURL"].stringValue
                    if isActive == true
                    {
                        self.ActiveBtn.isSelected = true
                    }else{
                        self.ActiveBtn.isSelected = false
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
    
}
