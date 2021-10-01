//
//  formalityListViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/21/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
class formalityListViewController: UIViewController,UITextFieldDelegate {
    var FormalityDetails : [FormalityListModel] = []
    var SearchFormalityDetails : [FormalityListModel] = []

       var formalityId : String = ""
    @IBOutlet weak var TBV: UITableView!
    @IBOutlet weak var SearchBars: UISearchBar!

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        formalityListDetails()
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
         
         func formalityListDetails()
         {
             self.FormalityDetails.removeAll()
            self.SearchFormalityDetails.removeAll()
                 if Connectivity.isConnectedToInternet {
                     DispatchQueue.main.async {
                         MBProgressHUD.showAdded(to: self.view, animated: true)
                     }
                     let par = MyStrings().FormalityListInfo
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

                            let alert = UIAlertController(title: "My alert", message: "Formaliy list empty", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                (result : UIAlertAction) -> Void in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            }
                        }else{
                      for (index,subJson):(String, JSON) in json {
                          print(index)
                          print(subJson)
                          let details = FormalityListModel.init(json: subJson)
                          self.FormalityDetails.append(details)
                      }
                            self.SearchFormalityDetails = self.FormalityDetails
                        
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
     self.formalityId = String(self.SearchFormalityDetails[sender.tag].id)
     
         if #available(iOS 13.0, *) {
          let vc = self.storyboard?.instantiateViewController(identifier: "formalityViewViewController")as! formalityViewViewController
             vc.formalityId  = self.formalityId
             vc.formalityType = self.SearchFormalityDetails[sender.tag].leaveType
          self.navigationController?.pushViewController(vc, animated: true)

          } else {
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "formalityViewViewController")as! formalityViewViewController
             vc.formalityId  = self.formalityId
            vc.formalityType = self.SearchFormalityDetails[sender.tag].leaveType
              self.navigationController?.pushViewController(vc, animated: true)

         }
     
    }
}
extension formalityListViewController: UITableViewDataSource,UITableViewDelegate {


   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
       if self.SearchFormalityDetails.count == 0
       {
           return 0
       }else{
           return self.SearchFormalityDetails.count
       }
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
       
    let cell = self.TBV.dequeueReusableCell(withIdentifier: "formalityListTableViewCell", for: indexPath)as! formalityListTableViewCell
       cell.formalityTypeLbl.text = self.SearchFormalityDetails[indexPath.row].leaveType
       cell.ViewBtn.tag = indexPath.row
       cell.ViewBtn.addTarget(self, action: #selector(self.ViewBtnAction), for: .touchUpInside)
       cell.StatusLbl.text = self.SearchFormalityDetails[indexPath.row].status
       
       return cell
   }


   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return 500
   }
      
      
   }
extension formalityListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        SearchFormalityDetails.removeAll()
        print(searchText.count)
        print(searchText)
        if searchText.count == 0 {
            self.SearchFormalityDetails = self.FormalityDetails
            self.SearchBars.resignFirstResponder()
        } else {
            
        for eachmodel in self.FormalityDetails
        {
            if eachmodel.leaveType.contains(searchText) || eachmodel.status.contains(searchText)
            {
                SearchFormalityDetails.append(eachmodel)
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
