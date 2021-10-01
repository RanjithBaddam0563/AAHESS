//
//  personalInfoViewController.swift
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

class personalInfoViewController: UIViewController,UITextFieldDelegate
{

    
    let startDatePicker = UIDatePicker()

    var employee : String = ""
    
    var employeePersonalInfoId : String = ""
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var GenderTF: TextField!
    @IBOutlet weak var CitizenShipTF: TextField!
    @IBOutlet weak var DateofBirthTF: TextField!
    @IBOutlet weak var PassportNumberTF: TextField!
    @IBOutlet weak var CountryofBirthTF: TextField!
    @IBOutlet weak var ExpirationDateTF: TextField!
    @IBOutlet weak var MaritalStatusTF: TextField!
    @IBOutlet weak var NumberofchildrenTF: TextField!



    override func viewDidLoad() {
        super.viewDidLoad()

        self.NumberofchildrenTF.backgroundColor = .lightGray
        self.MaritalStatusTF.backgroundColor = .lightGray
        self.ExpirationDateTF.backgroundColor = .lightGray
        self.CountryofBirthTF.backgroundColor = .lightGray
        self.PassportNumberTF.backgroundColor = .lightGray
        self.DateofBirthTF.backgroundColor = .lightGray
        self.CitizenShipTF.backgroundColor = .lightGray
        self.GenderTF.backgroundColor = .lightGray
        FetchPersonalInfoDetails()
    }
    
    @IBAction func ClickOnSubmitBtn(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
//        var semaphore = DispatchSemaphore (value: 0)
//\"\(self.financialYearTF.text!)\"
        let userId = UserDefaults.standard.integer(forKey: "employeeId")

        let parameters = "{\n    \"employeePersonalInfoId\": \(self.employeePersonalInfoId),\"gender\": \"\(self.GenderTF.text!)\",\"dateOfBirth\": \"\(self.DateofBirthTF.text!)\",\"countryOfBirth\": \"\(self.CountryofBirthTF.text!)\",\"maritalStatus\": \"\(self.MaritalStatusTF.text!)\",\"numberOfChildren\": \"\(self.NumberofchildrenTF.text!)\",\"citizenship\": \"\(self.CitizenShipTF.text!)\",\"passportNumber\": \"\(self.PassportNumberTF.text!)\",\"passportExpirationDate\": \"\(self.ExpirationDateTF.text!)\",\"employeeId\": \(userId),\"employee\": \"\(self.employee)\"\n}"
        let postData = parameters.data(using: .utf8)
        let token =  UserDefaults.standard.string(forKey: "Token")!

        var request = URLRequest(url: URL(string: MyStrings().PostPersonalInfo + "/" + employeePersonalInfoId)!,timeoutInterval: Double.infinity)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("citrix_ns_id=T2upp/FkywTuGQ7vXlmzN85i7+k0001", forHTTPHeaderField: "Cookie")

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
                             self.AskConfirmation(title: "My Alert", message: "Profile Personal Info updated successfully") { (result) in
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
    @IBAction func ClickOnEditBtn(_ sender: Any)
    {
        if  self.submitBtn.isHidden == true
        {
            self.submitBtn.isHidden = false
            self.editBtn.setTitle("Cancel", for: .normal)
            self.GenderTF.isUserInteractionEnabled = true
            self.CitizenShipTF.isUserInteractionEnabled = true
            self.DateofBirthTF.isUserInteractionEnabled = true
            self.PassportNumberTF.isUserInteractionEnabled = true
            self.CountryofBirthTF.isUserInteractionEnabled = true
            self.ExpirationDateTF.isUserInteractionEnabled = true
            self.MaritalStatusTF.isUserInteractionEnabled = true
            self.NumberofchildrenTF.isUserInteractionEnabled = true
            
            self.NumberofchildrenTF.backgroundColor = .white
                   self.MaritalStatusTF.backgroundColor = .white
                   self.ExpirationDateTF.backgroundColor = .white
                   self.CountryofBirthTF.backgroundColor = .white
                   self.PassportNumberTF.backgroundColor = .white
                   self.DateofBirthTF.backgroundColor = .white
                   self.CitizenShipTF.backgroundColor = .white
                   self.GenderTF.backgroundColor = .white

            
           
        }else{
            self.submitBtn.isHidden = true
             self.editBtn.setTitle("Edit", for: .normal)
           self.GenderTF.isUserInteractionEnabled = false
           self.CitizenShipTF.isUserInteractionEnabled = false
           self.DateofBirthTF.isUserInteractionEnabled = false
           self.PassportNumberTF.isUserInteractionEnabled = false
           self.CountryofBirthTF.isUserInteractionEnabled = false
           self.ExpirationDateTF.isUserInteractionEnabled = false
           self.MaritalStatusTF.isUserInteractionEnabled = false
           self.NumberofchildrenTF.isUserInteractionEnabled = false
            self.NumberofchildrenTF.backgroundColor = .lightGray
            self.MaritalStatusTF.backgroundColor = .lightGray
            self.ExpirationDateTF.backgroundColor = .lightGray
            self.CountryofBirthTF.backgroundColor = .lightGray
            self.PassportNumberTF.backgroundColor = .lightGray
            self.DateofBirthTF.backgroundColor = .lightGray
            self.CitizenShipTF.backgroundColor = .lightGray
            self.GenderTF.backgroundColor = .lightGray
            
        }
    }
     public func textFieldDidBeginEditing(_ textField: UITextField)
       {
           if textField == DateofBirthTF
           {
               showDatePicker()
           }else if textField == ExpirationDateTF
           {
               showDatePicker1()
           }else if textField == GenderTF
           {
               GenderDetails()
           }
       }
           func showDatePicker()
              {
                  startDatePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                startDatePicker.preferredDatePickerStyle = .wheels
            }else{
            }
    //              startDatePicker.maximumDate = Date()
                  //ToolBar
                  let toolbar = UIToolbar();
                  toolbar.sizeToFit()
                  let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                  let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                  let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
                  toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                  
                  self.DateofBirthTF.inputAccessoryView = toolbar
                  self.DateofBirthTF.inputView = startDatePicker
                  
              }
              @objc func donedatePicker()
              {
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yyyy"
                  self.DateofBirthTF.text = formatter.string(from: startDatePicker.date)
                  self.view.endEditing(true)
              }
              
              @objc func cancelDatePicker()
              {
                  self.view.endEditing(true)
              }
           
           func showDatePicker1()
           {
               startDatePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                startDatePicker.preferredDatePickerStyle = .wheels
            }else{
            }
    //           startDatePicker.maximumDate = Date()
               //ToolBar
               let toolbar = UIToolbar();
               toolbar.sizeToFit()
               let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
               let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
               toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
               
               self.ExpirationDateTF.inputAccessoryView = toolbar
               self.ExpirationDateTF.inputView = startDatePicker
               
           }
           @objc func donedatePicker1()
           {
               
               let formatter = DateFormatter()
               formatter.dateFormat = "dd/MM/yyyy"
               self.ExpirationDateTF.text = formatter.string(from: startDatePicker.date)
               self.view.endEditing(true)
           }
           
