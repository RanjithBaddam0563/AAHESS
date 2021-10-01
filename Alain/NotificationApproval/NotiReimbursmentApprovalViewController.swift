//
//  NotiReimbursmentApprovalViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/29/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
class NotiReimbursmentApprovalViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    var fileUrlStr : String = ""
    var ReimbursmenParticularsDetails : [ReimbursmenParticularsModel] = []
    var last35Char : String = ""
    var last10Char : String = ""


    @IBOutlet weak var CommentsView: UIView!
    var ResponseID : String = ""
    var allowanceApplicationId : String = ""
    var allowanceApplicationTaskId : String = ""
    var SendAllowanceTypeId : String = ""

    var allowanceApplicationId1 : String = ""
    var myPickerView : UIPickerView!
    var AllowanceTypeId : String = ""
    var AllowanceReqListDetails : [AllowanceReqViewListModel] = []
    var AllowanceReqApprovalListDetails = [[String: Any]]()
    var ViewFileLblStr : String = ""

    
    @IBOutlet weak var TBV: UITableView!
    @IBOutlet weak var ApprovalTF: TextField!
    @IBOutlet weak var CommentsTF: TextField!
    @IBOutlet weak var viewFileLbl: UILabel!
    @IBOutlet weak var viewFileBtn: UIButton!
    @IBOutlet weak var RemarksTF: TextField!
    @IBOutlet weak var AppToTF: TextField!
    @IBOutlet weak var AppFromTF: TextField!
    @IBOutlet weak var BalanceTF: TextField!
    @IBOutlet weak var EligibilityTF: TextField!
    @IBOutlet weak var RefNumTF: TextField!
    @IBOutlet weak var AmountTF: TextField!
    @IBOutlet weak var paticularsTF: TextField!
    let startDatePicker = UIDatePicker()
    var fromDatePassingString : String = ""
       var toDatePassingString : String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        AllowanceTypesDetails()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        getallowanceApplicationId()

        
    }
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == AppFromTF
        {
            showDatePicker()

        }else if textField == AppToTF
        {
            showDatePicker1()

        }else if textField == paticularsTF
        {
            self.pickUp(paticularsTF)
        }else if textField == ApprovalTF
        {
            self.ApprovalDetails()
        }
    }
    func fetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().ReimbursementEligibityBalance + String(self.AllowanceTypeId) + "/" + String(userId)
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
                    let eligibilityAmount = json["eligibilityAmount"].intValue
                    let balanceAmount = json["balanceAmount"].intValue
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
    func AllowanceTypesDetails()
    {
        self.ReimbursmenParticularsDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().ReimbursmentParticularsTypes
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
                     let details = ReimbursmenParticularsModel.init(json: subJson)
                     self.ReimbursmenParticularsDetails.append(details)
                 }
                
                DispatchQueue.main.async {

                    
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
        if ReimbursmenParticularsDetails.count == 0 {
         return 0
        }else{
       return ReimbursmenParticularsDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ReimbursmenParticularsDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.paticularsTF.text = ReimbursmenParticularsDetails[row].name
        self.AllowanceTypeId = String(ReimbursmenParticularsDetails[row].reimbursmentTypeId)
        if self.paticularsTF.text != ""
        {
            self.fetchEligibityBalance()
        }else{
            
        }
        
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
      paticularsTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      paticularsTF.resignFirstResponder()
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
                  
                  self.AppFromTF.inputAccessoryView = toolbar
                  self.AppFromTF.inputView = startDatePicker
                  
              }
              @objc func donedatePicker()
              {
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd/MM/yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                  self.AppFromTF.text = formatter.string(from: startDatePicker.date)
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
               
               self.AppToTF.inputAccessoryView = toolbar
               self.AppToTF.inputView = startDatePicker
               
           }
           @objc func donedatePicker1()
           {
               
               let formatter = DateFormatter()
               formatter.dateFormat = "dd/MM/yyyy"
             let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.toDatePassingString = formatter1.string(from: startDatePicker.date)
               self.AppToTF.text = formatter.string(from: startDatePicker.date)
               self.view.endEditing(true)
           }
           
           @objc func cancelDatePicker1()
           {
               self.view.endEditing(true)
           }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    func getallowanceApplicationId()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().ReimbursmentIDInfo + self.ResponseID
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
                    self.allowanceApplicationId = String(json["reimbursmentApplicationId"].intValue)
                    self.allowanceApplicationTaskId = String(json["reimbursmentTaskId"].intValue)
                    self.getallowanceDetails()

                    let approvalLevel = String(json["approvalLevel"].intValue)
                    if approvalLevel == "1"
                    {
                        self.RefNumTF.backgroundColor = .lightGray
                        self.RefNumTF.isUserInteractionEnabled = false
                        self.EligibilityTF.backgroundColor = .lightGray
                        self.EligibilityTF.isUserInteractionEnabled = false
                        self.BalanceTF.backgroundColor = .lightGray
                        self.BalanceTF.isUserInteractionEnabled = false
                        self.paticularsTF.backgroundColor = .white
                        self.paticularsTF.isUserInteractionEnabled = true
                        self.AmountTF.backgroundColor = .white
                        self.AmountTF.isUserInteractionEnabled = true
                        self.AppFromTF.backgroundColor = .white
                        self.AppFromTF.isUserInteractionEnabled = true
                        self.AppToTF.backgroundColor = .white
                        self.AppToTF.isUserInteractionEnabled = true
                        self.RemarksTF.backgroundColor = .white
                        self.RemarksTF.isUserInteractionEnabled = true
                    }else{
                        self.paticularsTF.backgroundColor = .lightGray
                        self.paticularsTF.isUserInteractionEnabled = false
                        self.AmountTF.backgroundColor = .lightGray
                        self.AmountTF.isUserInteractionEnabled = false
                        self.RefNumTF.backgroundColor = .lightGray
                        self.RefNumTF.isUserInteractionEnabled = false
                        self.EligibilityTF.backgroundColor = .lightGray
                        self.EligibilityTF.isUserInteractionEnabled = false
                        self.BalanceTF.backgroundColor = .lightGray
                        self.BalanceTF.isUserInteractionEnabled = false
                        self.AppFromTF.backgroundColor = .lightGray
                        self.AppFromTF.isUserInteractionEnabled = false
                        self.AppToTF.backgroundColor = .lightGray
                        self.AppToTF.isUserInteractionEnabled = false
                        self.RemarksTF.backgroundColor = .lightGray
                        self.RemarksTF.isUserInteractionEnabled = false
                        
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
    func getallowanceDetails()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().ReimbursmentDetailsInfo + self.allowanceApplicationId
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
                    self.allowanceApplicationId1 = String(json["reimbursmentApplicationId"].intValue)
                    self.SendAllowanceTypeId = String(json["reimbursmentTypeId"].intValue)
                    if self.SendAllowanceTypeId == ""
                    {
                        
                    }else{
                        self.ViewTimefetchEligibityBalance()
                    }
                    if self.SendAllowanceTypeId == "1"
                    {
                        self.paticularsTF.text = "Furniture Allowance"
                    }else if self.SendAllowanceTypeId == "2"
                    {
                        self.paticularsTF.text = "Club Reimbursement"
                    }else if self.SendAllowanceTypeId == "3"
                    {
                        self.paticularsTF.text = "School KG1"
                    }else if self.SendAllowanceTypeId == "4"
                    {
                        self.paticularsTF.text = "School KG2"
                    }else if self.SendAllowanceTypeId == "5"
                    {
                        self.paticularsTF.text = "School G1"
                    }else if self.SendAllowanceTypeId == "6"
                    {
                        self.paticularsTF.text = "School G2"
                    }else if self.SendAllowanceTypeId == "7"
                    {
                        self.paticularsTF.text = "School G3"
                    }else if self.SendAllowanceTypeId == "8"
                    {
                        self.paticularsTF.text = "School G4"
                    }else if self.SendAllowanceTypeId == "9"
                    {
                        self.paticularsTF.text = "School G5"
                    }else if self.SendAllowanceTypeId == "10"
                    {
                        self.paticularsTF.text = "School G6"
                    }else if self.SendAllowanceTypeId == "11"
                    {
                        self.paticularsTF.text = "School G7"
                    }else if self.SendAllowanceTypeId == "12"
                    {
                        self.paticularsTF.text = "School G8"
                    }else if self.SendAllowanceTypeId == "13"
                    {
                        self.paticularsTF.text = "School G9"
                    }else if self.SendAllowanceTypeId == "14"
                    {
                        self.paticularsTF.text = "School G10"
                    }else if self.SendAllowanceTypeId == "15"
                    {
                        self.paticularsTF.text = "School G11"
                    }else if self.SendAllowanceTypeId == "16"
                    {
                        self.paticularsTF.text = "School G12"
                    }else if self.SendAllowanceTypeId == "17"
                    {
                        self.paticularsTF.text = "Mobile"
                    }else{
                         self.paticularsTF.text = ""
                    }
                    self.AmountTF.text = String(json["amount"].intValue)
                    self.RefNumTF.text = json["refNum"].stringValue
                    let fromdate = json["applicationFrom"].stringValue

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from: fromdate)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    self.AppFromTF.text = goodDate
                    
                    let travelDateFrom = json["applicationTo"].stringValue
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date1 = dateFormatter1.date(from: travelDateFrom)
                    dateFormatter1.dateFormat = "dd/MM/yyyy"
                    let goodDate1 = dateFormatter1.string(from: date1!)
                    self.AppToTF.text = goodDate1
                    
                    self.RemarksTF.text = json["remarks"].stringValue
                    self.ViewFileLblStr = json["associatedFile"].stringValue
                    let filepath = json["associatedFile"].stringValue
                    print(filepath)
                    if filepath == ""
                    {
                     self.viewFileLbl.text = ""
                    }else{
                        self.last35Char = String(filepath.suffix(35))
                        self.viewFileLbl.text = self.last35Char
                       self.last10Char = String(filepath.suffix(10))
                       print(self.last35Char)
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
    func ViewTimefetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().GetReimbursementEligibityBalance + self.SendAllowanceTypeId
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
                        let eligibilityAmount = json["eligibilityAmount"].intValue
                        let balanceAmount = json["balanceAmount"].intValue
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

    
    @IBAction func ClickOnFileBtn(_ sender: Any)
    {
        
          if self.ViewFileLblStr == ""
          {
            self.viewFileBtn.isUserInteractionEnabled = false
          }else{
            self.viewFileBtn.isUserInteractionEnabled = true
            let str =  "https://hrd.alainholding.ae/" + self.ViewFileLblStr
            let escapedString1 = str.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            self.fileUrlStr = escapedString1!.replacingOccurrences(of: "%5C", with: "//").trimmed
            print(self.fileUrlStr)
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "webViewViewController")as! webViewViewController
               vc.checkFrom = "formality"
                vc.navTitle = self.last10Char
                vc.fileUrlStr = self.fileUrlStr
             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "webViewViewController")as! webViewViewController
               vc.checkFrom = "formality"
                vc.navTitle = self.last10Char

               vc.fileUrlStr = self.fileUrlStr
                 self.navigationController?.pushViewController(vc, animated: true)

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

                    let par = MyStrings().NotReimbursmentApprovalDetailsInfo
                    let params = par + "/" + self.allowanceApplicationId1
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
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
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
                    DispatchQueue.main.async(execute: {() -> Void in
                    })
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
                    DispatchQueue.main.async(execute: {() -> Void in
                    })
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

        let parameters = "{\"ReimbursmentTaskId\":\(allowanceApplicationTaskId),\"Outcome\":\"\(self.ApprovalTF.text!)\",\"Comment\":\"\(self.CommentsTF.text!)\"}"
            print(parameters)
        let postData = parameters.data(using: .utf8)

                print(MyStrings().PostReimbursmentApprovalDetails + self.allowanceApplicationTaskId)
        var request = URLRequest(url: URL(string: MyStrings().PostReimbursmentApprovalDetails + self.allowanceApplicationTaskId)!,timeoutInterval: Double.infinity)
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
                             self.AskConfirmation(title: "My Alert", message: "Reimbursment Request Approval Updated Successfully") { (result) in
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
extension NotiReimbursmentApprovalViewController: UITableViewDataSource,UITableViewDelegate {


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
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell1", for: indexPath)as! ApprovalTableViewCell
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
