//
//  Allowance_ReqViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/25/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import MobileCoreServices
import Foundation


class Allowance_ReqViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var GetfileData: Data!
    var GetfileName: String = ""

    @IBOutlet weak var uploadFileView: UIView!
    let startDatePicker = UIDatePicker()
   var AllowanceTypeDetails : [AllowanceTypesModel] = []
    var AllowanceTypeId : String = ""
    var last15Char : String = ""
    @IBOutlet weak var uploadTimePathNameLbl: UILabel!
    @IBOutlet weak var AllowremarksTF: TextField!
     @IBOutlet weak var AllowbalanceTF: TextField!
     @IBOutlet weak var AlloweligibilityTF: TextField!
     @IBOutlet weak var AllowamountTF: TextField!
     @IBOutlet weak var AllowpaticularTF: TextField!

    @IBOutlet weak var toDateTF: TextField!
    @IBOutlet weak var fromDateTF: TextField!
    var myPickerView : UIPickerView!

    var fromDatePassingString : String = ""
    var toDatePassingString : String = ""
    
    //UploadPDF
       var FilePathUrl = NSURL()
       var File_Type : String = ""
       var PdfstrBase64 : String = ""
       var DocPath: URL!
       var fileData: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.AlloweligibilityTF.text = "0"
        self.AllowamountTF.text = "0"
        self.AlloweligibilityTF.backgroundColor = .lightGray
        self.AllowamountTF.backgroundColor = .lightGray
        self.AlloweligibilityTF.isUserInteractionEnabled = false
        self.AllowamountTF.isUserInteractionEnabled = false
       

        AllowanceTypesDetails()
            
        self.uploadFileView.layer.borderWidth = 1
        self.uploadFileView.layer.borderColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let logo = UIImage(named: "logo1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor.white)
        self.navigationItem.titleView = imageView

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
        if AllowanceTypeDetails.count == 0 {
         return 0
        }else{
       return AllowanceTypeDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AllowanceTypeDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.AllowpaticularTF.text = AllowanceTypeDetails[row].name
        self.AllowanceTypeId = String(AllowanceTypeDetails[row].allowanceTypeId)
        if self.AllowpaticularTF.text != ""
        {
            self.fetchEligibityBalance()
        }else{
            
        }
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
      AllowpaticularTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      AllowpaticularTF.resignFirstResponder()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == fromDateTF
        {
            showDatePicker()
        }else if textField == toDateTF
        {
            showDatePicker1()
        }else if textField == AllowpaticularTF
        {
            self.pickUp(AllowpaticularTF)
        }
    }
    @IBAction func ClickOnUploadFile(_ sender: Any)
    {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .import)
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
    @IBAction func ClickOnCancelBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    func AllowanceTypesDetails()
    {
        self.AllowanceTypeDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().AllowanceTypes
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
                     let details = AllowanceTypesModel.init(json: subJson)
                     self.AllowanceTypeDetails.append(details)
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
                let par = MyStrings().AllowanceEligibityBalance + String(self.AllowanceTypeId) + "/" + String(userId)
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
                DispatchQueue.main.async {
                self.AlloweligibilityTF.text = String(eligibilityAmount)
                self.AllowamountTF.text = String(balanceAmount)
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
    func showDatePicker()
       {
           startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }else{
        }
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
           
           self.fromDateTF.inputAccessoryView = toolbar
           self.fromDateTF.inputView = startDatePicker
           
       }
       @objc func donedatePicker()
       {
           
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
        let formatter1 = DateFormatter()
                       formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                       self.fromDatePassingString = formatter1.string(from: startDatePicker.date)
           self.fromDateTF.text = formatter.string(from: startDatePicker.date)
           self.view.endEditing(true)
       }
       
       @objc func cancelDatePicker()
       {
           self.view.endEditing(true)
       }
    
    func showDatePicker1()
    {
        startDatePicker.datePickerMode = .date
        startDatePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }else{
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.toDateTF.inputAccessoryView = toolbar
        self.toDateTF.inputView = startDatePicker
        
    }
    @objc func donedatePicker1()
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.toDatePassingString = formatter1.string(from: startDatePicker.date)
        self.toDateTF.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker1()
    {
        self.view.endEditing(true)
    }
   @IBAction func ClickOnSubmitBtn(_ sender: Any)
   {
    if self.AllowpaticularTF.text == ""
    {
        AllowpaticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        Toast.show(message: "Please enter paticulars", controller: self)
    }else if self.AllowamountTF.text == ""
    {
        AllowamountTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        Toast.show(message: "Please enter Allowance  Request amount", controller: self)
    }else if self.AllowbalanceTF.text == ""
    {
        AllowbalanceTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        Toast.show(message: "Please enter Allowance  balance", controller: self)
    }else if self.fromDateTF.text == ""
    {
        fromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        Toast.show(message: "Please enter from date", controller: self)
    }else if self.toDateTF.text == ""
    {
        toDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        Toast.show(message: "Please enter to date", controller: self)
    }else
    {
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
                                 "name": "AllowanceTypeId",
                                 "value": self.AllowanceTypeId,
                             ],
                             
                             [
                                 "name": "Amount",
                                 "value": self.AllowamountTF.text!,
                             ],
                             [
                                 "name": "Remarks",
                                 "value": self.AllowremarksTF.text!,
                             ],
                             [
                                 "name": "ApplicationFrom",
                                 "value": self.fromDatePassingString,
                             ],
                             [
                                 "name": "ApplicationTo",
                                 "value": self.toDatePassingString,
                             ],
                             
                             [
                                 "name": "AllowanceFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "AllowanceFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "AllowanceFile", fileName:
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
                   to: MyStrings().AddAllowanceApplications,method:HTTPMethod.post,
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
                               DispatchQueue.main.async {
                                 MBProgressHUD.hide(for: self.view, animated: true)
                             }
                               switch response.result {
                               case let .success(value):
                               let json = JSON(value)
                               print(json)
                               if json.count == 0 {
                                DispatchQueue.main.async {
                                 self.AskConfirmation(title: "My Alert", message: "Allowance Request Data Empty") { (result) in
                                    if result {
                                 self.navigationController?.popViewController(animated: true)
                                    } else {
                                        
                                    }
                                }
                                            }
                               }else{
                                DispatchQueue.main.async {
                                 self.AskConfirmation(title: "My Alert", message: "Allowance Request Added Successfully") { (result) in
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
//    func submitAllowanceApi()
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
//            multipartFormData.append(self.GetfileData, withName: "AllowanceFile", fileName:
//                                       self.GetfileName, mimeType: "application/pdf")
//                        let fileContent = String(data: self.GetfileData, encoding: .utf8)!
//
//
//            multipartFormData.append((self.AllowanceTypeId.data(using: .utf8))!, withName: "AllowanceTypeId")
//            multipartFormData.append((self.AllowamountTF.text!.data(using: .utf8))!, withName: "Amount")
//            multipartFormData.append((self.AllowremarksTF.text!.data(using: .utf8))!, withName: "Remarks")
//            multipartFormData.append((self.fromDatePassingString.data(using: .utf8))!, withName: "ApplicationFrom")
//            multipartFormData.append((self.toDatePassingString.data(using: .utf8))!, withName: "ApplicationTo")
//            multipartFormData.append((self.GetfileName.data(using: .utf8))!, withName: "AllowanceFile")
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
//                to: MyStrings().AddAllowanceApplications,
//                method: .post,
//                headers: headers,
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .success(let upload, _, _):
//                        upload.responseJSON { response in
//                            DispatchQueue.main.async {
//                                    MBProgressHUD.hide(for: self.view, animated: true)
//                                }
//                            print(" responses ")
//                            print(response)
//                              switch encodingResult {
//                                    case .success(let upload, _, _):
//                                      upload.response { [weak self] response in
//                                        guard let strongSelf = self else {
//                                          return
//                                        }
//                                        debugPrint(response)
//                                      }
//                                    case .failure(let encodingError):
//                                      print("error:\(encodingError)")
//                                    }
//
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
extension Allowance_ReqViewController: UIDocumentPickerDelegate{
    
    
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


