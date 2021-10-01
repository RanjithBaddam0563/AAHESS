//
//  LeaveRequestViewViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/15/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Kingfisher
class LeaveRequestViewViewController: UIViewController {
    var LeaveRequestId : String = ""
    var LeaveRequestType : String = ""
       @IBOutlet weak var TBV: UITableView!
       @IBOutlet weak var AppDateLbl: UILabel!
       @IBOutlet weak var RefNumLbl: UILabel!
       @IBOutlet weak var empNameLbl: UILabel!
       @IBOutlet weak var empDepLbl: UILabel!
       @IBOutlet weak var empPositionLbl: UILabel!
       @IBOutlet weak var empNationalityLbl: UILabel!
       @IBOutlet weak var empIdLbl: UILabel!
       @IBOutlet weak var joiningDateLbl: UILabel!
    
    @IBOutlet weak var companyTicketLbl: UILabel!
    @IBOutlet weak var travelStartDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var eligibilityLbl: UILabel!
    @IBOutlet weak var numOfDaysLbl: UILabel!
    @IBOutlet weak var financialYearLbl: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var leaveCategoryLbl: UILabel!
    @IBOutlet weak var telephoneResidLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var telephoneMobileLbl: UILabel!
    @IBOutlet weak var TravelEndDateLbl: UILabel!
    
