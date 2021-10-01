//
//  NotiLeaveRequestApprovalViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/28/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class NotiLeaveRequestApprovalViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var ResponseID : String = ""
    var myPickerView : UIPickerView!
    var LeaveTypeDetails : [LeaveTypeModel] = []
    var leaveTypeId : String = ""
    let startDatePicker = UIDatePicker()
    var companyTicketBool = Bool()
    var leaveApplicationId : String = ""
    var leaveTaskId : String = ""
    var ViewleaveTypeId : String = ""
    var approverId : String = ""
    var approvalLevel : String = ""

    var AllowanceReqListDetails : [AllowanceReqViewListModel] = []
    var AllowanceReqApprovalListDetails = [[String: Any]]()

    @IBOutlet weak var TBV: UITableView!

    @IBOutlet weak var ApprovalTF: TextField!
      @IBOutlet weak var CommentsTF: TextField!
    @IBOutlet weak var CompanyTicketTF: TextField!
    @IBOutlet weak var LeaveCategoryTF: TextField!
    @IBOutlet weak var ReasonTF: TextField!
    @IBOutlet weak var AddressTF: TextField!
    @IBOutlet weak var TelephonicResTF: TextField!
    @IBOutlet weak var TelephonicMobTF: TextField!
    @IBOutlet weak var TravelEndDateTF: TextField!
    @IBOutlet weak var TravelStartDateTF: TextField!
    @IBOutlet weak var ToDateTF: TextField!
    @IBOutlet weak var FromDateTF: TextField!
    @IBOutlet weak var BalanceTF: TextField!
    @IBOutlet weak var EligibilityTF: TextField!
    @IBOutlet weak var NumofDaysTF: TextField!
    @IBOutlet weak var RefNumTF: TextField!
    @IBOutlet weak var LeaveTypeTF: TextField!
    @IBOutlet weak var FinancialYearTF: TextField!
    var fromDatePassingString : String = ""
    var toDatePassingString : String = ""
    var TravfromDatePassingString : String = ""
    var TravtoDatePassingString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        LeaveTypeList()
        getallowanceApplicationId()
       self.RefNumTF.backgroundColor = .lightGray
        self.RefNumTF.isUserInteractionEnabled = false
        self.EligibilityTF.backgroundColor = .lightGray
        self.EligibilityTF.isUserInteractionEnabled = false
        self.BalanceTF.backgroundColor = .lightGray
        self.BalanceTF.isUserInteractionEnabled = false
        self.FinancialYearTF.text = "FY2020"
    }
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
        self.LeaveTypeTF.text = LeaveTypeDetails[row].name
        self.leaveTypeId = String(LeaveTypeDetails[row].leaveTypeId)
       if self.LeaveTypeTF.text != ""
       {
           self.fetchEligibityBalance()
       }else{
           
       }
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
      LeaveTypeTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      LeaveTypeTF.resignFirstResponder()
    }
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == FinancialYearTF
        {
            FinancialYearDetails()
        }
        else if textField == LeaveTypeTF
        {
            self.pickUp(LeaveTypeTF)

        }
        else if textField == FromDateTF
        {
            showDatePicker()

        }else if textField == ToDateTF
        {
            showDatePicker1()

        }else if textField == TravelStartDateTF
        {
            showDatePicker2()

        }else if textField == TravelEndDateTF
        {
            showDatePicker3()

        }
        else if textField == LeaveCategoryTF
        {
            LeaveCategoryDetails()

        }else if textField == CompanyTicketTF
        {
            CompanyTickrtDetails()

        }else if textField == ApprovalTF
        {
            self.ApprovalDetails()
        }
    }
    
    func FinancialYearDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.FinancialYearTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Financial Year", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "FY2020", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.FinancialYearTF.text = "FY2020"
                        self.FinancialYearTF.resignFirstResponder()

                       
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "FY2021", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.FinancialYearTF.text = "FY2021"
                       self.FinancialYearTF.resignFirstResponder()
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
                self.FinancialYearTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Financial Year", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "FY2020", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.FinancialYearTF.text = "FY2020"
                         self.FinancialYearTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "FY2021", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.FinancialYearTF.text = "FY2021"
                         self.FinancialYearTF.resignFirstResponder()
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
                  
                  self.FromDateTF.inputAccessoryView = toolbar
                  self.FromDateTF.inputView = startDatePicker
                  
              }
              @objc func donedatePicker()
              {
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                  self.FromDateTF.text = formatter.string(from: startDatePicker.date)
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
               
               self.ToDateTF.inputAccessoryView = toolbar
               self.ToDateTF.inputView = startDatePicker
               
           }
           @objc func donedatePicker1()
           {
               
               let formatter = DateFormatter()
               formatter.dateFormat = "dd/MM/yyyy"
             let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.toDatePassingString = formatter1.string(from: startDatePicker.date)
               self.ToDateTF.text = formatter.string(from: startDatePicker.date)
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
                    
                    self.TravelStartDateTF.inputAccessoryView = toolbar
                    self.TravelStartDateTF.inputView = startDatePicker
                    
                }
                @objc func donedatePicker2()
                {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    self.TravfromDatePassingString = formatter1.string(from: startDatePicker.date)
                    self.TravelStartDateTF.text = formatter.string(from: startDatePicker.date)
                    self.view.endEditing(true)
                }
                
                @objc func cancelDatePicker2()
                {
                    self.view.endEditing(true)
                }
             
             func showDatePicker3()
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
                 let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker4));
                 let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                 let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker4));
                 toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                 
                 self.TravelEndDateTF.inputAccessoryView = toolbar
                 self.TravelEndDateTF.inputView = startDatePicker
                 
             }
             @objc func donedatePicker4()
             {
                 
                 let formatter = DateFormatter()
                 formatter.dateFormat = "dd/MM/yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                self.TravtoDatePassingString = formatter1.string(from: startDatePicker.date)
                 self.TravelEndDateTF.text = formatter.string(from: startDatePicker.date)
                 self.view.endEditing(true)
             }
             
             @objc func cancelDatePicker4()
             {
                 self.view.endEditing(true)
             }
    func LeaveCategoryDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.LeaveCategoryTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Leave Category", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Local", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.LeaveCategoryTF.text = "Local"
                        self.LeaveCategoryTF.resignFirstResponder()

                       
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Outside Country", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.LeaveCategoryTF.text = "Outside Country"
                       self.LeaveCategoryTF.resignFirstResponder()
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
                self.LeaveCategoryTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Leave Category", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Local", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.LeaveCategoryTF.text = "Local"
                         self.LeaveCategoryTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Outside Country", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.LeaveCategoryTF.text = "Outside Country"
                         self.LeaveCategoryTF.resignFirstResponder()
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
                self.CompanyTicketTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Company Ticket", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.CompanyTicketTF.text = "Yes"
                        self.companyTicketBool = true
                        self.CompanyTicketTF.resignFirstResponder()

                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.CompanyTicketTF.text = "No"
                        self.companyTicketBool = false
                        self.CompanyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                self.present(alertController, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                self.CompanyTicketTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Company Ticket", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.CompanyTicketTF.text = "Yes"
                        self.companyTicketBool = true

                         self.CompanyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.CompanyTicketTF.text = "No"
                        self.companyTicketBool = false

                        self.CompanyTicketTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    func ApprovalDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.ApprovalTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Approval", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Approved", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       
                        self.ApprovalTF.text = "Approved"

                        self.ApprovalTF.resignFirstResponder()

                       
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Rejected", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.ApprovalTF.text = "Rejected"
                       self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction3 = UIAlertAction(title: "Initiated", style: UIAlertAction.Style.default) {
                                   (result : UIAlertAction) -> Void in
                                   DispatchQueue.main.async(execute: {() -> Void in
                                      self.ApprovalTF.text = "Initiated"

                                      self.ApprovalTF.resignFirstResponder()
                                   })
                                   self.dismiss(animated: true, completion: nil)
                                   
                               }
                let okAction4 = UIAlertAction(title: "Verified", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.ApprovalTF.text = "Verified"

                       self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction5 = UIAlertAction(title: "Recommended", style: UIAlertAction.Style.default) {
                                   (result : UIAlertAction) -> Void in
                                   DispatchQueue.main.async(execute: {() -> Void in
                                      self.ApprovalTF.text = "Recommended"

                                      self.ApprovalTF.resignFirstResponder()
                                   })
                                   self.dismiss(animated: true, completion: nil)
                                   
                               }
                let okAction6 = UIAlertAction(title: "Pre-approved", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.ApprovalTF.text = "Pre-approved"

                       self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction7 = UIAlertAction(title: "Pre-recommended", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       self.ApprovalTF.text = "Pre-recommended"

                       self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")
                    DispatchQueue.main.async {

                    }

                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                alertController.addAction(okAction3)
                alertController.addAction(okAction4)
                alertController.addAction(okAction5)
                alertController.addAction(okAction6)
                alertController.addAction(okAction7)
                alertController.addAction(okAction2)

                self.present(alertController, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                self.ApprovalTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Approval", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Approved", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.ApprovalTF.text = "Approved"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "Rejected", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.ApprovalTF.text = "Rejected"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction3 = UIAlertAction(title: "Initiated", style: UIAlertAction.Style.default) {
                                   (result : UIAlertAction) -> Void in
                                   DispatchQueue.main.async(execute: {() -> Void in
                                       
                                       self.ApprovalTF.text = "Initiated"

                                        self.ApprovalTF.resignFirstResponder()
                                   })
                                   self.dismiss(animated: true, completion: nil)
                               }
                let okAction4 = UIAlertAction(title: "Verified", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.ApprovalTF.text = "Verified"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction5 = UIAlertAction(title: "Recommended", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.ApprovalTF.text = "Recommended"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction6 = UIAlertAction(title: "Pre-approved", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.ApprovalTF.text = "Pre-approved"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction7 = UIAlertAction(title: "Pre-recommended", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.ApprovalTF.text = "Pre-recommended"

                         self.ApprovalTF.resignFirstResponder()
                    })
                    self.dismiss(animated: true, completion: nil)
                }
                let okAction2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")
                    DispatchQueue.main.async {
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                alertController.addAction(okAction3)
                alertController.addAction(okAction4)
                alertController.addAction(okAction5)
                alertController.addAction(okAction6)
                alertController.addAction(okAction7)

                alertController.addAction(okAction2)

                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func getallowanceApplicationId()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().LeaveIDInfo + self.ResponseID
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
                       DispatchQueue.main.async {

                       let alert = UIAlertController(title: "My alert", message: "Response ID empty", preferredStyle: UIAlertController.Style.alert)

                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                           (result : UIAlertAction) -> Void in
                       }))
                       self.present(alert, animated: true, completion: nil)
                       }
                   }else{
                DispatchQueue.main.async {
                    self.leaveApplicationId = String(json["leaveApplicationId"].intValue)
                    self.leaveTaskId = String(json["leaveTaskId"].intValue)
                    self.approvalLevel = String(json["approvalLevel"].intValue)
                    self.approverId = String(json["approverId"].intValue)


                    let approvalLevel = String(json["approvalLevel"].intValue)
                    self.getLevelReqDetails()

                    if approvalLevel == "1"
                    {
                        self.RefNumTF.backgroundColor = .lightGray
                        self.RefNumTF.isUserInteractionEnabled = false
                        self.EligibilityTF.backgroundColor = .lightGray
                        self.EligibilityTF.isUserInteractionEnabled = false
                        self.BalanceTF.backgroundColor = .lightGray
                        self.BalanceTF.isUserInteractionEnabled = false
                        self.FinancialYearTF.backgroundColor = .white
                        self.FinancialYearTF.isUserInteractionEnabled = true
                        self.LeaveTypeTF.backgroundColor = .white
                        self.LeaveTypeTF.isUserInteractionEnabled = true
                        self.NumofDaysTF.backgroundColor = .white
                        self.NumofDaysTF.isUserInteractionEnabled = true
                        self.FromDateTF.backgroundColor = .white
                        self.FromDateTF.isUserInteractionEnabled = true
                        self.ToDateTF.backgroundColor = .white
                        self.ToDateTF.isUserInteractionEnabled = true
                        self.TravelStartDateTF.backgroundColor = .white
                        self.TravelStartDateTF.isUserInteractionEnabled = true
                        self.TravelEndDateTF.backgroundColor = .white
                        self.TravelEndDateTF.isUserInteractionEnabled = true
                        self.TelephonicMobTF.backgroundColor = .white
                        self.TelephonicMobTF.isUserInteractionEnabled = true
                        self.TelephonicResTF.backgroundColor = .white
                        self.TelephonicResTF.isUserInteractionEnabled = true
                        self.AddressTF.backgroundColor = .white
                        self.AddressTF.isUserInteractionEnabled = true
                        self.ReasonTF.backgroundColor = .white
                        self.ReasonTF.isUserInteractionEnabled = true
                        self.LeaveCategoryTF.backgroundColor = .white
                        self.LeaveCategoryTF.isUserInteractionEnabled = true
                        self.CompanyTicketTF.backgroundColor = .white
                        self.CompanyTicketTF.isUserInteractionEnabled = true
                    }else{
                        
                        self.RefNumTF.backgroundColor = .lightGray
                        self.RefNumTF.isUserInteractionEnabled = false
                        self.EligibilityTF.backgroundColor = .lightGray
                        self.EligibilityTF.isUserInteractionEnabled = false
                        self.BalanceTF.backgroundColor = .lightGray
                        self.BalanceTF.isUserInteractionEnabled = false
                        
                        self.FinancialYearTF.backgroundColor = .lightGray
                       self.FinancialYearTF.isUserInteractionEnabled = false
                       self.LeaveTypeTF.backgroundColor = .lightGray
                       self.LeaveTypeTF.isUserInteractionEnabled = false
                       self.NumofDaysTF.backgroundColor = .lightGray
                       self.NumofDaysTF.isUserInteractionEnabled = false
                       self.FromDateTF.backgroundColor = .lightGray
                       self.FromDateTF.isUserInteractionEnabled = false
                       self.ToDateTF.backgroundColor = .lightGray
                       self.ToDateTF.isUserInteractionEnabled = false
                       self.TravelStartDateTF.backgroundColor = .lightGray
                       self.TravelStartDateTF.isUserInteractionEnabled = false
                       self.TravelEndDateTF.backgroundColor = .lightGray
                       self.TravelEndDateTF.isUserInteractionEnabled = false
                       self.TelephonicMobTF.backgroundColor = .lightGray
                       self.TelephonicMobTF.isUserInteractionEnabled = false
                       self.TelephonicResTF.backgroundColor = .lightGray
                       self.TelephonicResTF.isUserInteractionEnabled = false
                       self.AddressTF.backgroundColor = .lightGray
                       self.AddressTF.isUserInteractionEnabled = false
                       self.ReasonTF.backgroundColor = .lightGray
                       self.ReasonTF.isUserInteractionEnabled = false
                       self.LeaveCategoryTF.backgroundColor = .lightGray
                       self.LeaveCategoryTF.isUserInteractionEnabled = false
                       self.CompanyTicketTF.backgroundColor = .lightGray
                       self.CompanyTicketTF.isUserInteractionEnabled = false
                        

                    }
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
    func getLevelReqDetails()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().LevelReqDetailsInfo + self.leaveApplicationId
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
                       DispatchQueue.main.async {

                       let alert = UIAlertController(title: "My alert", message: "List empty", preferredStyle: UIAlertController.Style.alert)

                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                           (result : UIAlertAction) -> Void in
                       }))
                       self.present(alert, animated: true, completion: nil)
                       }
                   }else{
                DispatchQueue.main.async {
                    self.leaveApplicationId = String(json["leaveApplicationId"].intValue)
                    self.ViewleaveTypeId = String(json["leaveTypeId"].intValue)
                    self.FinancialYearTF.text = json["laFinancialYear"].stringValue
                    let leaveType =  json["leaveType"].dictionaryValue
                    if let adUserName = leaveType["name"]as? Any
                    {
                        let name = dump(self.toString(leaveType["name"]))
                        self.LeaveTypeTF.text = name
                    }else{
                        self.LeaveTypeTF.text = ""
                    }
                    if self.ViewleaveTypeId == ""
                    {
                        
                    }else{
                        self.ViewTimefetchEligibityBalance()
                    }
                    self.RefNumTF.text = json["refNum"].stringValue
                    self.NumofDaysTF.text = String(json["numberOfDays"].intValue)
                    let fromdate = json["fromDate"].stringValue
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from: fromdate)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    self.FromDateTF.text = goodDate

                    let toDate = json["toDate"].stringValue
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date1 = dateFormatter1.date(from: toDate)
                    dateFormatter1.dateFormat = "dd/MM/yyyy"
                    let goodDate1 = dateFormatter1.string(from: date1!)
                    self.ToDateTF.text = goodDate1
                    
                    let travelDate = json["travelStartDate"].stringValue
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date2 = dateFormatter2.date(from: travelDate)
                    dateFormatter2.dateFormat = "dd/MM/yyyy"
                    let goodDate2 = dateFormatter2.string(from: date2!)
                    self.TravelStartDateTF.text = goodDate2
                    
                    let travelEndDate = json["toDate"].stringValue
                    let dateFormatter3 = DateFormatter()
                    dateFormatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date3 = dateFormatter3.date(from: travelEndDate)
                    dateFormatter3.dateFormat = "dd/MM/yyyy"
                    let goodDate3 = dateFormatter3.string(from: date3!)
                    self.TravelEndDateTF.text = goodDate3
                    
                    self.TelephonicMobTF.text = json["telephoneMobile"].stringValue
                    self.TelephonicResTF.text = json["telephoneResidence"].stringValue
                    self.AddressTF.text = json["address"].stringValue
                    self.ReasonTF.text = json["reason"].stringValue

                    self.LeaveCategoryTF.text = json["leaveCategory"].stringValue
                    let CompanyTick = json["companyTicket"].boolValue
                    if CompanyTick == false{
                        self.CompanyTicketTF.text = "No"
                    }else{
                        self.CompanyTicketTF.text = "Yes"
                    }
                    self.ApprovalHistory()
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
    func toString(_ value: Any?) -> String {
         return String(describing: value ?? "")
       }


    func ViewTimefetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().GetLeaveEligibityBalance + self.ViewleaveTypeId
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
                if json.count == 0
                 {
                     DispatchQueue.main.async {

                     let alert = UIAlertController(title: "My alert", message: "Response ID empty", preferredStyle: UIAlertController.Style.alert)

                     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                         (result : UIAlertAction) -> Void in
                     }))
                     self.present(alert, animated: true, completion: nil)
                     }
                }else{
                        let eligibilityAmount = json["total"].intValue
                        let balanceAmount = json["remaining"].intValue
                        DispatchQueue.main.async {
                        self.EligibilityTF.text = String(eligibilityAmount)
                        self.BalanceTF.text = String(balanceAmount)
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
    func ApprovalHistory()
    {
                self.AllowanceReqListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().NotLeaveApprovalDetailsInfo
                    let params = par + "/" + self.leaveApplicationId
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
                   for (index,subJson):(String, JSON) in json {
                      print(index)
                      print(subJson)
                      let details1 = AllowanceReqViewListModel.init(json: subJson)
                      self.AllowanceReqListDetails.append(details1)
                      let approver =  subJson["approver"].dictionaryValue
                    self.AllowanceReqApprovalListDetails.append(approver)
                   }
                    print(self.AllowanceReqApprovalListDetails)
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
    
    func fetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().UpdateLeaveEligibityBalance + self.leaveTypeId + "/" + String(userId)
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
                if json.count == 0
                 {
                     DispatchQueue.main.async {

                     let alert = UIAlertController(title: "My alert", message: "Response ID empty", preferredStyle: UIAlertController.Style.alert)

                     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                         (result : UIAlertAction) -> Void in
                     }))
                     self.present(alert, animated: true, completion: nil)
                     }
                }else{
                        let eligibilityAmount = json["total"].intValue
                        let balanceAmount = json["remaining"].intValue
                        DispatchQueue.main.async {
                        self.EligibilityTF.text = String(eligibilityAmount)
                        self.BalanceTF.text = String(balanceAmount)
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
    
    @IBAction func ClickOnCancel(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ClickOnSubmit(_ sender: Any)
    {
        if self.ApprovalTF.text == ""
         {
             ApprovalTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
             Toast.show(message: "Please enter approval", controller: self)
         }else if self.ApprovalTF.text == "Rejected" && self.CommentsTF.text == ""
         {
             CommentsTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
             Toast.show(message: "Please enter comments", controller: self)
         }else{
             if Connectivity.isConnectedToInternet {
               DispatchQueue.main.async {
                   MBProgressHUD.showAdded(to: self.view, animated: true)
               }
        
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n    \"LeaveTaskId\": \(leaveTaskId),\"LeaveApplicationId\": \(leaveApplicationId),\"ApprovalLevel\": \(approvalLevel),\"ApproverId\": \(approverId),\"Outcome\":  \"\(self.ApprovalTF.text!)\",\"Comment\":  \"\(self.CommentsTF.text!)\"\n}"
                print(parameters)
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: MyStrings().PostLeaveApprovalDetails + self.ResponseID)!,timeoutInterval: Double.infinity)
        let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("citrix_ns_id=9rVN9pG4ngLcUgtLBqyzUjZGV300000", forHTTPHeaderField: "Cookie")

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
                             self.AskConfirmation(title: "My Alert", message: "Leave Request Approval Details Updated Successfully") { (result) in
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
    }

}
extension NotiLeaveRequestApprovalViewController: UITableViewDataSource,UITableViewDelegate {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if self.AllowanceReqListDetails.count == 0
    {
        return 0
    }else{
        
        return self.AllowanceReqListDetails.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell20", for: indexPath)as! ApprovalTableViewCell
    let dict = self.AllowanceReqApprovalListDetails[indexPath.row] as [String : Any]
    print(dict)
    if let adUserName = dict["adUserName"]as? Any
    {
       let name = dump(toString(dict["adUserName"]))
        cell.ApproverNameLbl.text = name
    }else{
        cell.ApproverNameLbl.text = ""
    }
    cell.ApprovalLbl.text = self.AllowanceReqListDetails[indexPath.row].outcome
          let startDate = self.AllowanceReqListDetails[indexPath.row].completed
           print(startDate)
          let checkdate = startDate.fromUTCToLocalDateTime()
          print(checkdate)
          cell.DateTimeLbl.text = checkdate
    cell.CommentsLbl.text = self.AllowanceReqListDetails[indexPath.row].comment
//    if let signURL = dict["signURL"]as? Any
//    {
//
//      let name = dump(toString(dict["signURL"]))
//      print(name)
//       let str =  "https://hrd.alainholding.ae/" + name
//       let escapedString = str.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//       let urlNew:String = escapedString!.replacingOccurrences(of: "%5C", with: "//").trimmed
//      if let url = URL(string: urlNew) {
//          print(url)
//          cell.signatureImgView.kf.setImage(with: url ) { result in
//               switch result {
//               case .success(let value):
//                   print("Image: \(value.image). Got from: \(value.cacheType)")
//               case .failure(let error):
//                   print("Error: \(error)")
//               }
//             }
//      }else{
//          print("Nil")
//      }
     
//    }else{
//
//    }
    return cell
}


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 500
}
   
   
}
extension String {
    func fromUTCToLocalDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var formattedString = self.replacingOccurrences(of: "Z", with: "")
        if let lowerBound = formattedString.range(of: ".")?.lowerBound {
            formattedString = "\(formattedString[..<lowerBound])"
        }

        guard let date = dateFormatter.date(from: formattedString) else {
            return self
        }

        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
