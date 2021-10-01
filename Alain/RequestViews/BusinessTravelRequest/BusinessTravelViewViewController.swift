//
//  BusinessTravelViewViewController.swift
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
class BusinessTravelViewViewController: UIViewController {
    var BusinessTravelId : String = ""
    var fileUrlStr : String = ""
    var BusinessTravelType : String = ""
    var last35Char : String = ""
    var last10Char : String = ""

    var ViewFileLblStr : String = ""

    @IBOutlet weak var TBV: UITableView!
    @IBOutlet weak var AppDateLbl: UILabel!
    @IBOutlet weak var RefNumLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var empDepLbl: UILabel!
    @IBOutlet weak var empPositionLbl: UILabel!
    @IBOutlet weak var empNationalityLbl: UILabel!
    @IBOutlet weak var empIdLbl: UILabel!
    @IBOutlet weak var joiningDateLbl: UILabel!
    
    @IBOutlet weak var viewFileBtn: UIButton!
    @IBOutlet weak var viewFileLbl: UILabel!
    @IBOutlet weak var totalPaidAmountLbl: UILabel!
    @IBOutlet weak var airTicketDesLbl: UILabel!
    @IBOutlet weak var AllowanceTotalLbl: UILabel!
    @IBOutlet weak var airTicketCostLbl: UILabel!
    @IBOutlet weak var totNumDaysLbl: UILabel!
    @IBOutlet weak var perDiemLbl: UILabel!
    @IBOutlet weak var hotelBookingLbl: UILabel!
    @IBOutlet weak var airLineTicketLbl: UILabel!
    @IBOutlet weak var purposeLbl: UILabel!
    @IBOutlet weak var TravToDateLbl: UILabel!
    @IBOutlet weak var TravFromDateLbl: UILabel!
    @IBOutlet weak var Ref1NumLbl: UILabel!
    @IBOutlet weak var DestLbl: UILabel!
    
    var BusinessTravelListDetails : [BusinessTravelViewListModel] = []
    var BusinessTravelApprovalListDetails = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
      BusinessTravelViewDetails()
        ApprovalHistory()
       
    }
    @IBAction func ClickOnViewFileBtn(_ sender: UIButton)
    {
        
          if self.ViewFileLblStr == ""
          {
            self.viewFileBtn.isUserInteractionEnabled = false
          }else{
            self.viewFileBtn.isUserInteractionEnabled = true
            let str =  "https://hrd.alainholding.ae/" + self.ViewFileLblStr
            print(str)
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
           func BusinessTravelViewDetails()
           {
       //            self.DMSReqViewListDetails.removeAll()
                   if Connectivity.isConnectedToInternet {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true)
                       }

                       let par = MyStrings().BusinessTravelViewListInfo
                       let params = par + "/" + self.BusinessTravelId
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
                       DispatchQueue.main.async {
                           let fromdate = json["applicationDate"].stringValue
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                           let date = dateFormatter.date(from: fromdate)
                           dateFormatter.dateFormat = "MMM d, yyyy"
                           let goodDate = dateFormatter.string(from: date!)
                           self.AppDateLbl.text = goodDate
                           self.RefNumLbl.text = json["refNum"].stringValue

                           self.DestLbl.text = json["destination"].stringValue
                           self.Ref1NumLbl.text = json["refNum"].stringValue

                           let travelDateFrom = json["travelDateFrom"].stringValue
                           let dateFormatter1 = DateFormatter()
                           dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                           let date1 = dateFormatter1.date(from: travelDateFrom)
                           dateFormatter1.dateFormat = "dd/MM/yyyy"
                           let goodDate1 = dateFormatter1.string(from: date1!)
                           self.TravFromDateLbl.text = goodDate1
                        
                            let travelDateTo = json["travelDateTO"].stringValue
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date2 = dateFormatter2.date(from: travelDateTo)
                            dateFormatter2.dateFormat = "dd/MM/yyyy"
                            let goodDate2 = dateFormatter2.string(from: date2!)
                            self.TravToDateLbl.text = goodDate2
                        self.purposeLbl.text = json["purpose"].stringValue
                         let airLineTicket = String(json["airlineTicket"].boolValue)
                        if airLineTicket == "false"
                        {
                            self.airLineTicketLbl.text = "No"
                        }else{
                            self.airLineTicketLbl.text = "Yes"
                        }
                        let hotelBooking = String(json["hotelBooking"].boolValue)
                        if hotelBooking == "false"
                        {
                            self.hotelBookingLbl.text = "No"
                        }else{
                            self.hotelBookingLbl.text = "Yes"
                        }
                        let perDiem = json["perDiem"].floatValue
                        let p = Int(perDiem)
                        self.perDiemLbl.text = String(p)
                        
                        let totalNumDays = json["totalNumberOfDays"].floatValue
                        let t = Int(totalNumDays)
                        self.totNumDaysLbl.text = String(t)
                        
                        let airTicketsCost = json["airTicketsAmount"].floatValue
                       let aTC = Int(airTicketsCost)
                       self.airTicketCostLbl.text = String(aTC)
                        
                        let AllowanceTotal = json["allowancesTotal"].floatValue
                        let aT = Int(AllowanceTotal)
                        self.AllowanceTotalLbl.text = String(aT)
                        self.airTicketDesLbl.text = json["airTicketsDescription"].stringValue
                        
                        let TotalAmountPaidtoEmployee = json["totalAmount"].floatValue
                        let tot = Int(TotalAmountPaidtoEmployee)
                        self.totalPaidAmountLbl.text = String(tot)
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
           self.BusinessTravelListDetails.removeAll()
            self.BusinessTravelApprovalListDetails.removeAll()

           if Connectivity.isConnectedToInternet {
               DispatchQueue.main.async {
                   MBProgressHUD.showAdded(to: self.view, animated: true)
               }

               let par = MyStrings().BusinessTravelApprovalListInfo
               let params = par + "/" + self.BusinessTravelId
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
                 let details1 = BusinessTravelViewListModel.init(json: subJson)
                 self.BusinessTravelListDetails.append(details1)
                 let approver =  subJson["approver"].dictionaryValue
               self.BusinessTravelApprovalListDetails.append(approver)
              }
               print(self.BusinessTravelApprovalListDetails)
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

       }
       extension BusinessTravelViewViewController: UITableViewDataSource,UITableViewDelegate {


       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
           if self.BusinessTravelListDetails.count == 0
           {
               return 0
           }else{
               return self.BusinessTravelListDetails.count
           }
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           
           let cell = self.TBV.dequeueReusableCell(withIdentifier: "MyDMSReqViewTableViewCell3", for: indexPath)as! MyDMSReqViewTableViewCell
           let dict = self.BusinessTravelApprovalListDetails[indexPath.row] as [String : Any]
           print(dict)
           if let adUserName = dict["adUserName"]as? Any
           {
              let name = dump(toString(dict["adUserName"]))
               cell.ApproverNameLbl.text = name
           }else{
               cell.ApproverNameLbl.text = ""
           }
           cell.ApprovalLbl.text = self.BusinessTravelListDetails[indexPath.row].outcome
                 let startDate = self.BusinessTravelListDetails[indexPath.row].created
                  let checkdate = startDate.fromUTCToLocalDateTime()
                          print(checkdate)
                          cell.DateTimeLbl.text = checkdate
           cell.CommentsLbl.text = self.BusinessTravelListDetails[indexPath.row].comment
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