    var LeaveRequestEmpDetails = [[String: Any]]()
    var LeaveListDetails : [LeaveListViewListModel] = []
    var LeaveApprovalListDetails = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        LeaveReqViewDetails()
        ApprovalHistory()
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
        func LeaveReqViewDetails()
        {
    //            self.DMSReqViewListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().LeaveViewListInfo
                    let params = par + "/" + self.LeaveRequestId
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
                       let employee =  subJson["employee"].dictionaryValue
                       self.LeaveRequestEmpDetails.append(employee)
                    }
                    DispatchQueue.main.async {
                        let fromdate = json["applicationDate"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date = dateFormatter.date(from: fromdate)
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let goodDate = dateFormatter.string(from: date!)
                        self.AppDateLbl.text = goodDate
                        self.RefNumLbl.text = json["refNum"].stringValue

                        self.financialYearLbl.text = json["laFinancialYear"].stringValue
//                        let dict = self.LeaveRequestEmpDetails[0] as [String : Any]
//                        print(dict)
//                        if let adUserName = dict["name"]as? Any
//                        {
//                            let name = dump(self.toString(dict["name"]))
                        self.leaveTypeLbl.text = self.LeaveRequestType
//                        }else{
//                            self.leaveTypeLbl.text = ""
//                        }
                       let numberOfDays = json["numberOfDays"].floatValue
                       let aT = Int(numberOfDays)
                       self.numOfDaysLbl.text = String(aT)
                        
                        self.eligibilityLbl.text = "0"
                        self.balanceLbl.text = "0"

                        
                        let travelDateFrom = json["fromDate"].stringValue
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date1 = dateFormatter1.date(from: travelDateFrom)
                        dateFormatter1.dateFormat = "dd/MM/yyyy"
                        let goodDate1 = dateFormatter1.string(from: date1!)
                        self.fromDateLbl.text = goodDate1
                     
                         let travelDateTo = json["toDate"].stringValue
                         let dateFormatter2 = DateFormatter()
                         dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                         let date2 = dateFormatter2.date(from: travelDateTo)
                         dateFormatter2.dateFormat = "dd/MM/yyyy"
                         let goodDate2 = dateFormatter2.string(from: date2!)
                         self.toDateLbl.text = goodDate2
                        
                        let travelStartDate = json["travelStartDate"].string
                        if travelStartDate != nil
                        {
                            let travelDateTo = json["travelStartDate"].stringValue
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date2 = dateFormatter2.date(from: travelDateTo)
                            dateFormatter2.dateFormat = "dd/MM/yyyy"
                            let goodDate2 = dateFormatter2.string(from: date2!)
                            self.travelStartDateLbl.text = goodDate2
                          
                        }else{
                            self.travelStartDateLbl.text = ""
                        }
                        let travelEndDate = json["travelEndDate"].string
                        if travelEndDate != nil
                        {
                            let travelDateTo = json["travelEndDate"].stringValue
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date2 = dateFormatter2.date(from: travelDateTo)
                            dateFormatter2.dateFormat = "dd/MM/yyyy"
                            let goodDate2 = dateFormatter2.string(from: date2!)
                            self.TravelEndDateLbl.text = goodDate2
                        }else{
                            
                            self.TravelEndDateLbl.text = ""
                        }
                        let telephoneMobile = json["telephoneMobile"].string
                        if telephoneMobile != nil
                        {
                            self.telephoneMobileLbl.text = telephoneMobile
                        }else{
                            self.telephoneMobileLbl.text = ""
                        }
                        let address = json["address"].string
                        if address != nil
                        {
                            self.addressLbl.text = address
                        }else{
                            self.addressLbl.text = ""
                        }
                        let reason = json["reason"].string
                        if reason != nil
                        {
                            self.reasonLbl.text = reason
                        }else{
                            self.reasonLbl.text = ""
                        }
                        let telephoneResidence = json["telephoneResidence"].string
                        if telephoneResidence != nil
                        {
                            self.telephoneResidLbl.text = telephoneResidence
                        }else{
                            self.telephoneResidLbl.text = ""
                        }
                        let leaveCategory = json["leaveCategory"].string
                        if leaveCategory != nil
                        {
                            self.leaveCategoryLbl.text = leaveCategory
                        }else{
                            self.leaveCategoryLbl.text = ""
                        }
                        let companyTicket  = String(json["companyTicket"].boolValue)
                        if companyTicket == "false"
                        {
                            self.companyTicketLbl.text = "No"
                        }else{
                            self.companyTicketLbl.text = "Yes"
                        }

                        self.empNameLbl.text = UserDefaults.standard.string(forKey: "firstName")
                        if let Dep = UserDefaults.standard.string(forKey: "Department")
                        {
                        let trimmed1 = Dep.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.empDepLbl.text = trimmed1
                         }
                        self.empPositionLbl.text = UserDefaults.standard.string(forKey: "jobTitle")
                        let empId = UserDefaults.standard.string(forKey: "userCode")
                        if let Id = empId
                        {
                            let trimmed = Id.trimmingCharacters(in: .whitespacesAndNewlines)
                            self.empIdLbl.text = trimmed

                        }else{
                           self.empIdLbl.text = ""
                        }

                        self.empNationalityLbl.text = "Yes"
                        self.joiningDateLbl.text = ""

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
          self.LeaveListDetails.removeAll()
        self.LeaveApprovalListDetails.removeAll()

          if Connectivity.isConnectedToInternet {
              DispatchQueue.main.async {
                  MBProgressHUD.showAdded(to: self.view, animated: true)
              }

              let par = MyStrings().LeaveApprovalListInfo
              let params = par + "/" + self.LeaveRequestId
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
                let details1 = LeaveListViewListModel.init(json: subJson)
                self.LeaveListDetails.append(details1)
                let approver =  subJson["approver"].dictionaryValue
              self.LeaveApprovalListDetails.append(approver)
             }
              print(self.LeaveApprovalListDetails)
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
    
          

      }
      extension LeaveRequestViewViewController: UITableViewDataSource,UITableViewDelegate {


      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
      {
          if self.LeaveListDetails.count == 0
          {
              return 0
          }else{
              return self.LeaveListDetails.count
          }
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
      {
          
          let cell = self.TBV.dequeueReusableCell(withIdentifier: "MyDMSReqViewTableViewCell4", for: indexPath)as! MyDMSReqViewTableViewCell
          let dict = self.LeaveApprovalListDetails[indexPath.row] as [String : Any]
          print(dict)
          if let adUserName = dict["adUserName"]as? Any
          {
             let name = dump(toString(dict["adUserName"]))
              cell.ApproverNameLbl.text = name
          }else{
              cell.ApproverNameLbl.text = ""
          }
          cell.ApprovalLbl.text = self.LeaveListDetails[indexPath.row].outcome
                let startDate = self.LeaveListDetails[indexPath.row].created
        
                let checkdate = startDate.fromUTCToLocalDateTime()
                         print(checkdate)
                         cell.DateTimeLbl.text = checkdate
          cell.CommentsLbl.text = self.LeaveListDetails[indexPath.row].comment
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
