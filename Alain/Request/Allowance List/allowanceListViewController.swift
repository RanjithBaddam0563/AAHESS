//
//  allowanceListViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/13/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class allowanceListViewController: UIViewController {
    var AllowanceDetails : [AllowanceListModel] = []
    var SearchAllowanceDetails : [AllowanceListModel] = []

    var AllowanceId : String = ""
    @IBOutlet weak var SearchBars: UISearchBar!


    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        AllowanceListDetails()
        TBV.rowHeight = UITableView.automaticDimension
        TBV.estimatedRowHeight =  UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
     struct Connectivity {
            static let sharedInstance = NetworkReachabilityManager()!
            static var isConnectedToInternet:Bool {
                return self.sharedInstance.isReachable
            }
        }
        
        func AllowanceListDetails()
        {
            self.AllowanceDetails.removeAll()
            self.SearchAllowanceDetails.removeAll()
                if Connectivity.isConnectedToInternet {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                    }
                    let par = MyStrings().AllowanceApplicationsListInfo
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
                        let alert = UIAlertController(title: "My alert", message: "Allowance list empty", preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            (result : UIAlertAction) -> Void in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                     for (index,subJson):(String, JSON) in json {
                         print(index)
                         print(subJson)
                         let details = AllowanceListModel.init(json: subJson)
                         self.AllowanceDetails.append(details)
                     }
                        self.SearchAllowanceDetails = self.AllowanceDetails
                    DispatchQueue.main.async {
                     self.TBV.dataSource = self
                     self.TBV.delegate = self
                     self.TBV.reloadData()
                        
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
        @IBAction func ClickOnNextBtn(_ sender: Any) {
        }
        
        @IBAction func ClickOnPreviousBtn(_ sender: Any) {
        }
        @objc func ViewBtnAction(sender: UIButton!)
        {
         self.AllowanceId = String(self.SearchAllowanceDetails[sender.tag].id)
         
             if #available(iOS 13.0, *) {
              let vc = self.storyboard?.instantiateViewController(identifier: "AllowanceReqViewViewController")as! AllowanceReqViewViewController
                 vc.AllowanceReqId  = self.AllowanceId
                 vc.AllowanceReqType = self.SearchAllowanceDetails[sender.tag].leaveType
              self.navigationController?.pushViewController(vc, animated: true)

              } else {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllowanceReqViewViewController")as! AllowanceReqViewViewController
                 vc.AllowanceReqId  = self.AllowanceId
                vc.AllowanceReqType = self.SearchAllowanceDetails[sender.tag].leaveType
                  self.navigationController?.pushViewController(vc, animated: true)

             }
         
        }
    }

    extension allowanceListViewController: UITableViewDataSource,UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.SearchAllowanceDetails.count == 0
        {
            return 0
        }else{
            return self.SearchAllowanceDetails.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = self.TBV.dequeueReusableCell(withIdentifier: "allowanceListTableViewCell", for: indexPath)as! allowanceListTableViewCell
        cell.AllowanceTypeLbl.text = self.SearchAllowanceDetails[indexPath.row].leaveType
        let startDate = self.SearchAllowanceDetails[indexPath.row].fromDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: startDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let goodDate = dateFormatter.string(from: date!)
        cell.startDateLbl.text = goodDate
        
        let endDate = self.SearchAllowanceDetails[indexPath.row].toDate
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date1 = dateFormatter1.date(from: endDate)
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let goodDate1 = dateFormatter.string(from: date1!)
        cell.endDateLbl.text = goodDate1
        cell.ViewBtn.tag = indexPath.row
        cell.ViewBtn.addTarget(self, action: #selector(self.ViewBtnAction), for: .touchUpInside)
        cell.StatusLbl.text = self.SearchAllowanceDetails[indexPath.row].status
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
       
       
    }
extension allowanceListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        SearchAllowanceDetails.removeAll()
        print(searchText.count)
        print(searchText)
        if searchText.count == 0 {
            self.SearchAllowanceDetails = self.AllowanceDetails
            self.SearchBars.resignFirstResponder()
        } else {
            
        for eachmodel in self.AllowanceDetails
        {
            if eachmodel.leaveType.contains(searchText) || eachmodel.status.contains(searchText) || eachmodel.fromDate.contains(searchText) || eachmodel.toDate.contains(searchText)
            {
                SearchAllowanceDetails.append(eachmodel)
            }
        }
         
     }
        self.TBV.reloadData()

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
           return true
       }
       func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            self.SearchBars.resignFirstResponder()
        }
           return true
           
       }
       func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           return true
       }
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
       {
         
       }
    
}
