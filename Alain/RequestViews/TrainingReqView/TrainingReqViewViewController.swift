//
//  TrainingReqViewViewController.swift
//  Alain
//
//  Created by MicroExcel on 10/6/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Kingfisher

class TrainingReqViewViewController: UIViewController {
    var formalityId : String = ""
        var formalityType : String = ""
       var dict2: [String: Any] = [:]
       var fileUrlStr : String = ""
       var last35Char : String = ""
       var last10Char : String = ""

       var ViewFileLblStr : String = ""
    
    @IBOutlet weak var AppDateLbl: UILabel!
     @IBOutlet weak var RefNumLbl: UILabel!
     @IBOutlet weak var empNameLbl: UILabel!
     @IBOutlet weak var empDepLbl: UILabel!
     @IBOutlet weak var empPositionLbl: UILabel!
     @IBOutlet weak var empNationalityLbl: UILabel!
     @IBOutlet weak var empIdLbl: UILabel!
     @IBOutlet weak var joiningDateLbl: UILabel!
    @IBOutlet var trainingNameLbl: UILabel!
    @IBOutlet var conductedByLbl: UILabel!
    @IBOutlet var venueLbl: UILabel!
    @IBOutlet var numOfDaysLbl: UILabel!
    @IBOutlet var departmentLbl: UILabel!
    @IBOutlet var trainingFeesLbl: UILabel!
    @IBOutlet var otherExpensesLbl: UILabel!
    @IBOutlet var totalFeeLbl: UILabel!
    @IBOutlet var remarksLbl: UILabel!
    @IBOutlet weak var viewFileLbl: UILabel!
    @IBOutlet weak var viewFileBtn: UIButton!
    @IBOutlet weak var TBV: UITableView!

    
   var formalityViewListDetails : [TrainingViewApprovalModel] = []
        var formalityApprovalListDetails = [[String: Any]]()

        override func viewDidLoad() {
            super.viewDidLoad()
            FormalityViewViewDetails()
            ApprovalHistory()
            // Do any additional setup after loading the view.
        }
        
        struct Connectivity {
               static let sharedInstance = NetworkReachabilityManager()!
               static var isConnectedToInternet:Bool {
                   return self.sharedInstance.isReachable
               }
           }
            func FormalityViewViewDetails()
            {
        //            self.DMSReqViewListDetails.removeAll()
                    if Connectivity.isConnectedToInternet {
                        DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                        }

                        let par = MyStrings().TrainingDetailedListInfo
                        let params = par + "/" + self.formalityId
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
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
                            let date = dateFormatter.date(from: fromdate)
                            dateFormatter.dateFormat = "MMM d, yyyy"
                            let goodDate = dateFormatter.string(from: date!)
                            self.AppDateLbl.text = goodDate
                            self.RefNumLbl.text = json["refNum"].stringValue
                            self.trainingNameLbl.text = json["trainingName"].stringValue
                            self.conductedByLbl.text = json["conductedBy"].stringValue
                            self.venueLbl.text = json["venue"].stringValue
                            self.numOfDaysLbl.text = String(json["numberOfDays"].intValue)
                            self.departmentLbl.text = json["department"].stringValue
                            self.trainingFeesLbl.text = String(json["trainingFees"].intValue)
                            self.otherExpensesLbl.text = String(json["otherExpenses"].intValue)
                            self.totalFeeLbl.text = String(json["totalFees"].intValue)
                            self.remarksLbl.text = json["remarks"].stringValue
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
                        self.formalityViewListDetails.removeAll()
                        if Connectivity.isConnectedToInternet {
                            DispatchQueue.main.async {
                                MBProgressHUD.showAdded(to: self.view, animated: true)
                            }

                            let par = MyStrings().TrainingDetailsApprovalListInfo
                            let params = par + "/" + self.formalityId
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
                              let details1 = TrainingViewApprovalModel.init(json: subJson)
                              self.formalityViewListDetails.append(details1)
                              let approver =  subJson["approver"].dictionaryValue
                            self.formalityApprovalListDetails.append(approver)
                           }
                            print(self.formalityApprovalListDetails)
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

        @IBAction func ClickOnViewFileBtn(_ sender: UIButton)
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
    }
        extension TrainingReqViewViewController: UITableViewDataSource,UITableViewDelegate {


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            if self.formalityViewListDetails.count == 0
            {
                return 0
            }else{
                return self.formalityViewListDetails.count
            }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            let cell = self.TBV.dequeueReusableCell(withIdentifier: "MyDMSReqViewTableViewCell16", for: indexPath)as! MyDMSReqViewTableViewCell
            let dict = self.formalityApprovalListDetails[indexPath.row] as [String : Any]
            print(dict)
            if let adUserName = dict["adUserName"]as? Any
            {
               let name = dump(toString(dict["adUserName"]))
                cell.ApproverNameLbl.text = name
            }else{
                cell.ApproverNameLbl.text = ""
            }
            cell.ApprovalLbl.text = self.formalityViewListDetails[indexPath.row].outcome
                  let startDate = self.formalityViewListDetails[indexPath.row].created
                   let checkdate = startDate.fromUTCToLocalDateTime()
                           print(checkdate)
                           cell.DateTimeLbl.text = checkdate
            cell.CommentsLbl.text = self.formalityViewListDetails[indexPath.row].comment
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