           @objc func cancelDatePicker1()
           {
               self.view.endEditing(true)
           }
    
    func GenderDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.GenderTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Gender", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Male", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.GenderTF.text = "Male"
                        self.GenderTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Female", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.GenderTF.text = "Female"
                       self.GenderTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")

                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                alertController.addAction(okAction2)

                self.present(alertController, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                self.GenderTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Gender", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Male", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.GenderTF.text = "Male"
                        self.GenderTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Female", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.GenderTF.text = "Female"
                        self.GenderTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")

                    self.dismiss(animated: true, completion: nil)
                    
                }
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                alertController.addAction(okAction2)

                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    struct Connectivity {
           static let sharedInstance = NetworkReachabilityManager()!
           static var isConnectedToInternet:Bool {
               return self.sharedInstance.isReachable
           }
       }
    
    func FetchPersonalInfoDetails()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().MyPersonalInfo
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
                    self.GenderTF.text = json["gender"].stringValue
                    self.CitizenShipTF.text = json["citizenship"].stringValue
                    let dateofBirth = json["dateOfBirth"].stringValue

                    self.PassportNumberTF.text = json["passportNumber"].stringValue
                    self.CountryofBirthTF.text = json["countryOfBirth"].stringValue
                    let ExpirationDate = json["passportExpirationDate"].stringValue
                    self.MaritalStatusTF.text = json["maritalStatus"].stringValue
                    self.NumberofchildrenTF.text = json["numberOfChildren"].stringValue
                    self.employeePersonalInfoId = String(json["employeePersonalInfoId"].intValue)
                    self.employee = String(json["employee"].stringValue)

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from: dateofBirth)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    self.DateofBirthTF.text = goodDate

                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date1 = dateFormatter1.date(from: ExpirationDate)
                    dateFormatter1.dateFormat = "dd/MM/yyyy"
                    let goodDate1 = dateFormatter.string(from: date1!)
                    self.ExpirationDateTF.text = goodDate1

                   
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
