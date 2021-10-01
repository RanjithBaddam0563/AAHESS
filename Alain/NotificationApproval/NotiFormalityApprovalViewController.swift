//
//  NotiFormalityApprovalViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/30/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class NotiFormalityApprovalViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var last35Char : String = ""
    var last10Char : String = ""

    var formalitiesReqDetails : [formalitiesReqModel] = []

    var formalityPaticularId : String = ""
    var myPickerView : UIPickerView!
    var fileUrlStr : String = ""

    @IBOutlet weak var ApprovalTF: TextField!
    @IBOutlet weak var CommentsTF: TextField!
    @IBOutlet weak var ViewFileBtn: UIButton!
    @IBOutlet weak var ViewFileLbl: UILabel!
    @IBOutlet weak var salaryTF: TextField!
    @IBOutlet weak var purposeTF: TextField!
    @IBOutlet weak var detailsReqTF: TextField!
    @IBOutlet weak var RefNumTF: TextField!
    @IBOutlet weak var paticularsTF: TextField!
    var formalityTaskId : String = ""
    var formalityApplicationId : String = ""
    var AllowanceReqListDetails : [AllowanceReqViewListModel] = []
    var AllowanceReqApprovalListDetails = [[String: Any]]()
    var ViewFileLblStr : String = ""


    @IBOutlet weak var TBV: UITableView!

    var ResponseID : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        FormalityTypesInfoList()
        getallowanceApplicationId()
        // Do any additional setup after loading the view.
    }
    func FormalityTypesInfoList()
        {
            self.formalitiesReqDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().FormalityTypesInfo
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
                     let details = formalitiesReqModel.init(json: subJson)
                     self.formalitiesReqDetails.append(details)
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
    
    struct Connectivity
    {
            static let sharedInstance = NetworkReachabilityManager()!
            static var isConnectedToInternet:Bool {
                return self.sharedInstance.isReachable
            }
        }
      func toString(_ value: Any?) -> String
      {
           return String(describing: value ?? "")
      }

    func getallowanceApplicationId()
        {
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                    let par = MyStrings().FormalityIDInfo + self.ResponseID
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
                        self.formalityTaskId = String(json["formalityTaskId"].intValue)
                        self.formalityApplicationId = String(json["formalityApplicationId"].intValue)

                        let approvalLevel = String(json["approvalLevel"].intValue)
                        self.getDMSReqDetails()
                        if approvalLevel == "1"
                        {
                            self.RefNumTF.backgroundColor = .lightGray
                            self.RefNumTF.isUserInteractionEnabled = false
                            self.salaryTF.backgroundColor = .lightGray
                            self.salaryTF.isUserInteractionEnabled = false
                        }else{
                            self.RefNumTF.backgroundColor = .lightGray
                            self.RefNumTF.isUserInteractionEnabled = false
                            self.salaryTF.backgroundColor = .lightGray
                            self.salaryTF.isUserInteractionEnabled = false
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
    func getDMSReqDetails()
        {
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                    let par = MyStrings().FormalityReqDetailsInfo + self.formalityApplicationId
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
//                        self.dmsApplicationId = String(json["dmsApplicationId"].intValue)
                        self.RefNumTF.text = json["refNum"].stringValue
                        let detailsRequired = json["detailsRequired"].boolValue
                        if detailsRequired == false
                        {
                            self.detailsReqTF.text = "No"
                        }else{
                            self.detailsReqTF.text = "Yes"
                        }
                        self.purposeTF.text = json["purpose"].stringValue
                        let employee =  json["employee"].dictionaryValue
                        print(employee)
                        if let empAccInfo = employee["employeeAccountingInfo"]?.dictionaryValue
                        {
                            if let salary = empAccInfo["salary"]?.intValue
                            {
                                self.salaryTF.text = String(salary)
                            }else{
                                self.salaryTF.text = ""
                            }
                        }
                        

                        self.ViewFileLblStr = json["associatedFile"].stringValue
                        let filepath = json["associatedFile"].stringValue
                        print(filepath)
                        if filepath == ""
                        {
                         self.ViewFileLbl.text = ""
                        }else{
                            self.last35Char = String(filepath.suffix(35))
                            self.ViewFileLbl.text = self.last35Char
                           self.last10Char = String(filepath.suffix(10))
                           print(self.last35Char)
                        }
                        let formalityTypeId = String(json["formalityTypeId"].intValue)
                        if formalityTypeId == "1"
                        {
                            self.paticularsTF.text = "Issue /Renew Work Visa"
                        }else if formalityTypeId == "2"
                        {
                            self.paticularsTF.text = "Issue /Renew Visit Visa"
                        }else if formalityTypeId == "3"
                        {
                            self.paticularsTF.text = "Adjustment of Profession"
                        }else if formalityTypeId == "4"
                        {
                            self.paticularsTF.text = "Other Specify"
                        }else if formalityTypeId == "5"
                        {
                            self.paticularsTF.text = "Salary Certificate"
                        }else if formalityTypeId == "6"
                        {
                            self.paticularsTF.text = "Training"
                        }else{
                            self.paticularsTF.text = ""
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
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
         if textField == paticularsTF
        {
            self.pickUp(paticularsTF)

        }else if textField == ApprovalTF
            {
                self.ApprovalDetails()
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
        if formalitiesReqDetails.count == 0 {
         return 0
        }else{
       return formalitiesReqDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formalitiesReqDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.paticularsTF.text = formalitiesReqDetails[row].name
        self.formalityPaticularId = String(formalitiesReqDetails[row].formalityTypeId)
        if self.paticularsTF.text != ""
        {
//            self.fetchEligibityBalance()
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
    func ApprovalHistory()
    {
                self.AllowanceReqListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().NotFormalityReqDetailsInfo
                    let params = par + "/" + self.formalityApplicationId
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

        let parameters = "{\"formalityTaskId\":\(formalityTaskId),\"Outcome\":\"\(self.ApprovalTF.text!)\",\"Comment\":\"\(self.CommentsTF.text!)\"}"
            print(parameters)
        let postData = parameters.data(using: .utf8)

        print(MyStrings().PostFormalityReqDetails + self.ResponseID)
        var request = URLRequest(url: URL(string: MyStrings().PostFormalityReqDetails + self.ResponseID)!,timeoutInterval: Double.infinity)
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
                             self.AskConfirmation(title: "My Alert", message: "Formality Request Approval Updated Successfully") { (result) in
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
    @IBAction func ClickOnFileViewBtn(_ sender: Any)
    {
          if self.ViewFileLblStr == ""
          {
            self.ViewFileBtn.isUserInteractionEnabled = false
          }else{
            self.ViewFileBtn.isUserInteractionEnabled = true
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
}
extension NotiFormalityApprovalViewController: UITableViewDataSource,UITableViewDelegate {


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
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell40", for: indexPath)as! ApprovalTableViewCell
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
