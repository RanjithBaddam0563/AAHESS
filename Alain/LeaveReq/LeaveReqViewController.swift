//
//  LeaveReqViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/25/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class LeaveReqViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    var LeaveTypeDetails : [LeaveTypeModel] = []
    let startDatePicker = UIDatePicker()

    var leaveTypeId : String = ""
    var companyTicketBool = Bool()
    
    @IBOutlet weak var numofDaysTF: TextField!
    @IBOutlet weak var companyTicketTF: TextField!
    @IBOutlet weak var leaveCategoryTF: TextField!
    @IBOutlet weak var reasonTF: TextField!
    @IBOutlet weak var addressTF: TextField!
    @IBOutlet weak var telephoneResTF: TextField!
    @IBOutlet weak var telephoneMobTF: TextField!
    @IBOutlet weak var travelEndDateTF: TextField!
    @IBOutlet weak var travelStartDateTF: TextField!
    @IBOutlet weak var toDateTF: TextField!
    @IBOutlet weak var fromDateTF: TextField!
    @IBOutlet weak var balanceTF: TextField!
    @IBOutlet weak var eligibilityTF: TextField!
    @IBOutlet weak var leaveTypeTF: TextField!
    @IBOutlet weak var financialYearTF: TextField!

    var myPickerView : UIPickerView!

    var fromDatePassingString : String = ""
    var toDatePassingString : String = ""
    var TravfromDatePassingString : String = ""
    var TravtoDatePassingString : String = ""


    func pickUp(_ textField : UITextField){

    // UIPickerView
    self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    self.myPickerView.delegate = self
    self.myPickerView.dataSource = self
    self.myPickerView.backgroundColor = UIColor.white
    textField.inputView = self.myPickerView

    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = .black
    toolBar.sizeToFit()

    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar

     }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
     }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if LeaveTypeDetails.count == 0 {
         return 0
        }else{
       return LeaveTypeDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LeaveTypeDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.leaveTypeTF.text = LeaveTypeDetails[row].name
        self.leaveTypeId = String(LeaveTypeDetails[row].leaveTypeId)
        if self.leaveTypeTF.text != ""
        {
            self.fetchEligibityBalance()
        }else{
            
        }
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
      leaveTypeTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      leaveTypeTF.resignFirstResponder()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        LeaveTypeList()
        self.financialYearTF.text = "FY2020"

        self.eligibilityTF.backgroundColor = .lightGray
        self.eligibilityTF.text = "0"
        self.numofDaysTF.backgroundColor = .lightGray
        self.numofDaysTF.text = "0"

               self.balanceTF.backgroundColor = .lightGray
        self.balanceTF.text = "0"

               self.eligibilityTF.isUserInteractionEnabled = false
               self.balanceTF.isUserInteractionEnabled = false
        self.numofDaysTF.isUserInteractionEnabled = false
       self.navigationController?.navigationBar.tintColor = UIColor.white
             let logo = UIImage(named: "logo1")
             let imageView = UIImageView(image:logo)
             imageView.contentMode = .scaleAspectFit
             imageView.setImageColor(color: UIColor.white)
             self.navigationItem.titleView = imageView

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
                  
                  self.fromDateTF.inputAccessoryView = toolbar
                  self.fromDateTF.inputView = startDatePicker
                  
              }
              @objc func donedatePicker()
              {
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                  self.fromDateTF.text = formatter.string(from: startDatePicker.date)
                self.fromDatePassingString = formatter1.string(from: startDatePicker.date)
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
               
               self.toDateTF.inputAccessoryView = toolbar
               self.toDateTF.inputView = startDatePicker
               
           }
           @objc func donedatePicker1()
           {
               
               let formatter = DateFormatter()
               formatter.dateFormat = "dd/MM/yyyy"
             let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.toDatePassingString = formatter1.string(from: startDatePicker.date)
               self.toDateTF.text = formatter.string(from: startDatePicker.date)
               self.view.endEditing(true)
           }
           
           @objc func cancelDatePicker1()
           {
               self.view.endEditing(true)
           }
    
    func showDatePicker2()
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
                    let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker2));
                    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                    let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker2));
                    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                    
                    self.travelStartDateTF.inputAccessoryView = toolbar
                    self.travelStartDateTF.inputView = startDatePicker
                    
                }
                @objc func donedatePicker2()
                {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    self.TravfromDatePassingString = formatter1.string(from: startDatePicker.date)
                    self.travelStartDateTF.text = formatter.string(from: startDatePicker.date)
                    self.view.endEditing(true)
                }
                
                @objc func cancelDatePicker2()
                {
                    self.view.endEditing(true)
                }
             
             func showDatePicker3()
             {
                 startDatePicker.datePickerMode = .date
      //           startDatePicker.maximumDate = Date()
                if #available(iOS 13.4, *) {
                    startDatePicker.preferredDatePickerStyle = .wheels
                }else{
                }
                 //ToolBar
                 let toolbar = UIToolbar();
                 toolbar.sizeToFit()
                 let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker4));
                 let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                 let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker4));
                 toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                 
                 self.travelEndDateTF.inputAccessoryView = toolbar
                 self.travelEndDateTF.inputView = startDatePicker
                 
             }
             @objc func donedatePicker4()
             {
                 
                 let formatter = DateFormatter()
                 formatter.dateFormat = "dd/MM/yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                self.TravtoDatePassingString = formatter1.string(from: startDatePicker.date)
                 self.travelEndDateTF.text = formatter.string(from: startDatePicker.date)
                 self.view.endEditing(true)
             }
             
             @objc func cancelDatePicker4()
             {
                 self.view.endEditing(true)
             }
         

    @IBAction func ClickOnCancelBtn(_ sender: Any)
       {
           self.navigationController?.popViewController(animated: true)
       }
        @IBAction func ClickOnSubmitBtn(_ sender: Any)
        {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            if self.financialYearTF.text == ""
            {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                financialYearTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter financial year", controller: self)
            }else if self.leaveTypeTF.text == ""
            {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                leaveTypeTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter leave type", controller: self)
            }else if self.fromDateTF.text == ""
            {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                fromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter from date", controller: self)
            }else if self.toDateTF.text == ""
            {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                toDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter to date", controller: self)
            }else{
               
            if Connectivity.isConnectedToInternet {
               
//           var semaphore = DispatchSemaphore (value: 0)
              
            let parameters = "{ \"laFinancialYear\": \"\(self.financialYearTF.text!)\",\"leaveCategory\": \"\(self.leaveCategoryTF.text!)\",\"fromDate\": \"\(self.fromDatePassingString)\",\"toDate\": \"\(self.toDatePassingString)\",\"travelStartDate\": \"\(self.TravfromDatePassingString)\", \"travelEndDate\": \"\(self.TravtoDatePassingString)\",\"telephoneMobile\": \"\(self.telephoneMobTF.text!)\",\"telephoneResidence\": \"\(self.telephoneResTF.text!)\",\"address\": \"\(self.addressTF.text!)\",\"reason\": \"\(self.reasonTF.text!)\", \"companyTicket\": \(self.companyTicketBool), \"leaveTypeId\": \"\(self.leaveTypeId)\"}\n"
            print(parameters)
            let postData = parameters.data(using: .utf8)
               
            var request = URLRequest(url: URL(string:MyStrings().SubmitLeaveRequestApplications)!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let token =  UserDefaults.standard.string(forKey: "Token")!

            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("citrix_ns_id=Zru2trWjmyk78uEatbqye7/1Pu00000", forHTTPHeaderField: "Cookie")
            request.httpMethod = "POST"
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    }
              guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {
                    Toast.show(message: (String(describing: error)), controller: self)
                }
                return
              }
              print(String(data: data, encoding: .utf8)!)
                print("response = \(String(describing: response))")
                           if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                            DispatchQueue.main.async {
                                }
                            // check for http errors
                               print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            DispatchQueue.main.async {
                                   Toast.show(message: "Service not available please try again", controller: self)
                               }
                           }else{
                            
                               var jsonDictionary1 : NSDictionary?
                               do {
                                   jsonDictionary1 = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                               
                                   print(jsonDictionary1!)
                                   DispatchQueue.main.async {
                                   self.AskConfirmation(title: "My Alert", message: "Leave Request Added Successfully") { (result) in
                                      if result {
                                       self.navigationController?.popViewController(animated: true)
                                      } else {
                                          
                                      }
                                  }
                                              }
                               } catch {
                                   print(error)
                                DispatchQueue.main.async{
                                       Toast.show(message: "Service not available please try again", controller: self)
                                   }
                               }
                           }
//              semaphore.signal()
            }

            task.resume()
