//
//  DMSListViewController.swift
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
class DMSListViewController: UIViewController {
    var DMSListDetails : [MyDMSListModel] = []
    var SearchDMSListDetails : [MyDMSListModel] = []

    var frompassing : String = ""
    @IBOutlet weak var SearchBars: UISearchBar!

    @IBOutlet weak var TBV: UITableView!
    var dmsApplicationId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

         DMSDetails()
               TBV.rowHeight = UITableView.automaticDimension
               TBV.estimatedRowHeight =  UITableView.automaticDimension
    }
    
    @IBAction func ClickOnDMSSegment(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
           DMSDetails()
            frompassing = "DMS"
        }else
        {
           MyParticipatedDMSDetails()
            frompassing = "Participated"

        }
    }
    
    struct Connectivity {
               static let sharedInstance = NetworkReachabilityManager()!
               static var isConnectedToInternet:Bool {
                   return self.sharedInstance.isReachable
               }
           }
           
           func DMSDetails()
           {
            self.TBV.isHidden = false
                   self.DMSListDetails.removeAll()
            self.SearchDMSListDetails.removeAll()
                   if Connectivity.isConnectedToInternet {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true)
                       }
                       let par = MyStrings().MyDMSListInfo
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
                            self.TBV.isHidden = true
                          let alert = UIAlertController(title: "My alert", message: "My DMS list empty", preferredStyle: UIAlertController.Style.alert)

                          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                              (result : UIAlertAction) -> Void in
                          }))
                          self.present(alert, animated: true, completion: nil)
                        }
                      }else{
                        for (index,subJson):(String, JSON) in json {
                            print(index)
                            print(subJson)
                            let details = MyDMSListModel.init(json: subJson)
                            self.DMSListDetails.append(details)
                        }
                            self.SearchDMSListDetails = self.DMSListDetails
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
    
    func MyParticipatedDMSDetails()
    {
        self.TBV.isHidden = false
            self.DMSListDetails.removeAll()
        self.SearchDMSListDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().MyParticipatedDMS
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
                        self.TBV.isHidden = true
                    let alert = UIAlertController(title: "My alert", message: "My participated DMS list empty", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        (result : UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    }
                }else{
                 for (index,subJson):(String, JSON) in json {
                     print(index)
                     print(subJson)
                     let details = MyDMSListModel.init(json: subJson)
                     self.DMSListDetails.append(details)
                 }
                    self.SearchDMSListDetails = self.DMSListDetails
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
            self.dmsApplicationId = String(self.SearchDMSListDetails[sender.tag].dmsApplicationId)
            
                if #available(iOS 13.0, *) {
                 let vc = self.storyboard?.instantiateViewController(identifier: "MyDMSReqViewViewController")as! MyDMSReqViewViewController
                    vc.dmsApplicationId  = self.dmsApplicationId
                    vc.processName = self.SearchDMSListDetails[sender.tag].fromDate
                    vc.frompassing = self.frompassing
                 self.navigationController?.pushViewController(vc, animated: true)

                 } else {
                     let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDMSReqViewViewController")as! MyDMSReqViewViewController
                    vc.dmsApplicationId  = self.dmsApplicationId
                    vc.frompassing = self.frompassing
                    vc.processName = self.SearchDMSListDetails[sender.tag].fromDate
                     self.navigationController?.pushViewController(vc, animated: true)

                }
            
           }
       }

       extension DMSListViewController: UITableViewDataSource,UITableViewDelegate {


       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
           if self.SearchDMSListDetails.count == 0
           {
               return 0
           }else{
               return self.SearchDMSListDetails.count
           }
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           
           let cell = self.TBV.dequeueReusableCell(withIdentifier: "DMSListTableViewCell", for: indexPath)as! DMSListTableViewCell
           cell.RefrenceNumberLbl.text = self.SearchDMSListDetails[indexPath.row].leaveType
           cell.ProcessNameLbl.text = self.SearchDMSListDetails[indexPath.row].fromDate
           cell.FileNameLbl.text = self.SearchDMSListDetails[indexPath.row].toDate
           cell.ViewBtn.tag = indexPath.row
           cell.ViewBtn.addTarget(self, action: #selector(self.ViewBtnAction), for: .touchUpInside)
           cell.StatusLbl.text = self.SearchDMSListDetails[indexPath.row].status
           
           return cell
       }


       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 500
       }
          
          
       }
extension DMSListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        SearchDMSListDetails.removeAll()
        print(searchText.count)
        print(searchText)
        if searchText.count == 0 {
            self.SearchDMSListDetails = self.DMSListDetails
            self.SearchBars.resignFirstResponder()
        } else {
            
        for eachmodel in self.DMSListDetails
        {
            if eachmodel.leaveType.contains(searchText) || eachmodel.status.contains(searchText) || eachmodel.fromDate.contains(searchText) || eachmodel.toDate.contains(searchText)
            {
                SearchDMSListDetails.append(eachmodel)
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

