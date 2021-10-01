//
//  NotiDMSReqApprovalViewController.swift
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
class NotiDMSReqApprovalViewController: UIViewController,UITextFieldDelegate {
    var ResponseID : String = ""
    var fileUrlStr : String = ""
    var AllowanceReqListDetails : [AllowanceReqViewListModel] = []
    var AllowanceReqApprovalListDetails = [[String: Any]]()
    @IBOutlet weak var TBV: UITableView!
    var DMSDepDetails : [DMSDepModel] = []

    var dmsCategoryId : String = ""
    var dmsSubCategoryId : String = ""

    @IBOutlet weak var ApprovalCommentView: UIStackView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var subMitBtn: UIButton!
    var last35Char : String = ""
    var last10Char : String = ""

    var FromcheckStr : String = ""
    
    @IBOutlet weak var ApprovalTF: TextField!
    @IBOutlet weak var CommentsTF: TextField!
    @IBOutlet weak var ViewFileBtn: UIButton!
    @IBOutlet weak var viewFileLbl: UILabel!
    @IBOutlet weak var SapPostingTF: TextField!
    @IBOutlet weak var SapDocTF: TextField!
    @IBOutlet weak var SapRefTF: TextField!
    @IBOutlet weak var DetailsTF: TextField!
    @IBOutlet weak var DocRefTF: TextField!
    @IBOutlet weak var processNameTF: TextField!
    @IBOutlet weak var DepartmentTF: TextField!
    @IBOutlet weak var refNumTF: TextField!
    @IBOutlet weak var reqNameTF: TextField!
    var dmsApplicationTaskId : String = ""
    var dmsApplicationId : String = ""
    var approverId : String = ""
    var ViewFileLblStr : String = ""

