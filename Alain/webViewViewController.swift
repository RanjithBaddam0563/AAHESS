//
//  webViewViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/16/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import WebKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import Kingfisher

class webViewViewController: UIViewController , WKUIDelegate{

    var associatedFile : String = ""
    var webView: WKWebView!

    var navTitle : String = ""
    var checkFrom : String = ""
    var fileUrlStr : String = ""

    var salarySlipId : String = ""
    
    override func loadView() {
          super.loadView()
        self.title = self.navTitle
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          webView.uiDelegate = self
          view = webView
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkFrom == "formality"
        {
        if let url = URL(string: fileUrlStr) {
            print(url)
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
            }
          
        }else{
            print("Nil")
        }
        }else{
          FetchSalarySlipInfoDetails()
        }
        // Do any additional setup after loading the view.
    }
    struct Connectivity {
              static let sharedInstance = NetworkReachabilityManager()!
              static var isConnectedToInternet:Bool {
                  return self.sharedInstance.isReachable
              }
          }
          func FetchSalarySlipInfoDetails()
          {
                  if Connectivity.isConnectedToInternet {
                      DispatchQueue.main.async {
                          MBProgressHUD.showAdded(to: self.view, animated: true)
                      }
                      let par = MyStrings().SalarySlipsPDF
                    let params = par + "/" + self.salarySlipId
                      print(params)
                      let token =  UserDefaults.standard.string(forKey: "Token")!
                      var request = URLRequest(url: URL(string: params)!,timeoutInterval: Double.infinity)
                     request.addValue(token, forHTTPHeaderField: "Authorization")

                     request.httpMethod = "GET"

                     let task = URLSession.shared.dataTask(with: request) { data, response, error in
                      DispatchQueue.main.async {
                      MBProgressHUD.hide(for: self.view, animated: true)
                      }
                       if error?.localizedDescription == "The request timed out."
                       {
                          DispatchQueue.main.async {
                           let alert = UIAlertController(title: "My alert", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                               (result : UIAlertAction) -> Void in
                           }))
                           self.present(alert, animated: true, completion: nil)
                          }
                       }
                       guard let data = data else {
                         print(String(describing: error))
                            let alert = UIAlertController(title: "My alert", message: String(describing: error), preferredStyle: UIAlertController.Style.alert)

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
                             let alert = UIAlertController(title: "My alert", message: "Salary slip list empty", preferredStyle: UIAlertController.Style.alert)

                             alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                                 (result : UIAlertAction) -> Void in
                             }))
                             self.present(alert, animated: true, completion: nil)
                            }
                        }else{
                        self.associatedFile = json["associatedFile"].stringValue
                        let str =  "https://hrd.alainholding.ae/" + self.associatedFile
                        print(str)
                          let escapedString = str.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                          let urlNew:String = escapedString!.replacingOccurrences(of: "%5C", with: "//").trimmed
                            if let url = URL(string: urlNew) {
                                print(url)
                                let request = URLRequest(url: url)
                                DispatchQueue.main.async {
                                    self.webView.load(request)
                                }
                            }else{
                             print("Nil")
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
    
}

