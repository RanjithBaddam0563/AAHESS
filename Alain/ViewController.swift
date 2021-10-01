//
//  ViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/18/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Material


class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTF: FormTextField!
    @IBOutlet weak var userNameTf: FormTextField!
    var UDID_Ios = String()

    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.userNameTf.text = "syed.abdulrahman"
//        self.passwordTF.text = "Newrakesh@#$234"
        self.navigationItem.setHidesBackButton(true, animated: true);
//        self.userNameTf.text = "Lancy.sequeira"
//        self.passwordTF.text = "Sonrahntha%5"

    }
   

    @IBAction func ClickOnLogin(_ sender: Any)
    {
        if userNameTf.text == "" {
            self.userNameTf.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter user name", controller: self)
        }else if passwordTF.text == "" {
            self.passwordTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter password", controller: self)
        }else if userNameTf.text!.count <= 6 {
            self.userNameTf.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "User name must be 6 characters", controller: self)
        }else{
            let KUserDefault = UserDefaults.standard
            let tocken = KUserDefault.value(forKey: "FCMToken")as! String
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
               let parameters: [String: Any] = [
                "username" : self.userNameTf.text!,
                "password" : self.passwordTF.text!,
                "DeviceType" : "IOS",
                "Uid" : tocken,
                "AuthorizationKey" : "AAAA3vnDydY:APA91bGuzj1sKISy1gcyvAkC5r77Ip7Y5N92sFtsouBtCO1LeedlVmJEBoWJWH7Hz12FtT8p-InnEzTDDN4FsJ_SFbvsdgQtBSQCGEkXpuxo7vF6-FUSmJWRVdcXuHb9UFWFbr4tAST5"
                ]
                print(parameters)
                Alamofire.request(MyStrings().loginUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        }
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
                                UserDefaults.standard.set(self.userNameTf.text!, forKey: "UserName")
                                UserDefaults.standard.set(self.passwordTF.text!, forKey: "Password")


                               self.MyGeneralInfo()
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
    }
    @IBAction func ClickOnForgotPassword(_ sender: UIButton)
    {
         DispatchQueue.main.async {
                       if #available(iOS 13.0, *) {
                        let vc = self.storyboard?.instantiateViewController(identifier: "forgotPasswordViewController")as! forgotPasswordViewController
                        self.navigationController?.pushViewController(vc, animated: true)

                        } else {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotPasswordViewController")as! forgotPasswordViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                       }
                   }
        
    }
    func MyGeneralInfo()
    {
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
          
            let token =  UserDefaults.standard.string(forKey: "Token")!

            print(MyStrings().MyGeneralInfo)
            var request = URLRequest(url: URL(string: MyStrings().MyGeneralInfo)!,timeoutInterval: Double.infinity)
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
            let email = json["email"].stringValue
            UserDefaults.standard.set(email, forKey: "email") //setObject

            let adUserName = json["adUserName"].stringValue
            let firstName = json["firstName"].stringValue
            UserDefaults.standard.set(firstName, forKey: "firstName") //setObject
            let middleName = json["middleName"].stringValue
            UserDefaults.standard.set(middleName, forKey: "middleName") //setObject
            let lastName = json["lastName"].stringValue
            UserDefaults.standard.set(lastName, forKey: "lastName") //setObject
            let employeeId = json["employeeId"].intValue
            UserDefaults.standard.set(employeeId, forKey: "employeeId")  //Integer
            let userCode = json["userCode"].stringValue
            UserDefaults.standard.set(userCode, forKey: "userCode") //setObject
            let signURL = json["signURL"].stringValue
            let employeeCategoryId = json["employeeCategoryId"].intValue
            UserDefaults.standard.set(employeeCategoryId, forKey: "employeeCategoryId")  //Integer
            let jobTitle = json["jobTitle"].stringValue
            UserDefaults.standard.set(jobTitle, forKey: "jobTitle") //setObject
            let department = json["department"].stringValue
            UserDefaults.standard.set(department, forKey: "Department") //setObject

            let branch = json["branch"].stringValue
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                 let vc = self.storyboard?.instantiateViewController(identifier: "NotifiViewController")as! NotifiViewController
                 self.navigationController?.pushViewController(vc, animated: true)

                 } else {
                     let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotifiViewController")as! NotifiViewController
                     self.navigationController?.pushViewController(vc, animated: true)
                     
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
    private static var manager: Alamofire.SessionManager = {

           // Create the server trust policies
           let serverTrustPolicies: [String: ServerTrustPolicy] = [
               "test.example.com": .disableEvaluation
           ]

           // Create custom manager
           let configuration = URLSessionConfiguration.default
           configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
           let manager = Alamofire.SessionManager(
               configuration: URLSessionConfiguration.default,
               serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
           )

           return manager
       }()
   
}


