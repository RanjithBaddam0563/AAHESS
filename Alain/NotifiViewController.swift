//
//  NotifiViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/19/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import LGSideMenuController
import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Foundation
import UserNotifications


extension NotifiViewController : UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound,.badge])
    }
    
}

class NotifiViewController: LGSideMenuController,UIGestureRecognizerDelegate {
    var notificationDetails : [NotificationListModel] = []
    var ResponseID : String = ""
    //TimmerNotification
    var Notificationtimer : Timer!
    var TimmerNil = String()
    var timer : Timer?
    var UDID_Ios = String()

    var FromTimmerNoti : String = ""
    
    @IBOutlet weak var segMent: UISegmentedControl!
    @IBOutlet weak var RequestPopUp: UIView!
    @IBOutlet weak var AlphaView: UIView!
    var NotificationItem1 = BadgeBarButtonItem()

    var NotificationsCount : String = ""
    
    
    @IBOutlet weak var TBV: UITableView!
    override func viewWillAppear(_ animated: Bool)
    {
        self.notificationsListDetails()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.NotificationItem1 = BadgeBarButtonItem(image: "notification", target: self, action: #selector(chatButtonTapped3))!
               navigationItem.rightBarButtonItems = [self.NotificationItem1]
         GenerateNewToken()
        
        
        self.navigationController?.navigationBar.isHidden = false
        hideLeftView(animated: false, completionHandler: nil)
        self.AlphaView.isHidden = true
        
    }
    func GenerateNewToken()
    {
        
        if Connectivity.isConnectedToInternet {
//            DispatchQueue.main.async {
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//            }
            let username =  UserDefaults.standard.string(forKey: "UserName")!
            let password =  UserDefaults.standard.string(forKey: "Password")!
            let KUserDefault = UserDefaults.standard
            let tocken = KUserDefault.value(forKey: "FCMToken")as! String

           let parameters: [String: Any] = [
            "username" : username,
            "password" : password,
            "Uid" : tocken,
            "DeviceType" : "IOS",
            "AuthorizationKey" : "AAAA3vnDydY:APA91bGuzj1sKISy1gcyvAkC5r77Ip7Y5N92sFtsouBtCO1LeedlVmJEBoWJWH7Hz12FtT8p-InnEzTDDN4FsJ_SFbvsdgQtBSQCGEkXpuxo7vF6-FUSmJWRVdcXuHb9UFWFbr4tAST5"
            ]
            print(parameters)

            Alamofire.request(MyStrings().loginUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
//                    DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    }
                    print(response)
                    switch response.result {
                    case let .success(value):
                        let json = JSON(value)
                        print(json)
                        if json.count == 0
                        {
                            DispatchQueue.main.async {

                            let alert = UIAlertController(title: "My alert", message: "Please check the login credentials", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                (result : UIAlertAction) -> Void in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            }
                        }else{
                        if json["token"].stringValue != "" {
                           let token = json["token"].stringValue
                           let finalToken = "Bearer" + " " + token
                           print(finalToken)
                           UserDefaults.standard.set(finalToken, forKey: "Token")
                            self.NotificationHistoryCount()
                        }else{
                            let alert = UIAlertController(title: "My alert", message: json["title"].stringValue, preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                (result : UIAlertAction) -> Void in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        }
                        break
                      case .failure(let error):
                      if error._code == NSURLErrorTimedOut {
                         DispatchQueue.main.async {
                            let alert = UIAlertController(title: "My alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                              (result : UIAlertAction) -> Void in
                          }))
                          self.present(alert, animated: true, completion: nil)
                         }
                      }
                        break
                    }
                }
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
    func StartTimer()
    {
        self.timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.LocalNotificationApiCalling), userInfo: nil, repeats: true)
       
    }
    func stopTimer()
            {
                if Notificationtimer != nil {
                    print("TimmerNilInvalidate")
                    Notificationtimer?.invalidate()
                    Notificationtimer = nil
//                    self.StartTimer()
                }else{
                    Notificationtimer?.invalidate()
                    Notificationtimer = nil
                    TimmerNil = "TimmerNil"
                    
    //                self.StartTimer()

                }
            }
    @objc func LocalNotificationApiCalling()
    {
        
        self.CreateNotification()
    }
    @objc func CreateNotification()
        {
            self.FromTimmerNoti = "FromTimmerNoti"
            NotificationHistoryCount()
//            let content = UNMutableNotificationContent()
//            content.title = "iOS"
//            content.subtitle = "Developer Testingg"
//            content.body = "iOS Developer Testing Notificationss"
//            content.sound = UNNotificationSound.default
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
//            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { (error) in
//                print(error as Any)
//    //            print(self.Notificationtimer)
//    //                    self.Notificationtimer!.invalidate()
//
//            }
    //        self.StartTimer()
            
        }
    @objc func yourfunction(notfication: NSNotification) {
        print("xxx")
        self.timer?.invalidate()
        self.timer = nil
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "TestIdentifier" {
            print("handling notifications with the TestIdentifier Identifier")
            let notificationVc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController")as? NotificationsViewController
            self.navigationController?.pushViewController(notificationVc!, animated: true)
        }
        completionHandler()
    }
    func NotificationHistoryCount()
    {
                if Connectivity.isConnectedToInternet {
//                    DispatchQueue.main.async {
//                        MBProgressHUD.showAdded(to: self.view, animated: true)
//                    }

                    let par = MyStrings().NotificationsAlerts
                    let token =  UserDefaults.standard.string(forKey: "Token")!
                    var request = URLRequest(url: URL(string: par)!,timeoutInterval: Double.infinity)
                   request.addValue(token, forHTTPHeaderField: "Authorization")
                   request.httpMethod = "GET"
                   let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    }
                     guard let data = data else {
                        DispatchQueue.main.async {
                       print(String(describing: error))
                        let alert = UIAlertController(title: "My alert", message: (String(describing: error)), preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            (result : UIAlertAction) -> Void in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        }
                       return
                     }
                     
                     print(String(data: data, encoding: .utf8)!)
                     let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                     print(json)
                    if json.count == 0
                    {
                        
                    }else{
                        DispatchQueue.main.async {
                        print(String(json.count))
                            if self.FromTimmerNoti == "FromTimmerNoti"
                            {
                            let NotiCount =  UserDefaults.standard.string(forKey: "NotificationCount")!
                        print(NotiCount)
                            if let count = Int(NotiCount)
                            {
                                print(count)
                                print(json.count)

                                if json.count > count
                                {
                                        let dict = json[0].dictionaryValue
                                        let content = UNMutableNotificationContent()
                                        content.title = "AAH-ESS"
                                        content.subtitle = ""
                                        if let body = dict["text"]?.stringValue
                                        {
                                           content.body = body
                                        }else{
                                           content.body = ""
                                        }
                                        
                                        content.sound = UNNotificationSound.default
                                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
                                        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
                                        UNUserNotificationCenter.current().add(request) { (error) in
                                            print(error as Any)
                                //            print(self.Notificationtimer)
                                //                    self.Notificationtimer!.invalidate()
                                            
                                        }
                                        //        self.StartTimer()
                                    self.NotificationsCount = String(json.count)
                                    UserDefaults.standard.set(self.NotificationsCount, forKey: "NotificationCount")
                                      DispatchQueue.main.async {
                                    self.NotificationItem1.badgeText = self.NotificationsCount
                                      }
                                   
                                                
                                            
                                }else{
                                self.NotificationsCount = String(json.count)
                                 UserDefaults.standard.set(self.NotificationsCount, forKey: "NotificationCount")
                                   DispatchQueue.main.async {
                                 self.NotificationItem1.badgeText = self.NotificationsCount
                                   }
                                }
                                }
                            }else{
                                self.NotificationsCount = String(json.count)
                                UserDefaults.standard.set(self.NotificationsCount, forKey: "NotificationCount")
                                DispatchQueue.main.async {
                                    self.NotificationItem1.badgeText = self.NotificationsCount

                                }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UNUserNotificationCenter.current().delegate = self
//        self.StartTimer()
        let logo = UIImage(named: "logo1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor.white)
        self.navigationItem.titleView = imageView
    //SideMenuCode
                   let left = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sideMenuViewController") as? sideMenuViewController
                   leftViewController = left
                   leftViewWidth = view.frame.size.width - 110
                   leftViewPresentationStyle = .slideAbove
                   
                   //TapGestureCode
                   let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
                   mytapGestureRecognizer.numberOfTapsRequired = 1
                   self.AlphaView.addGestureRecognizer(mytapGestureRecognizer)
                   mytapGestureRecognizer.delegate = self as UIGestureRecognizerDelegate
                   
                   //Left & Right SwipeCode
                   let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MySwipeLeft))
                   SwipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                   self.view.addGestureRecognizer(SwipeLeft)
                   SwipeLeft.delegate = self
                   let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MySwipeRight))
                   SwipeRight.direction = UISwipeGestureRecognizer.Direction.right
                   self.view.addGestureRecognizer(SwipeRight)
                   SwipeRight.delegate = self
        let nc = NotificationCenter.default
               nc.post(name: .UserLoggedIn, object: nil)
               
               nc.addObserver(self, selector: #selector(yourfunction(notfication:)), name: .UserLoggedIn, object: nil)
               }
               @objc func myTapAction(recognizer: UITapGestureRecognizer)
               {
                   hideLeftView(animated: true, completionHandler: nil)
                   AlphaView.isHidden = true
                   
               }
               @objc func MySwipeLeft(recognizer: UITapGestureRecognizer)
               {
                   hideLeftView(animated: true, completionHandler: nil)
                   AlphaView.isHidden = true
               }
               @objc func MySwipeRight(recognizer: UITapGestureRecognizer)
               {
                   AlphaView.isHidden = false
                   showLeftView(animated: true, completionHandler: nil)
                   
               }
    @objc func chatButtonTapped3(sender: BadgeBarButtonItem!)
    {
        let notificationVc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController")as? NotificationsViewController
        self.navigationController?.pushViewController(notificationVc!, animated: true)
    }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    func notificationsListDetails()
    {
        self.notificationDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().NotificationsListInfo
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
                    let alert = UIAlertController(title: "My alert", message: "Notification list empty", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        (result : UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    }
                }else{
                 for (index,subJson):(String, JSON) in json {
                     print(index)
                     print(subJson)
                     let details = NotificationListModel.init(json: subJson)
                     self.notificationDetails.append(details)
                 }
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
    @IBAction func ClickOnSegment(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            self.RequestPopUp.isHidden = true
            self.TBV.isHidden = false
            notificationsListDetails()
        }else
        {
            self.RequestPopUp.isHidden = false
            self.TBV.isHidden = true
        }
    }
    @IBAction func ClickOnSideMenuBtn(_ sender: UIBarButtonItem)
       {
           if isLeftViewShowing
           {
               hideLeftView(animated: true, completionHandler: nil)
               AlphaView.isHidden = true
           }
           else
           {
               AlphaView.isHidden = false
               showLeftView(animated: true, completionHandler: nil)
           }
       }
    @IBAction func ClickOnMoreBtn(_ sender: Any)
    {
//        if #available(iOS 13.0, *) {
//         let vc = self.storyboard?.instantiateViewController(identifier: "dmsReqViewController")as! dmsReqViewController
//         self.navigationController?.pushViewController(vc, animated: true)
//
//         } else {
//             let vc = self.storyboard?.instantiateViewController(withIdentifier: "dmsReqViewController")as! dmsReqViewController
//             self.navigationController?.pushViewController(vc, animated: true)
//             
//        }
    }
    

    @IBAction func ClickOnLeaveListBtn(_ sender: Any)
    {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "LeavesListViewController")as! LeavesListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeavesListViewController")as! LeavesListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnBusinessTravelBtn(_ sender: Any)
    {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "businessTravelListViewController")as! businessTravelListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "businessTravelListViewController")as! businessTravelListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnFormalityListBtn(_ sender: Any) {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "formalityListViewController")as! formalityListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "formalityListViewController")as! formalityListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnItSupportBtn(_ sender: UIButton)
    {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "ItsupportListViewController")as! ItsupportListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItsupportListViewController")as! ItsupportListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnTrainingBtn(_ sender: UIButton)
    {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "TrainingListViewController")as! TrainingListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrainingListViewController")as! TrainingListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    @IBAction func ClickOnAllowanceListBtn(_ sender: Any) {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "allowanceListViewController")as! allowanceListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "allowanceListViewController")as! allowanceListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnReimbursmentBtn(_ sender: Any) {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "ReimbursmentListViewController")as! ReimbursmentListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReimbursmentListViewController")as! ReimbursmentListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func ClickOnDMSListBtn(_ sender: Any) {
        if #available(iOS 13.0, *) {
         let vc = self.storyboard?.instantiateViewController(identifier: "DMSListViewController")as! DMSListViewController
         self.navigationController?.pushViewController(vc, animated: true)

         } else {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "DMSListViewController")as! DMSListViewController
             self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @objc func approvalBtnBtnAction(sender: UIButton!)
    {
       let approval = self.notificationDetails[sender.tag].approvalUrl
        let theURL = URL(string: approval)  //use your URL
        let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
        let fileNameLessExt = theURL?.deletingPathExtension().lastPathComponent //somePDF
        self.ResponseID = String(fileNameLessExt!)
        print(self.ResponseID)
        let reqType = self.notificationDetails[sender.tag].name
        if reqType == "Allowance Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiAllowanceApprovalViewController")as! NotiAllowanceApprovalViewController
                vc.ResponseID = self.ResponseID
             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiAllowanceApprovalViewController")as! NotiAllowanceApprovalViewController
                vc.ResponseID = self.ResponseID

                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }else if reqType == "Reimbursment Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiReimbursmentApprovalViewController")as! NotiReimbursmentApprovalViewController
                vc.ResponseID = self.ResponseID

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiReimbursmentApprovalViewController")as! NotiReimbursmentApprovalViewController
                vc.ResponseID = self.ResponseID

                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }else if reqType == "Leave Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiLeaveRequestApprovalViewController")as! NotiLeaveRequestApprovalViewController
                vc.ResponseID = self.ResponseID

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiLeaveRequestApprovalViewController")as! NotiLeaveRequestApprovalViewController
                vc.ResponseID = self.ResponseID

                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }else if reqType == "DMS Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiDMSReqApprovalViewController")as! NotiDMSReqApprovalViewController
                vc.ResponseID = self.ResponseID

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiDMSReqApprovalViewController")as! NotiDMSReqApprovalViewController
                vc.ResponseID = self.ResponseID

                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }else if reqType == "Formality Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiFormalityApprovalViewController")as! NotiFormalityApprovalViewController
                vc.ResponseID = self.ResponseID

             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiFormalityApprovalViewController")as! NotiFormalityApprovalViewController
                vc.ResponseID = self.ResponseID

                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }else if reqType == "Business Travel Application"
        {
            if #available(iOS 13.0, *) {
             let vc = self.storyboard?.instantiateViewController(identifier: "NotiBusinessTravelReqApprovalViewController")as! NotiBusinessTravelReqApprovalViewController
                vc.ResponseID = self.ResponseID
             self.navigationController?.pushViewController(vc, animated: true)

             } else {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiBusinessTravelReqApprovalViewController")as! NotiBusinessTravelReqApprovalViewController
                vc.ResponseID = self.ResponseID
                 self.navigationController?.pushViewController(vc, animated: true)

            }
        }


         
     
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("1234567890")
        return text.filter {okayChars.contains($0) }
    }
}


extension NotifiViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.notificationDetails.count == 0 {
            return 0
        }else{
            return notificationDetails.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell")as! CustomTableViewCell
        cell.reqNameLbl.text = self.notificationDetails[indexPath.section].employeeName
        cell.reqTypeLbl.text = self.notificationDetails[indexPath.section].name
        cell.approvalBtn.tag = indexPath.section
        cell.approvalBtn.addTarget(self, action: #selector(self.approvalBtnBtnAction), for: .touchUpInside)
        
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.lightGray
        }
   
    
}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
extension Notification.Name {
    static let UserLoggedIn = Notification.Name("UserLoggedIn")
    //    static let argentina = Notification.Name("argentina")
}
