//
//  LeavesListViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/11/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON

class LeavesListViewController: UIViewController {
    var LeavesListDetails : [LeavesListModel] = []
    var SearchLeavesListDetails : [LeavesListModel] = []

    var isSearch : Bool = false

    @IBOutlet weak var SearchBars: UISearchBar!
    var LeavelId : String = ""
    
    @IBOutlet weak var TBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        LeavesListInfoDetails()
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
    
    func LeavesListInfoDetails()
    {
        self.LeavesListDetails.removeAll()
        self.SearchLeavesListDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().LeavesInfo
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
                   return
                 }
                 print(String(data: data, encoding: .utf8)!)
                let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                print(json)
                if json.count == 0
                {
                    DispatchQueue.main.async {
                    let alert = UIAlertController(title: "My alert", message: "Leaves list empty", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        (result : UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    }
                }else{
                 for (index,subJson):(String, JSON) in json {
                     print(index)
                     print(subJson)
                     let details = LeavesListModel.init(json: subJson)
                     self.LeavesListDetails.append(details)
                 }
                    self.SearchLeavesListDetails = self.LeavesListDetails
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
     self.LeavelId = String(self.SearchLeavesListDetails[sender.tag].id)
     
         if #available(iOS 13.0, *) {
          let vc = self.storyboard?.instantiateViewController(identifier: "LeaveRequestViewViewController")as! LeaveRequestViewViewController
             vc.LeaveRequestId  = self.LeavelId
             vc.LeaveRequestType =
            self.SearchLeavesListDetails[sender.tag].leaveType
          self.navigationController?.pushViewController(vc, animated: true)

          } else {
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaveRequestViewViewController")as! LeaveRequestViewViewController
               vc.LeaveRequestId  = self.LeavelId
               vc.LeaveRequestType =
             self.SearchLeavesListDetails[sender.tag].leaveType
              self.navigationController?.pushViewController(vc, animated: true)
         }
     
    }
}

extension LeavesListViewController: UITableViewDataSource,UITableViewDelegate {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if SearchLeavesListDetails.count == 0
    {
        return 0
    }else{
        return self.SearchLeavesListDetails.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "LeaveListsTableViewCell", for: indexPath)as! LeaveListsTableViewCell
    cell.leaveTypeLbl.text = self.SearchLeavesListDetails[indexPath.row].leaveType
    let fromDate = self.SearchLeavesListDetails[indexPath.row].fromDate
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from: fromDate)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let goodDate = dateFormatter.string(from: date!)
    cell.fromDateLbl.text = goodDate
    let toDays = self.SearchLeavesListDetails[indexPath.row].toDate
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date1 = dateFormatter1.date(from: toDays)
    dateFormatter1.dateFormat = "yyyy-MM-dd"
    let goodDate1 = dateFormatter.string(from: date1!)
    cell.toDateLbl.text = goodDate1
    cell.StatusLbl.text = self.SearchLeavesListDetails[indexPath.row].status
    cell.ViewBtn.tag = indexPath.row
    cell.ViewBtn.addTarget(self, action: #selector(self.ViewBtnAction), for: .touchUpInside)
    
    return cell
}


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 500
}
   
   
}
extension LeavesListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        SearchLeavesListDetails.removeAll()
        print(searchText.count)
        print(searchText)
        if searchText.count == 0 {
            self.SearchLeavesListDetails = self.LeavesListDetails
            self.SearchBars.resignFirstResponder()
        } else {
            
        for eachmodel in self.LeavesListDetails
        {
            if eachmodel.leaveType.contains(searchText) || eachmodel.status.contains(searchText) || eachmodel.fromDate.contains(searchText) || eachmodel.toDate.contains(searchText)
            {
                SearchLeavesListDetails.append(eachmodel)
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
