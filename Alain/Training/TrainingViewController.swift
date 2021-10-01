//
//  TrainingViewController.swift
//  Alain
//
//  Created by MicroExcel on 9/24/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import MobileCoreServices
import Foundation

class TrainingViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var uploadFileView: UIView!
    var myPickerView : UIPickerView!
    var DepartmentTypeDetails : [DepartmentTypeModel] = []

    var DepartmentId : String = ""
    var GetfileData: Data!
    var GetfileName: String = ""
    @IBOutlet weak var uploadTimePathNameLbl: UILabel!

    
    

    @IBOutlet var RemarksTF: TextField!
    @IBOutlet var TotalFeesTF: TextField!
    @IBOutlet var OtherExpensesTF: TextField!
    @IBOutlet var TrainingFeesTF: TextField!
    @IBOutlet var BalanceTF: TextField!
    @IBOutlet var ActualTF: TextField!
    @IBOutlet var BudgetTF: TextField!
    @IBOutlet var DepartmentTF: TextField!
    @IBOutlet var NumberOfDaysTF: TextField!
    @IBOutlet var VenueTF: TextField!
    @IBOutlet var ConductedByTF: TextField!
    @IBOutlet var TrainingNameTf: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        DepartmentTypeList()
        // Do any additional setup after loading the view.
        let logo = UIImage(named: "logo1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor.white)
        self.navigationItem.titleView = imageView
        self.uploadFileView.layer.borderWidth = 1
        self.uploadFileView.layer.borderColor = UIColor.lightGray.cgColor
    }
   @IBAction func ClickOnCancelBtn(_ sender: UIButton)
      {
          self.navigationController?.popViewController(animated: true)
      }
      
    @IBAction func ClickOnUploadFile(_ sender: UIButton)
    {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .pageSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    @IBAction func ClickOnSubmit(_ sender: UIButton)
      {
        if TrainingNameTf.text == "" {
            TrainingNameTf.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter training name", controller: self)
        }else if ConductedByTF.text == "" {
            ConductedByTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter conducted by", controller: self)
        }else if DepartmentTF.text == "" {
            DepartmentTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please choose department", controller: self)
        }else if TrainingFeesTF.text == "" {
            TrainingFeesTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter training fee", controller: self)
        }else if TotalFeesTF.text == "" {
            TotalFeesTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter total fee", controller: self)
        }else{
            submitTrainingApi()
        }
      }
   
    func submitTrainingApi()
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
                                 "name": "trainingName",
                                 "value": TrainingNameTf.text!,
                             ],
                             
                             [
                                 "name": "conductedBy",
                                 "value": ConductedByTF.text!,
                             ],
                             [
                                 "name": "venue",
                                 "value": VenueTF.text!,
                             ],
                             [
                                 "name": "numberOfDays",
                                 "value": NumberOfDaysTF.text!,
                             ],
                             [
                                 "name": "trainingFees",
                                 "value": TrainingFeesTF.text!,
                             ],
                             [
                                 "name": "otherExpenses",
                                 "value": OtherExpensesTF.text!,
                             ],
                             [
                                 "name": "totalFees",
                                 "value": TotalFeesTF.text!,
                             ],
                             [
                                 "name": "departmentId",
                                 "value": DepartmentId,
                             ],
                             [
                                 "name": "remarks",
                                 "value": RemarksTF.text!,
                             ],
                             [
                                 "name": "TrainingFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "TrainingFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "TrainingFile", fileName:
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
                   to: MyStrings().submitTrainingReq,method:HTTPMethod.post,
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
                            let status = response.response?.statusCode
                            print("STATUS \(status)")
                               switch response.result {
                                
                                  case let .success(value):
                                  let json = JSON(value)
                                  print(json)
                                  if json.count == 0 {
                                   DispatchQueue.main.async {
                                    self.AskConfirmation(title: "My Alert", message: "Training Request Data Empty") { (result) in
                                       if result {
                                    self.navigationController?.popViewController(animated: true)
                                       } else {
                                           
                                       }
                                   }
                                               }
                                  }else{
                                   DispatchQueue.main.async {
                                    self.AskConfirmation(title: "My Alert", message: "Training Request Added Successfully") { (result) in
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
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
         if textField == DepartmentTF
        {
            self.pickUp(DepartmentTF)

        }
    }
    func pickUp(_ textField : UITextField){

    // UIPickerView
    self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    self.myPickerView.delegate = self
    self.myPickerView.dataSource = self
    self.myPickerView.backgroundColor = UIColor.white
    textField.inputView = self.myPickerView

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
    textField.inputAccessoryView = toolBar

     }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
     }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if DepartmentTypeDetails.count == 0 {
         return 0
        }else{
       return DepartmentTypeDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DepartmentTypeDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.DepartmentTF.text = DepartmentTypeDetails[row].name
        self.DepartmentId = String(DepartmentTypeDetails[row].departmentId)
        if self.DepartmentTF.text == "" {
            
        }else{
           BurgetActualBalanceInfoApi()
        }
        
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
      DepartmentTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      DepartmentTF.resignFirstResponder()
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    func DepartmentTypeList()
        {
            self.DepartmentTypeDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().DepartmentTypeInfo
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
                     let details = DepartmentTypeModel.init(json: subJson)
                     self.DepartmentTypeDetails.append(details)
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
    func BurgetActualBalanceInfoApi()
    {
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().BudgetActualBalanceInfo + self.DepartmentId
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
            if json.count == 0
             {
                 DispatchQueue.main.async {
                    self.BudgetTF.text = ""
                    self.ActualTF.text = ""
                    self.BalanceTF.text = ""

                 }
            }else{
                    let budgetAmount = json["budgetAmount"].intValue
                    let availedAmount = json["availedAmount"].intValue
                    let balanceAmount = json["balanceAmount"].intValue
                    DispatchQueue.main.async {
                    self.BudgetTF.text = String(budgetAmount)
                    self.ActualTF.text = String(availedAmount)
                    self.BalanceTF.text = String(balanceAmount)

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
        self.uploadTimePathNameLbl.text = self.GetfileName

    }
}
    
    
    

extension TrainingViewController: UIDocumentPickerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        print(cico)
//        NSData *datadat = [[NSData alloc] initWithContentsOfFile:path];

        self.downloadfile(URL: cico as NSURL)
    }
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