//            semaphore.wait()
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
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == financialYearTF
        {
            FinancialYearDetails()
        }else if textField == leaveTypeTF
        {
            self.pickUp(leaveTypeTF)

        }else if textField == fromDateTF
        {
            showDatePicker()

        }else if textField == toDateTF
        {
            showDatePicker1()

        }else if textField == travelStartDateTF
        {
            showDatePicker2()

        }else if textField == travelEndDateTF
        {
            showDatePicker3()

        }else if textField == leaveCategoryTF
        {
            LeaveCategoryDetails()

        }else if textField == companyTicketTF
        {
            CompanyTickrtDetails()

        }
    }
    
    
    func FinancialYearDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.financialYearTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Financial Year", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "FY2020", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.financialYearTF.text = "FY2020"
                        self.financialYearTF.resignFirstResponder()

                       
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "FY2021", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.financialYearTF.text = "FY2021"
                       self.financialYearTF.resignFirstResponder()
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
                self.financialYearTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Financial Year", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "FY2020", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.financialYearTF.text = "FY2020"
                         self.financialYearTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "FY2021", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.financialYearTF.text = "FY2021"
                         self.financialYearTF.resignFirstResponder()
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
    func LeaveTypeList()
    {
        self.LeaveTypeDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().LeaveTypeInfo
            let params = par
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
                 let details = LeaveTypeModel.init(json: subJson)
                 self.LeaveTypeDetails.append(details)
             }
            
            DispatchQueue.main.async {
//                self.leaveTypeTF.inputView = self.gradePicker
//                self.gradePicker.dataSource = self
//                self.gradePicker.delegate = self
//                self.gradePicker.reloadAllComponents()
                
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
    func fetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().LeaveEligibityBalance + String(self.leaveTypeId) + "/" + String(userId)
                let params = par
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
                let eligibilityAmount = json["total"].intValue
                let balanceAmount = json["remaining"].intValue
                DispatchQueue.main.async {
                self.eligibilityTF.text = String(eligibilityAmount)
                self.balanceTF.text = String(balanceAmount)
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
    func LeaveCategoryDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.leaveCategoryTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Leave Category", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Local", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.leaveCategoryTF.text = "Local"
                        self.leaveCategoryTF.resignFirstResponder()

                       
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Outside Country", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.leaveCategoryTF.text = "Outside Country"
                       self.leaveCategoryTF.resignFirstResponder()
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
                self.leaveCategoryTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Leave Category", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Local", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.leaveCategoryTF.text = "Local"
                         self.leaveCategoryTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Outside Country", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.leaveCategoryTF.text = "Outside Country"
                         self.leaveCategoryTF.resignFirstResponder()
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
    func CompanyTickrtDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.companyTicketTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Company Ticket", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.companyTicketTF.text = "Yes"
                        self.companyTicketBool = true
                        self.companyTicketTF.resignFirstResponder()

                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.companyTicketTF.text = "No"
                        self.companyTicketBool = false
                        self.companyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                self.present(alertController, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                self.companyTicketTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Company Ticket", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.companyTicketTF.text = "Yes"
                        self.companyTicketBool = true

                         self.companyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.companyTicketTF.text = "No"
                        self.companyTicketBool = false

                        self.companyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }

}


