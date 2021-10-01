//
//  MyDMSReqViewViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/14/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Kingfisher

class MyDMSReqViewViewController: UIViewController {
    @IBOutlet weak var TBV: UITableView!
    var dmsApplicationId : String = ""
    var processName : String = ""
    var fileUrlStr : String = ""
    var last35Char : String = ""
    var last10Char : String = ""

    var ViewFileLblStr : String = ""

    @IBOutlet weak var sapPostingLbl: UILabel!
    @IBOutlet weak var sapDocLbl: UILabel!
    @IBOutlet weak var sapRefLbl: UILabel!
    var frompassing : String = ""
    var DMSReqApprovalListDetails : [MyDMSApprovalHistoryModel] = []
    var DMSApprovalHistoryListDetails = [[String: Any]]()

    @IBOutlet weak var viewFileBtn: UIButton!
    @IBOutlet weak var viewFileLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var docRefLbl: UILabel!
    @IBOutlet weak var processNameLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var refNumLbl: UILabel!
    @IBOutlet weak var reqNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.frompassing == "DMS"
        {
            self.title = "DMS Request"
        }else{
            self.title = "My Participated DMS Request"

        }
        DMSReqViewDetails()
        ApprovalHistory()
      
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    @IBAction func ClickOnViewFileBtn(_ sender: Any)
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
    
    func DMSReqViewDetails()
    {
//            self.DMSReqViewListDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }

                let par = MyStrings().MyDMSRequestListInfo
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
                DispatchQueue.main.async {
                    let dict = json["employee"].dictionaryObject
                    if dict?.count == 0
                    {
                       let alert = UIAlertController(title: "My alert", message: "DMS request list empty", preferredStyle: UIAlertController.Style.alert)

                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                           (result : UIAlertAction) -> Void in
                       }))
                       self.present(alert, animated: true, completion: nil)
                       
                      return
                    }else{
                        if let firstName = dict?["firstName"]as? String
                        {
                            self.reqNameLbl.text = firstName
                        }else{
                            self.reqNameLbl.text = ""
                        }
                        self.refNumLbl.text = json["refNum"].stringValue
                        if let dep = dict?["jobTitle"]as? String
                        {
                            self.departmentLbl.text = dep
                        }else{
                            self.departmentLbl.text = ""
                        }
                        self.processNameLbl.text = self.processName
                        self.docRefLbl.text = json["fileName"].stringValue
                        self.detailsLbl.text = json["details"].stringValue
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
                        self.sapRefLbl.text = json["sapRef"].stringValue
                        self.sapDocLbl.text = json["sapDoc"].stringValue
                        self.sapPostingLbl.text = json["sapPosting"].stringValue

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
                self.DMSReqApprovalListDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }

                    let par = MyStrings().MyDMSRequestApprovalHistoryInfo
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
                      let details = MyDMSApprovalHistoryModel.init(json: subJson)
                      self.DMSReqApprovalListDetails.append(details)
                      let approver =  subJson["approver"].dictionaryValue
                    self.DMSApprovalHistoryListDetails.append(approver)
                   }
                    print(self.DMSApprovalHistoryListDetails)
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
extension MyDMSReqViewViewController: UITableViewDataSource,UITableViewDelegate {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if self.DMSReqApprovalListDetails.count == 0
    {
        return 0
    }else{
        return self.DMSReqApprovalListDetails.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "MyDMSReqViewTableViewCell", for: indexPath)as! MyDMSReqViewTableViewCell
    let dict = self.DMSApprovalHistoryListDetails[indexPath.row] as [String : Any]
    print(dict)
    if let adUserName = dict["adUserName"]as? Any
    {
       let name = dump(toString(dict["adUserName"]))
        cell.ApproverNameLbl.text = name
    }else{
        cell.ApproverNameLbl.text = ""
    }
    cell.ApprovalLbl.text = self.DMSReqApprovalListDetails[indexPath.row].outcome
          let startDate = self.DMSReqApprovalListDetails[indexPath.row].created
          let checkdate = startDate.fromUTCToLocalDateTime()
                   print(checkdate)
                   cell.DateTimeLbl.text = checkdate
    cell.CommentsLbl.text = self.DMSReqApprovalListDetails[indexPath.row].comment
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