    func DMSDepartmentInfo()
    {
        self.DMSDepDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().DMSDepartmentInfo + "/" + self.dmsCategoryId
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

                let alert = UIAlertController(title: "My alert", message: "DMS Department Name List empty", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (result : UIAlertAction) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    self.DepartmentTF.text = json["name"].stringValue
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
    func DMSDepartmentProcessNameInfo()
    {
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().DMSProcessNameInfo
            let params = par + "/" + self.dmsSubCategoryId
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
                let alert = UIAlertController(title: "My alert", message: "DMS Process Name List empty", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (result : UIAlertAction) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    self.processNameTF.text = json["name"].stringValue
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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white

          getallowanceApplicationId()
          if FromcheckStr == "FromcheckStr"
          {
              self.subMitBtn.isHidden = true
              self.ApprovalCommentView.isHidden = true
          }else{
              self.subMitBtn.isHidden = false
              self.ApprovalCommentView.isHidden = false
          }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.reqNameTF.backgroundColor = .lightGray
//        self.reqNameTF.isUserInteractionEnabled = false
//        self.refNumTF.backgroundColor = .lightGray
//        self.refNumTF.isUserInteractionEnabled = false
//        self.DepartmentTF.backgroundColor = .lightGray
//        self.DepartmentTF.isUserInteractionEnabled = false
//        self.processNameTF.backgroundColor = .lightGray
//        self.processNameTF.isUserInteractionEnabled = false
//        self.DocRefTF.backgroundColor = .lightGray
//        self.DocRefTF.isUserInteractionEnabled = false
//        self.DetailsTF.backgroundColor = .lightGray
//        self.DetailsTF.isUserInteractionEnabled = false
//        self.SapRefTF.backgroundColor = .lightGray
//        self.SapRefTF.isUserInteractionEnabled = false
//        self.SapDocTF.backgroundColor = .lightGray
//        self.SapDocTF.isUserInteractionEnabled = false
//        self.SapPostingTF.backgroundColor = .lightGray
//        self.SapPostingTF.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
   struct Connectivity {
          static let sharedInstance = NetworkReachabilityManager()!
          static var isConnectedToInternet:Bool {
              return self.sharedInstance.isReachable
          }
      }
    func toString(_ value: Any?) -> String {
         return String(describing: value ?? "")
       }
    func getallowanceApplicationId()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().DMSIDInfo + self.ResponseID
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
                    self.dmsApplicationTaskId = String(json["dmsApplicationTaskId"].intValue)
                    self.dmsApplicationId = String(json["dmsApplicationId"].intValue)
                    self.getDMSReqDetails()

//                    let approvalLevel = String(json["approvalLevel"].intValue)
                
                  
                        self.reqNameTF.backgroundColor = .lightGray
                        self.reqNameTF.isUserInteractionEnabled = false
                        self.refNumTF.backgroundColor = .lightGray
                        self.refNumTF.isUserInteractionEnabled = false
                        self.DepartmentTF.backgroundColor = .lightGray
                        self.DepartmentTF.isUserInteractionEnabled = false
                        self.processNameTF.backgroundColor = .lightGray
                        self.processNameTF.isUserInteractionEnabled = false
                        self.DocRefTF.backgroundColor = .lightGray
                        self.DocRefTF.isUserInteractionEnabled = false
                        self.DetailsTF.backgroundColor = .lightGray
                        self.DetailsTF.isUserInteractionEnabled = false
                        self.SapRefTF.backgroundColor = .lightGray
                        self.SapRefTF.isUserInteractionEnabled = false
                        self.SapDocTF.backgroundColor = .lightGray
                        self.SapDocTF.isUserInteractionEnabled = false
                        self.SapPostingTF.backgroundColor = .lightGray
                        self.SapPostingTF.isUserInteractionEnabled = false

                    
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
                if FromcheckStr == "FromcheckStr"
                {
                    self.dmsApplicationId = self.ResponseID
                }else{
                    
                }
                let par = MyStrings().DMSReqDetailsInfo + self.dmsApplicationId
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
                    self.dmsApplicationId = String(json["dmsApplicationId"].intValue)
                    self.reqNameTF.text = json["refNum"].stringValue
                    self.refNumTF.text = json["refNum"].stringValue
//                    self.DepartmentTF.text = json["refNum"].stringValue
//                     self.processNameTF.text = json["refNum"].stringValue
                    self.DocRefTF.text = json["fileName"].stringValue
                    self.DetailsTF.text = json["details"].stringValue
                    self.SapRefTF.text = json["sapRef"].stringValue
                    self.SapDocTF.text = json["sapDoc"].stringValue
                    self.SapPostingTF.text = json["sapPosting"].stringValue
                    self.ViewFileLblStr = json["associatedFile"].stringValue
                    let filepath = json["associatedFile"].stringValue
                    print(filepath);
                    self.dmsCategoryId = String(json["dmsCategoryId"].intValue)
                    self.dmsSubCategoryId = String(json["dmsSubCategoryId"].intValue)

                    if self.dmsCategoryId == ""
                    {
                        
                    }else{
                        self.DMSDepartmentInfo()
                    }
                    if self.dmsSubCategoryId == ""
                   {
                       
                   }else{
                       self.DMSDepartmentProcessNameInfo()
                   }
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
    

    @IBAction func ClickOnFileBtn(_ sender: Any)
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
    
    func ApprovalHistory()
    {
                self.AllowanceReqListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                    if FromcheckStr == "FromcheckStr"
                    {
                        self.dmsApplicationId = self.ResponseID
                    }else{
                        
                    }

                    let par = MyStrings().NotDMSReqApprovalDetailsInfo
                    let params = par + "/" + self.dmsApplicationId
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
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
      if textField == ApprovalTF
        {
            self.ApprovalDetails()
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

          let parameters = "{\n    \"dmsApplicationTaskId\": \(dmsApplicationTaskId),\"dmsApplicationId\": \(dmsApplicationId),\"Outcome\":  \"\(self.ApprovalTF.text!)\",\"Comment\":  \"\(self.CommentsTF.text!)\"\n}"
                  print(parameters)
          let postData = parameters.data(using: .utf8)

          var request = URLRequest(url: URL(string: MyStrings().PostDMSApprovalDetails + self.ResponseID)!,timeoutInterval: Double.infinity)
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
                               self.AskConfirmation(title: "My Alert", message: "DMS Request Approval Details Updated Successfully") { (result) in
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
extension NotiDMSReqApprovalViewController: UITableViewDataSource,UITableViewDelegate {


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
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell30", for: indexPath)as! ApprovalTableViewCell
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
    if let signURL = dict["signURL"]as? Any
    {

      let name = dump(toString(dict["signURL"]))
      print(name)
       let str =  "https://hrd.alainholding.ae/" + name
       let escapedString = str.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
       let urlNew:String = escapedString!.replacingOccurrences(of: "%5C", with: "//").trimmed
      if let url = URL(string: urlNew) {
          print(url)
          cell.signatureImgView.kf.setImage(with: url ) { result in
               switch result {
               case .success(let value):
                   print("Image: \(value.image). Got from: \(value.cacheType)")
               case .failure(let error):
                   print("Error: \(error)")
               }
             }
      }else{
          print("Nil")
      }
     
    }else{

    }
    return cell
}


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 500
}
   
   
}
