//
//  reimbursementReqViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/24/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import MobileCoreServices
import Foundation



class reimbursementReqViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var ReimbursmenParticularsDetails : [ReimbursmenParticularsModel] = []
    var RowIndex : Int = 0
    let startDatePicker = UIDatePicker()
    var fromDatePassingString : String = ""
    var toDatePassingString : String = ""
    var myPickerView : UIPickerView!
    var AllowanceTypeId = Int()
    var AllowanceTypeId1 = Int()

    var last15Char : String = ""
    //UploadPDF
    var FilePathUrl = NSURL()
    var File_Type : String = ""
    var PdfstrBase64 : String = ""
    var DocPath: URL!
    var fileData: Data!
    var GetfileData: Data!
    var GetfileName: String = ""
    var allowanceTypeIDArray = [String]()
    var remarksTFArray = [String]()
    var AmountTFArray = [String]()
    var fromDatePassingStringArray = [String]()
    var toDatePassingStringArray = [String]()
    var GetfileNameArray = [String]()
    
    var PssingallowanceTypeIDStr : String = ""
    var PassingremarksTFStr : String = ""
    var PassingAmountTFStr : String = ""
    var PassingfromDatePassingStr : String = ""
    var PassingtoDatePassingStr : String = ""
    var PassingGetfileNameStr : String = ""


    
    @IBOutlet weak var subMitBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var TBV: UITableView!
    var ListCount = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParticularsDetails()
        self.navigationController?.navigationBar.tintColor = UIColor.white

          let logo = UIImage(named: "logo1")
          let imageView = UIImageView(image:logo)
          imageView.contentMode = .scaleAspectFit
          imageView.setImageColor(color: UIColor.white)
          self.navigationItem.titleView = imageView
       
    }
    struct Connectivity {
          static let sharedInstance = NetworkReachabilityManager()!
          static var isConnectedToInternet:Bool {
              return self.sharedInstance.isReachable
          }
      }
    func ParticularsDetails()
    {
        self.ReimbursmenParticularsDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().ReimbursmentParticularsTypes
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
                   return
                 }
                 print(String(data: data, encoding: .utf8)!)
                let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                print(json)
                 for (index,subJson):(String, JSON) in json {
                     print(index)
                     print(subJson)
                     let details = ReimbursmenParticularsModel.init(json: subJson)
                     self.ReimbursmenParticularsDetails.append(details)
                 }
                
                DispatchQueue.main.async {

                    
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
    func fetchEligibityBalance()
    {
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let userId = UserDefaults.standard.integer(forKey: "employeeId")
                let par = MyStrings().ReimbursementEligibityBalance + String(self.AllowanceTypeId) + "/" + String(userId)
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
                   return
                 }
                 print(String(data: data, encoding: .utf8)!)
                let json = JSON.init(parseJSON:String(data: data, encoding: .utf8)!)
                print(json)
                let eligibilityAmount = json["eligibilityAmount"].intValue
                let balanceAmount = json["balanceAmount"].intValue
                let indexPath = IndexPath(row: self.RowIndex, section: 0)
                DispatchQueue.main.async {
                 let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
                cell.eligibilityTF.text = String(eligibilityAmount)
                cell.balanceTF.text = String(balanceAmount)
//                    cell.paticularTF.isUserInteractionEnabled = false
                }


                DispatchQueue.main.async {
              
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
    
    @IBAction func ClickOnSubmitBtn(_ sender: UIButton) {
            let indexPath = IndexPath(row: self.RowIndex, section: 0)
            let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
            let indexPath1 = IndexPath(row: 0, section: 0)
            let cell1 = self.TBV.cellForRow(at: indexPath1)as! CustomTableViewCell
            if cell1.paticularTF.text == ""
            {
                cell1.paticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter paticular", controller: self)
            }
            else if cell1.amountTF.text == ""
            {
                cell1.amountTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter amount", controller: self)
            }
            else if cell1.appFromDateTF.text == ""
            {
                cell1.appFromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter from date", controller: self)
            }else if cell1.appToDateTF.text == ""
            {
                cell1.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter to date", controller: self)
            }else if self.GetfileName == ""{
                cell1.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please Select File", controller: self)

            }else if cell.paticularTF.text == ""
            {
                cell.paticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter paticular", controller: self)
            }
            else if cell.amountTF.text == ""
            {
                cell.amountTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter amount", controller: self)
            }
            else if cell.appFromDateTF.text == ""
            {
                cell.appFromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter from date", controller: self)
            }else if cell.appToDateTF.text == ""
            {
                cell.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter to date", controller: self)
            }else{
                submitTrainingApi()
        }
        }
    func submitTrainingApi()
    {
            let indexPath = IndexPath(row: self.RowIndex, section: 0)
            let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
            let indexPath1 = IndexPath(row: 0, section: 0)
            let cell1 = self.TBV.cellForRow(at: indexPath1)as! CustomTableViewCell
            if cell1.paticularTF.text == ""
            {
                cell1.paticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter paticular", controller: self)
            }
            else if cell1.amountTF.text == ""
            {
                cell1.amountTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter amount", controller: self)
            }
            else if cell1.appFromDateTF.text == ""
            {
                cell1.appFromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter from date", controller: self)
            }else if cell1.appToDateTF.text == ""
            {
                cell1.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter to date", controller: self)
            }else if self.GetfileName == ""{
                cell1.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please Select File", controller: self)

            }else if cell.paticularTF.text == ""
            {
                cell.paticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter paticular", controller: self)
            }
            else if cell.amountTF.text == ""
            {
                cell.amountTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter amount", controller: self)
            }
            else if cell.appFromDateTF.text == ""
            {
                cell.appFromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter from date", controller: self)
            }else if cell.appToDateTF.text == ""
            {
                cell.appToDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter to date", controller: self)
            }else{
                if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                    print(self.allowanceTypeIDArray.count)
                  if self.allowanceTypeIDArray.count != 0
                    {
                       if cell.amountTF.text == ""
                       {
                           Toast.show(message: "Please enter amount", controller: self)
                       }else{
                        if let str = allowanceTypeIDArray[optional: 0] {
                            self.PssingallowanceTypeIDStr = str
                        } else {
                            self.PssingallowanceTypeIDStr = ""
                        }
                        if let str1 = remarksTFArray[optional: 0] {
                            self.PassingremarksTFStr = str1  // --> this still wouldn't run
                        } else {
                            self.PassingremarksTFStr = "" // --> this would be printed
                        }
                        if let str2 = AmountTFArray[optional: 0] {
                            self.PassingAmountTFStr = str2  // --> this still wouldn't run
                        } else {
                            self.PassingAmountTFStr = "" // --> this would be printed
                        }
                        if let str3 = fromDatePassingStringArray[optional: 0] {
                            self.PassingfromDatePassingStr = str3  // --> this still wouldn't run
                        } else {
                            self.PassingfromDatePassingStr = "" // --> this would be printed
                        }
                        if let str4 = toDatePassingStringArray[optional: 0] {
                            self.PassingtoDatePassingStr = str4 // --> this still wouldn't run
                        } else {
                             self.PassingtoDatePassingStr = "" // --> this would be printed
                        }
                        if let str5 = GetfileNameArray[optional: 0] {
                            self.PassingGetfileNameStr = str5 // --> this still wouldn't run
                        } else {
                            self.PassingGetfileNameStr = "" // --> this would be printed
                        }

                    submitedTrainingApi()
                        }
                  }else{
                    DispatchQueue.main.async {

                        let alert = UIAlertController(title: "My alert", message: "Please Select Allowance Type", preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            (result : UIAlertAction) -> Void in
                        }))
                        self.present(alert, animated: true, completion: nil)
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
    func submitedTrainingApi()
    {
        if Connectivity.isConnectedToInternet {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true)
                       }
        let makeRandom = { UInt32.random(in: (.min)...(.max)) }
               let boundary = String(format: "------------------------%08X%08X", makeRandom(), makeRandom())
                let token =  UserDefaults.standard.string(forKey: "Token")!
               let headers = [
                   "Authorization": token,
                   "Content-Type": "multipart/form-data; charset=text ; boundary=\(boundary)"
                   //"multipart/form-data; boundary=???",
               ]
                 let parameters = [
                             [
                                 "name": "ReimbursmentTypeId",
                                 "value": self.PssingallowanceTypeIDStr,
                             ],
                             
                             [
                                 "name": "Remarks",
                                 "value": self.PassingremarksTFStr,
                             ],
                             [
                                 "name": "Amount",
                                 "value": self.PassingAmountTFStr,
                             ],
                             [
                                 "name": "ApplicationFrom",
                                 "value": PassingfromDatePassingStr,
                             ],
                             [
                                 "name": "ApplicationTo",
                                 "value": PassingtoDatePassingStr,
                             ],
                            
                             [
                                 "name": "ReimbursmentFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "ReimbursmentFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "ReimbursmentFile", fileName:
                                                               self.GetfileName, mimeType: "application/pdf")
                               }
                           }
                           else {
                               multipartFormData.append((strRecord["value"] as AnyObject).data(using:
                                String.Encoding.utf8.rawValue)!, withName: strRecord["name"]! as! String)
                               print("MOdel Appened")
                           }
                       }
                   },
                   to: MyStrings().AddReimbursmentInfo,method:HTTPMethod.post,
                   headers:headers,
                   encodingCompletion: { encodingResult in
                       // ProgressHUDManager.showProgress(visibility: false)
                       
                       switch encodingResult {
                       case .success(let upload, _, _):
                           upload.validate(statusCode: 200..<600)
                           upload.uploadProgress { progress in
                               
                               print(progress.fractionCompleted)
                           }
                           upload.responseData { response in
                               DispatchQueue.main.async(execute: {() -> Void in
                               MBProgressHUD.hide(for: self.view, animated: true)
                               })
                               switch response.result {
                                  case let .success(value):
                                  let json = JSON(value)
                                  print(json)
                                  if json.count == 0 {
                                   DispatchQueue.main.async {
                                    self.AskConfirmation(title: "My Alert", message: "Reimbursement Request Data Empty") { (result) in
                                       if result {
                                    self.navigationController?.popViewController(animated: true)
                                       } else {
                                           
                                       }
                                   }
                                               }
                                  }else{
                                   DispatchQueue.main.async {
                                    self.AskConfirmation(title: "My Alert", message: "Reimbursement Request Added Successfully") { (result) in
                                       if result {
                                    self.navigationController?.popViewController(animated: true)
                                       } else {
                                           
                                       }
                                   }
                                               }
                                   }
                               
                                  case .success:
                                      print("Success")
                                   
                                  case .failure(let error):
                                      print(error)
                                      DispatchQueue.main.async {
                                       self.AskConfirmation(title: "My Alert", message: error.localizedDescription) { (result) in
                                          if result {
                                           self.navigationController?.popViewController(animated: true)
                                          } else {
                                              
                                          }
                                      }
                                                  }
                                  }
                           }
                       case .failure(let _):
                           print("error")
                           DispatchQueue.main.async {
                           }
                           
                       }
                   }
               )
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
//    func submitReimbursemntApi()
//        {
//            if Connectivity.isConnectedToInternet {
//            DispatchQueue.main.async {
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//            }
//            let token =  UserDefaults.standard.string(forKey: "Token")!
//            let boundary = "Boundary-\(UUID().uuidString)"
//            let headers = [
//                            "Authorization": token,
//                            "Content-Type": "multipart/form-data; boundary=\(boundary)"
//                                  //"multipart/form-data; boundary=???",
//                              ]
//            Alamofire.upload(
//
//                multipartFormData: {
//                    multipartFormData in
//
//
//                    let data : Data = self.GetfileData
//                    DispatchQueue.main.async {
//            multipartFormData.append(self.GetfileData, withName: "ReimbursmentFile", fileName:
//                                       self.PassingGetfileNameStr, mimeType: "application/pdf")
//            multipartFormData.append((self.PssingallowanceTypeIDStr.data(using: .utf8))!, withName: "ReimbursmentTypeId")
//            multipartFormData.append((self.PassingremarksTFStr.data(using: .utf8))!, withName: "Remarks")
//            multipartFormData.append((self.PassingAmountTFStr.data(using: .utf8))!, withName: "Amount")
//            multipartFormData.append((self.PassingfromDatePassingStr.data(using: .utf8))!, withName: "ApplicationFrom")
//            multipartFormData.append((self.PassingtoDatePassingStr.data(using: .utf8))!, withName: "ApplicationTo")
//
//
//            multipartFormData.append((self.PassingGetfileNameStr.data(using: .utf8))!, withName: "ReimbursmentFile")
//                    }
//                        print("Multi part Content -Type")
//                        print(multipartFormData.contentType)
//                        print("Multi part FIN ")
//                        print("Multi part Content-Length")
//                        print(multipartFormData.contentLength)
//                        print("Multi part Content-Boundary")
//                        print(multipartFormData.boundary)
//
//            },
//                to: MyStrings().AddReimbursmentInfo,
//                method: .post,
//                headers: headers,
//                encodingCompletion: { encodingResult in
//
//                    switch encodingResult {
//
//                    case .success(let upload, _, _):
//                        upload.responseJSON { response in
//                            print(" responses ")
//                            print(response)
//                            switch response.result {
//                            case let .success(value):
//                                let json = JSON(value)
//                                print(json)
//                                if json.count == 0
//                                {
//                                    DispatchQueue.main.async {
//                                    self.AskConfirmation(title: "My Alert", message: "Reimbursement Request Data Empty") { (result) in
//                                    if result {
//                                     self.navigationController?.popViewController(animated: true)
//                                    } else {
//
//                                    }
//                                    }
//                                    }
//                                }else{
//                                    DispatchQueue.main.async {
//                                    self.AskConfirmation(title: "My Alert", message: "Reimbursement Request Added Successfully") { (result) in
//                                    if result {
//                                     self.navigationController?.popViewController(animated: true)
//                                    } else {
//
//                                    }
//                                    }
//                                    }
//
//
//                                }
//                                break
//                              case .failure(let error):
//                              if error._code == NSURLErrorTimedOut {
//                                 DispatchQueue.main.async {
//                                    let alert = UIAlertController(title: "My alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//
//                                  alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
//                                      (result : UIAlertAction) -> Void in
//                                  }))
//                                  self.present(alert, animated: true, completion: nil)
//                                 }
//                              }
//                                break
//                            }
//
//
//                        }
//                    case .failure(let encodingError):
//                        print(encodingError.localizedDescription)
//    //                    onCompletion(false, "Something bad happen...", 200)
//                        DispatchQueue.main.async {
//                           let alert = UIAlertController(title: "My alert", message: encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//
//                         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
//                             (result : UIAlertAction) -> Void in
//                         }))
//                         self.present(alert, animated: true, completion: nil)
//                        }
//
//                    }
//            })
//            }else{
//                    DispatchQueue.main.async {
//
//                         let alert = UIAlertController(title: "My alert", message: "Internet not available, Cross check your internet connectivity and try again", preferredStyle: UIAlertController.Style.alert)
//
//                         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
//                             (result : UIAlertAction) -> Void in
//                         }))
//                         self.present(alert, animated: true, completion: nil)
//                     }
//            }
//        }
    
    
    @IBAction func ClickOnAddBtn(_ sender: UIButton) {
        self.ListCount.append("1")
        DispatchQueue.main.async {
            self.TBV.reloadData()
        }
    }
    @objc func removeBtnAction(sender: UIButton!)
    {
        let indexPath = IndexPath(item: sender.tag, section: 0);
        let  cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.paticularTF.text = ""
        cell.appFromDateTF.text = ""
        cell.appToDateTF.text = ""

        self.ListCount.remove(at: indexPath.row)
        DispatchQueue.main.async {
            self.TBV.reloadWithAnimation()
        }
    }
    @objc func ReimpaticBtnBtnAction(sender: UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
               print(sender.tag)
               print(indexPath.row)
               self.RowIndex = indexPath.row
               print(self.RowIndex)
               let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.paticularTF.isUserInteractionEnabled = true
        DispatchQueue.main.async {
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.reloadAllComponents()

        self.myPickerView.backgroundColor = UIColor.white
        cell.paticularTF.inputView = self.myPickerView

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cell.paticularTF.inputAccessoryView = toolBar

         }

    }
    @objc func ReimAppFromDateBTnAction(sender: UIButton!)
    {
      let indexPath = IndexPath(row: sender.tag, section: 0)
       self.RowIndex = indexPath.row
        print(sender.tag)

        print(self.RowIndex)
       let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.appFromDateTF.isUserInteractionEnabled = true
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }else{
        }
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
         toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
         
         cell.appFromDateTF.inputAccessoryView = toolbar
         cell.appFromDateTF.inputView = startDatePicker
        
    }
    @objc func donedatePicker()
    {
        print(self.RowIndex)
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
           let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.appFromDateTF.isUserInteractionEnabled = false
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
      let formatter1 = DateFormatter()
      formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        cell.appFromDateTF.text = formatter.string(from: startDatePicker.date)
        self.fromDatePassingString = formatter1.string(from: startDatePicker.date)
        self.fromDatePassingStringArray.append(self.fromDatePassingString)

        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
    }
    @objc func ReimAppToDateBTnAction(sender: UIButton!)
    {
       let indexPath = IndexPath(row: sender.tag, section: 0)
       self.RowIndex = indexPath.row
        print(self.RowIndex)
       let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
       cell.appToDateTF.isUserInteractionEnabled = true
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }else{
        }
                   let toolbar = UIToolbar();
                   toolbar.sizeToFit()
                   let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
                   let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                   let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
                   toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                   
                   cell.appToDateTF.inputAccessoryView = toolbar
                   cell.appToDateTF.inputView = startDatePicker
    }
    @objc func donedatePicker1()
    {
        print(self.RowIndex)
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.appToDateTF.isUserInteractionEnabled = false
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
      let formatter1 = DateFormatter()
     formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
     self.toDatePassingString = formatter1.string(from: startDatePicker.date)
        self.toDatePassingStringArray.append(self.toDatePassingString)
        if cell.amountTF.text != ""
        {
        self.AmountTFArray.append(cell.amountTF.text!)
        }else{
            
        }
     cell.appToDateTF.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker1()
    {
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
     }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ReimbursmenParticularsDetails.count == 0 {
         return 0
        }else{
       return ReimbursmenParticularsDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ReimbursmenParticularsDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.RowIndex)
       let indexPath = IndexPath(row: self.RowIndex, section: 0)
        print(indexPath)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        
        cell.paticularTF.text = ReimbursmenParticularsDetails[row].name
        self.AllowanceTypeId = ReimbursmenParticularsDetails[row].reimbursmentTypeId
        if cell.paticularTF.text != ""
        {
            self.fetchEligibityBalance()
        }else{
            
        }
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
        print(self.RowIndex)
       let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        self.AllowanceTypeId1 = self.AllowanceTypeId
        self.allowanceTypeIDArray.append(String(self.AllowanceTypeId1))
        print(self.allowanceTypeIDArray)
        print(self.allowanceTypeIDArray.count)

        
      cell.paticularTF.resignFirstResponder()
        self.view.endEditing(true)
     }
    @objc func   cancelClick() {
        print(self.RowIndex)
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
      cell.paticularTF.resignFirstResponder()
        self.view.endEditing(true)
    }
    @objc func ReimUploadBtnAction(sender: UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.RowIndex = indexPath.row
        print(self.RowIndex)
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .pageSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func saveBase64StringToPDF(_ base64String: String) {
        
        guard
            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
            let convertedData = Data(base64Encoded: base64String)
            else {
                //handle error when getting documents URL
                return
        }
        //name your file however you prefer
         documentsURL.appendPathComponent("yourFileName.pdf")
        
        
        do {
            try convertedData.write(to: documentsURL)
        } catch {
            //handle write error here
        }

    }
    fileprivate func downloadfile(URL: NSURL) {
           let sessionConfig = URLSessionConfiguration.default
           let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
           var request = URLRequest(url: URL as URL)
           request.httpMethod = "GET"
           let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
               if (error == nil) {
                   // Success
                   let statusCode = response?.mimeType
                   print("Success: \(String(describing: statusCode))")
                   DispatchQueue.main.async(execute: {
                       self.p_uploadDocument(data!, filename: URL.lastPathComponent!)
                   })

                   // This is your file-variable:
                   // data
               }
               else {
                   // Failure
                   print("Failure: %@", error!.localizedDescription)
               }
           })
           task.resume()
       }
       fileprivate func p_uploadDocument(_ file: Data,filename : String) {

           print(file)
           print(filename)
           self.GetfileData = file
           self.GetfileName = filename
        self.GetfileNameArray.append(self.GetfileName)
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
         let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.uploadTimePathNameLbl.text = self.GetfileName
        if cell.remarksTF.text != ""
        {
        self.remarksTFArray.append(cell.remarksTF.text!)
        }else{
            
        }


//           self.uplo.text = self.GetfileName

          
       }
}
extension reimbursementReqViewController: UIDocumentPickerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
           let cico = url as URL
           print(cico)
           self.downloadfile(URL: cico as NSURL)
       }
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension reimbursementReqViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ListCount.count == 0
        {
            return 0
        }else{
            return ListCount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.TBV.dequeueReusableCell(withIdentifier: "CustomTableViewCell23")as!CustomTableViewCell
        cell.uploadFileView.layer.borderWidth = 1
        cell.uploadFileView.layer.borderColor = UIColor.lightGray.cgColor
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(self.removeBtnAction), for: .touchUpInside)
        cell.ReimpaticBtn.tag = indexPath.row
        cell.ReimpaticBtn.addTarget(self, action: #selector(self.ReimpaticBtnBtnAction), for: .touchUpInside)
        cell.ReimAppFromDateBTn.tag = indexPath.row
        cell.ReimAppFromDateBTn.addTarget(self, action: #selector(self.ReimAppFromDateBTnAction), for: .touchUpInside)
        cell.ReimAppToDateBTn.tag = indexPath.row
        cell.ReimAppToDateBTn.addTarget(self, action: #selector(self.ReimAppToDateBTnAction), for: .touchUpInside)
        cell.ReimUploadBtn.tag = indexPath.row
        cell.ReimUploadBtn.addTarget(self, action: #selector(self.ReimUploadBtnAction), for: .touchUpInside)

//        cell.eligibilityTF.text = "0"
//        cell.amountTF.text = "0"
        cell.eligibilityTF.backgroundColor = .lightGray
        cell.balanceTF.backgroundColor = .lightGray
        cell.eligibilityTF.isUserInteractionEnabled = false
        cell.balanceTF.isUserInteractionEnabled = false

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}
