//
//  NotiBusinessTravelReqApprovalViewController.swift
//  Alain
//
//  Created by MicroExcel on 8/4/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class NotiBusinessTravelReqApprovalViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var ViewFileBtn: UIButton!
    @IBOutlet weak var ViewFileLbl: UILabel!
    @IBOutlet weak var ApprovalTF: TextField!
    @IBOutlet weak var CommentsTF: TextField!
    @IBOutlet weak var TotalAmountpaidToEmpTF: TextField!
    @IBOutlet weak var AirTicketDesTF: TextField!
    @IBOutlet weak var AllowanceTotTF: TextField!
    @IBOutlet weak var AirticketCostTF: TextField!
    @IBOutlet weak var TotalNumofDaysTF: TextField!
    @IBOutlet weak var PerDiemTF: TextField!
    @IBOutlet weak var HotelBookingTF: TextField!
    @IBOutlet weak var AirLineTickTF: TextField!
    @IBOutlet weak var PurposeTF: TextField!
    @IBOutlet weak var TravDateToTF: TextField!
    @IBOutlet weak var TravDateFromTF: TextField!
    @IBOutlet weak var RefNumTF: TextField!
    @IBOutlet weak var DestinationTF: TextField!
    var ResponseID : String = ""
    var businessTravelTaskId : String = ""
    var businessTravelApplicationId : String = ""
    var PassName : String = ""
    var PassbusinessTravelApplication : String = ""
    var PassapprovalLevel : String = ""
    var PassapproverId : String = ""
    var Passapprover : String = ""
    var Passcreated : String = ""
    var Passcompleted : String = ""
    var PassisCompleted : String = ""

    var fileUrlStr : String = ""
    var AllowanceReqListDetails : [AllowanceReqViewListModel] = []
    var AllowanceReqApprovalListDetails = [[String: Any]]()
    var checkFrom : String = ""
    let startDatePicker = UIDatePicker()
    var TravfromDatePassingString : String = ""
    var TravtoDatePassingString : String = ""
    var last35Char : String = ""
    var last10Char : String = ""

    var ViewFileLblStr : String = ""



    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        GetBusinessTravelId()
        // Do any additional setup after loading the view.
    }
  

    @IBAction func ClickOnViewFileBtn(_ sender: Any)
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
    struct Connectivity {
             static let sharedInstance = NetworkReachabilityManager()!
             static var isConnectedToInternet:Bool {
                 return self.sharedInstance.isReachable
             }
         }
       func toString(_ value: Any?) -> String {
            return String(describing: value ?? "")
          }
    func GetBusinessTravelId()
        {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().BusinessTravelIDInfo + self.ResponseID
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
                    self.businessTravelTaskId = String(json["businessTravelTaskId"].intValue)
                    self.businessTravelApplicationId = String(json["businessTravelApplicationId"].intValue)
                    self.PassName = json["name"].stringValue
                    self.PassbusinessTravelApplication = json["businessTravelApplication"].stringValue
                    self.PassapprovalLevel = String(json["approvalLevel"].intValue)
                    self.PassapproverId = String(json["approverId"].intValue)
                    self.Passapprover = json["approver"].stringValue
                    self.PassisCompleted = String(json["isCompleted"].boolValue)
                    self.Passcreated = json["created"].stringValue
                    self.Passcompleted = json["completed"].stringValue

                    let approvalLevel = String(json["approvalLevel"].intValue)
                    self.getBusinessTravelDetails()

                    if approvalLevel == "1"
                    {
                        self.RefNumTF.backgroundColor = .lightGray
                        self.RefNumTF.isUserInteractionEnabled = false
                        
                        self.DestinationTF.backgroundColor = .white
                        self.DestinationTF.isUserInteractionEnabled = true
                        self.TravDateFromTF.backgroundColor = .white
                        self.TravDateFromTF.isUserInteractionEnabled = true
                        self.TravDateToTF.backgroundColor = .white
                        self.TravDateToTF.isUserInteractionEnabled = true
                        self.PurposeTF.backgroundColor = .white
                        self.PurposeTF.isUserInteractionEnabled = true
                        self.AirLineTickTF.backgroundColor = .white
                        self.AirLineTickTF.isUserInteractionEnabled = true
                        self.HotelBookingTF.backgroundColor = .white
                        self.HotelBookingTF.isUserInteractionEnabled = true
                        self.PerDiemTF.backgroundColor = .white
                        self.PerDiemTF.isUserInteractionEnabled = true
                        self.TotalNumofDaysTF.backgroundColor = .white
                        self.TotalNumofDaysTF.isUserInteractionEnabled = true
                        self.AirticketCostTF.backgroundColor = .white
                        self.AirticketCostTF.isUserInteractionEnabled = true
                        self.AllowanceTotTF.backgroundColor = .white
                        self.AllowanceTotTF.isUserInteractionEnabled = true
                        self.AirTicketDesTF.backgroundColor = .white
                        self.AirTicketDesTF.isUserInteractionEnabled = true
                        self.TotalAmountpaidToEmpTF.backgroundColor = .white
                        self.TotalAmountpaidToEmpTF.isUserInteractionEnabled = true
                        
                        
                    }else{
                        self.RefNumTF.backgroundColor = .white
                        self.RefNumTF.isUserInteractionEnabled = true
                        
                        self.DestinationTF.backgroundColor = .lightGray
                        self.DestinationTF.isUserInteractionEnabled = false
                        self.TravDateFromTF.backgroundColor = .lightGray
                        self.TravDateFromTF.isUserInteractionEnabled = false
                        self.TravDateToTF.backgroundColor = .lightGray
                        self.TravDateToTF.isUserInteractionEnabled = false
                        self.PurposeTF.backgroundColor = .lightGray
                        self.PurposeTF.isUserInteractionEnabled = false
                        self.AirLineTickTF.backgroundColor = .lightGray
                        self.AirLineTickTF.isUserInteractionEnabled = false
                        self.HotelBookingTF.backgroundColor = .lightGray
                        self.HotelBookingTF.isUserInteractionEnabled = false
                        self.PerDiemTF.backgroundColor = .lightGray
                        self.PerDiemTF.isUserInteractionEnabled = false
                        self.TotalNumofDaysTF.backgroundColor = .lightGray
                        self.TotalNumofDaysTF.isUserInteractionEnabled = false
                        self.AirticketCostTF.backgroundColor = .lightGray
                        self.AirticketCostTF.isUserInteractionEnabled = false
                        self.AllowanceTotTF.backgroundColor = .lightGray
                        self.AllowanceTotTF.isUserInteractionEnabled = false
                        self.AirTicketDesTF.backgroundColor = .lightGray
                        self.AirTicketDesTF.isUserInteractionEnabled = false
                        self.TotalAmountpaidToEmpTF.backgroundColor = .lightGray
                        self.TotalAmountpaidToEmpTF.isUserInteractionEnabled = false
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
    func getBusinessTravelDetails()
        {
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                    
                    let par = MyStrings().BusinessTravelDetailsInfo + self.businessTravelApplicationId
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
                        self.DestinationTF.text = json["destination"].stringValue
                        self.RefNumTF.text = json["refNum"].stringValue
                       let travelDate = json["travelDateFrom"].stringValue
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date2 = dateFormatter2.date(from: travelDate)
                        dateFormatter2.dateFormat = "dd/MM/yyyy"
                        let goodDate2 = dateFormatter2.string(from: date2!)
                        self.TravDateFromTF.text = goodDate2
                        
                        let travelEndDate = json["travelDateTO"].stringValue
                        let dateFormatter3 = DateFormatter()
                        dateFormatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date3 = dateFormatter3.date(from: travelEndDate)
                        dateFormatter3.dateFormat = "dd/MM/yyyy"
                        let goodDate3 = dateFormatter3.string(from: date3!)
                        self.TravDateToTF.text = goodDate3
                        
                        self.PurposeTF.text = json["purpose"].stringValue
                        let airlineTicket = json["airlineTicket"].stringValue
                        if airlineTicket == "false"
                        {
                            self.AirLineTickTF.text = "No"
                        }else{
                            self.AirLineTickTF.text = "Yes"
                        }
                        let hotelBooking = json["hotelBooking"].stringValue
                        if hotelBooking == "false"
                        {
                            self.HotelBookingTF.text = "No"
                        }else{
                            self.HotelBookingTF.text = "Yes"
                        }
                        self.PerDiemTF.text = String(json["perDiem"].intValue)
                        self.TotalNumofDaysTF.text = String(json["totalNumberOfDays"].intValue)
                        self.AirticketCostTF.text = String(json["airTicketsAmount"].intValue)
                        self.AllowanceTotTF.text = String(json["allowancesTotal"].intValue)
                        self.AirTicketDesTF.text = json["airTicketsDescription"].stringValue
                        self.TotalAmountpaidToEmpTF.text = String(json["totalAmount"].intValue)
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
    func ApprovalHistory()
    {
                self.AllowanceReqListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().NotBusinessTravelDetailsInfo
                    let params = par + "/" + self.businessTravelApplicationId
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
              if textField == TravDateFromTF
              {
                  showDatePicker()
              }else if textField == TravDateToTF
              {
                  showDatePicker1()
              }else if textField == AirLineTickTF
              {
                  checkFrom = "airLineTickerTF"
                  AirlineTickrtDetails()
              }else if textField == HotelBookingTF
              {
                  checkFrom = "hotelBookingTF"
                  AirlineTickrtDetails()
              }else if textField == ApprovalTF
              {
                  ApprovalDetails()
              }
          }
          func showDatePicker()
             {
                 startDatePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                startDatePicker.preferredDatePickerStyle = .wheels
            }else{
            }
                 //ToolBar
                 let toolbar = UIToolbar();
                 toolbar.sizeToFit()
                 let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                 let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                 let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
                 toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                 
                 self.TravDateFromTF.inputAccessoryView = toolbar
                 self.TravDateFromTF.inputView = startDatePicker
                 
             }
             @objc func donedatePicker()
             {
                 
                 let formatter = DateFormatter()
                 formatter.dateFormat = "dd/MM/yyyy"
               let formatter1 = DateFormatter()
               formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                 self.TravDateFromTF.text = formatter.string(from: startDatePicker.date)
               self.TravfromDatePassingString = formatter1.string(from: startDatePicker.date)

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
              //ToolBar
              let toolbar = UIToolbar();
              toolbar.sizeToFit()
              let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
              let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
              let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
              toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
              
              self.TravDateToTF.inputAccessoryView = toolbar
              self.TravDateToTF.inputView = startDatePicker
              
          }
       @objc func donedatePicker1()
       {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
         let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.TravtoDatePassingString = formatter1.string(from: startDatePicker.date)
           self.TravDateToTF.text = formatter.string(from: startDatePicker.date)
           self.view.endEditing(true)
       }
          
          @objc func cancelDatePicker1()
          {
              self.view.endEditing(true)
          }
      
       func AirlineTickrtDetails()
       {
           if (UIDevice.current.userInterfaceIdiom  == .pad)
           {
               DispatchQueue.main.async(execute: {() -> Void in
                   self.AirLineTickTF.resignFirstResponder()
                   let alertController = UIAlertController(title: "Choose Airline Ticket", message: nil, preferredStyle: UIAlertController.Style.alert)
                   
                   let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                       (result : UIAlertAction) -> Void in
                       DispatchQueue.main.async(execute: {() -> Void in
                           if self.checkFrom == "airLineTickerTF"
                           {
                           self.AirLineTickTF.text = "Yes"
                           self.AirLineTickTF.resignFirstResponder()

                           }else{
                           self.HotelBookingTF.text = "Yes"
                           self.HotelBookingTF.resignFirstResponder()

                           }
                           
                       })
                       self.dismiss(animated: true, completion: nil)
                       
                   }
                   let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                       (result : UIAlertAction) -> Void in
                       DispatchQueue.main.async(execute: {() -> Void in
                           if self.checkFrom == "airLineTickerTF"
                          {
                          self.AirLineTickTF.text = "No"
                           self.AirLineTickTF.resignFirstResponder()

                          }else{
                          self.HotelBookingTF.text = "No"
                           self.HotelBookingTF.resignFirstResponder()

                          }
                           
                       })
                       self.dismiss(animated: true, completion: nil)
                       
                   }
                   
                   
                   
                   alertController.addAction(okAction)
                   alertController.addAction(okAction1)
                   self.present(alertController, animated: true, completion: nil)
               })
           }else{
               DispatchQueue.main.async(execute: {() -> Void in
                   self.AirLineTickTF.resignFirstResponder()
                   let alertController = UIAlertController(title: "Choose Airline Ticket", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                   
                   let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                       (result : UIAlertAction) -> Void in
                       DispatchQueue.main.async(execute: {() -> Void in
                           if self.checkFrom == "airLineTickerTF"
                           {
                           self.AirLineTickTF.text = "Yes"
                            self.AirLineTickTF.resignFirstResponder()

                           }else{
                           self.HotelBookingTF.text = "Yes"
                            self.HotelBookingTF.resignFirstResponder()

                           }
                           
                       })
                       self.dismiss(animated: true, completion: nil)
                       
                   }
                   let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                       (result : UIAlertAction) -> Void in
                       DispatchQueue.main.async(execute: {() -> Void in
                           if self.checkFrom == "airLineTickerTF"
                           {
                           self.AirLineTickTF.text = "No"
                            self.AirLineTickTF.resignFirstResponder()

                           }else{
                           self.HotelBookingTF.text = "No"
                            self.HotelBookingTF.resignFirstResponder()

                           }
                           
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
    @IBAction func ClickOnCancelBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ClickOnSubmitBtn(_ sender: Any)
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
//       var semaphore = DispatchSemaphore (value: 0)

                let parameters = "{\n    \"businessTravelTaskId\": \(businessTravelTaskId),\n    \"name\": \"\(self.PassName)\",\n    \"businessTravelApplicationId\": \(businessTravelApplicationId),\n    \"businessTravelApplication\": \"\(self.PassbusinessTravelApplication)\",\n    \"approvalLevel\": \"\(self.PassapprovalLevel)\",\n    \"approverId\": \"\(self.PassapproverId)\",\n    \"approver\": \"\(self.Passapprover)\",\n    \"outcome\": \"\(self.ApprovalTF.text!)\",\n    \"comment\": \"\(self.CommentsTF.text!)\",\n    \"isCompleted\": \"\(self.PassisCompleted)\",\n    \"created\": \"\(self.Passcreated)\",\n    \"completed\": \"\(self.Passcompleted)\"\n}"
        let postData = parameters.data(using: .utf8)
                var request = URLRequest(url: URL(string: MyStrings().PostBusinessTravelDetailsDetails + ResponseID)!,timeoutInterval: Double.infinity)
                let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("citrix_ns_id=4ByLci+3bfY8srSDu9BGxdUjihM0001", forHTTPHeaderField: "Cookie")

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
                             self.AskConfirmation(title: "My Alert", message: "Business Travel Request Approval Updated Successfully") { (result) in
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
}
extension NotiBusinessTravelReqApprovalViewController: UITableViewDataSource,UITableViewDelegate {


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
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "ApprovalTableViewCell50", for: indexPath)as! ApprovalTableViewCell
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
