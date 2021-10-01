//
//  dmsReqViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/19/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import MobileCoreServices

class dmsReqViewController: UIViewController,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var sapPostingTF: TextField!
    @IBOutlet weak var sapDocTF: TextField!
    @IBOutlet weak var sapRefTF: TextField!
    @IBOutlet weak var DMSApprovalCV: UICollectionView!
    var DMSDepDetails : [DMSDepModel] = []
    var DMSDepProcessNameDetails : [DMSDepProcessModel] = []
    var DMSDepApprovalDetails : [DMSDepApprovalModel] = []
    var DMSDepApprovalListDetails = [[String: Any]]()
    var last15Char : String = ""
     @IBOutlet weak var uploadTimePathNameLbl: UILabel!
    var DepartmentId : String = ""
    var DepProcessNameId : String = ""

    var SendingPath : String = ""
    var tempUrlS: URL!

    var textFieldName : String = ""
    
    @IBOutlet weak var docReference: UITextField!
    @IBOutlet weak var processNameTF: UITextField!
    @IBOutlet weak var deparmentTF: UITextField!
    @IBOutlet weak var uploadFileView: UIView!
    @IBOutlet weak var docRefView: UIView!
    var myPickerView : UIPickerView!
    //UploadPDF
    var FilePathUrl = NSURL()
    var File_Type : String = ""
    var PdfstrBase64 : String = ""
    var DocPath: URL!
    var GetfileData: Data!
    var GetfileName: String = ""

    @IBOutlet weak var txtView: UITextView!
    override func viewWillAppear(_ animated: Bool)
       {
           self.navigationController?.navigationBar.isHidden = false
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
    @IBAction func ClickOnUploadfileBtn(_ sender: Any)
    {
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
    public func textFieldDidBeginEditing(_ textField: UITextField)
       {
           if textField == deparmentTF
           {
            textFieldName = "deparment"
            self.pickUp(deparmentTF)
           }else if textField == processNameTF
           {
            if deparmentTF.text == "" {
                processNameTF.resignFirstResponder()
                deparmentTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please choose deparment", controller: self)
            }else{
               textFieldName = "processName"
               self.pickUp(processNameTF)
            }
           }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
        }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFieldName == "deparment"{
           if DMSDepDetails.count == 0 {
            return 0
           }else{
          return DMSDepDetails.count
           }
        }else{
           if DMSDepProcessNameDetails.count == 0 {
            return 0
           }else{
          return DMSDepProcessNameDetails.count
           }
        }
    }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textFieldName == "deparment"{
           return DMSDepDetails[row].name
        }else{
           return DMSDepProcessNameDetails[row].name
        }
         }
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textFieldName == "deparment"{
           self.deparmentTF.text = DMSDepDetails[row].name
           self.DepartmentId = String(DMSDepDetails[row].dmsCategoryId)
            DMSDepartmentProcessNameInfo()
        }else{
            self.processNameTF.text = DMSDepProcessNameDetails[row].name
            self.DepProcessNameId = String(DMSDepProcessNameDetails[row].dmsSubCategoryId)
            DmsReqApprovalList()
        }
        }
        //MARK:- TextFiled Delegate

       
       @objc func   doneClick() {
        if textFieldName == "deparment"{
         deparmentTF.resignFirstResponder()
        }else{
         processNameTF.resignFirstResponder()
        }
        }
       @objc func   cancelClick() {
         if textFieldName == "deparment"{
          deparmentTF.resignFirstResponder()
         }else{
          processNameTF.resignFirstResponder()
         }
       }
    override func viewDidLoad() {
           super.viewDidLoad()
        DMSDepartmentInfo()
//        DMSDepartmentProcessNameInfo()
        self.navigationController?.navigationBar.tintColor = UIColor.white
       txtView.delegate = self
       txtView.text = "Details"
       txtView.textColor = UIColor.lightGray

        self.docRefView.layer.borderWidth = 1
        self.docRefView.layer.borderColor = UIColor.lightGray.cgColor
        self.uploadFileView.layer.borderWidth = 1
        self.uploadFileView.layer.borderColor = UIColor.lightGray.cgColor
           
           let logo = UIImage(named: "logo1")
           let imageView = UIImageView(image:logo)
           imageView.contentMode = .scaleAspectFit
           imageView.setImageColor(color: UIColor.white)
           self.navigationItem.titleView = imageView
       }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if txtView.textColor == UIColor.lightGray {
            txtView.text = ""
            txtView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if txtView.text == "" {
            txtView.text = "Details"
            txtView.textColor = UIColor.lightGray
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
    @IBAction func ClickOnSubmitBtn(_ sender: Any)
    {
        if self.deparmentTF.text == ""
           {
               deparmentTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
               Toast.show(message: "Please enter deparment", controller: self)
           }else if self.processNameTF.text == ""
           {
               processNameTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
               Toast.show(message: "Please enter process name", controller: self)
           }else if self.processNameTF.text == ""
           {
               processNameTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
               Toast.show(message: "Please enter process name", controller: self)
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
                                 "name": "dmsApplicationId",
                                 "value": "1",
                             ],
                             
                             [
                                 "name": "fileName",
                                 "value": "Testing",
                             ],
                             [
                                 "name": "details",
                                 "value": self.txtView.text!,
                             ],
                             [
                                 "name": "sapRef",
                                 "value": self.sapRefTF.text!,
                             ],
                             [
                                 "name": "sapDoc",
                                 "value": self.sapDocTF.text!,
                             ],
                             [
                                 "name": "sapPosting",
                                 "value": self.sapPostingTF.text!,
                             ],
                             [
                                 "name": "associatedFile",
                                 "value": "/path/to/file",
                             ],
                             [
                                 "name": "departmentId",
                                 "value": self.DepartmentId,
                             ],
                             [
                                 "name": "status",
                                 "value": "false",
                             ],
                             [
                                 "name": "dmsCategoryId",
                                 "value": self.DepartmentId,
                             ],
                             [
                                 "name": "dmsSubCategoryId",
                                 "value": self.DepProcessNameId,
                             ],
                             
                             [
                                 "name": "dmsFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "dmsFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "dmsFile", fileName:
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
                   to: MyStrings().AddDMSRequest,method:HTTPMethod.post,
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
                                    self.AskConfirmation(title: "My Alert", message: "DMS Request Data Empty") { (result) in
                                       if result {
                                    self.navigationController?.popViewController(animated: true)
                                       } else {
                                           
                                       }
                                   }
                                               }
                                  }else{
                                   DispatchQueue.main.async {
                                    self.AskConfirmation(title: "My Alert", message: "DMS Request Added Successfully") { (result) in
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
//    func submitTrainingApi()
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
//            multipartFormData.append(self.GetfileData, withName: "dmsFile", fileName:
//                                       self.GetfileName, mimeType: "application/pdf")
//            multipartFormData.append(("1".data(using: .utf8))!, withName: "dmsApplicationId")
//            multipartFormData.append(("Testing".data(using: .utf8))!, withName: "fileName")
//            multipartFormData.append((self.txtView.text!.data(using: .utf8))!, withName: "details")
//            multipartFormData.append((self.sapRefTF.text!.data(using: .utf8))!, withName: "sapRef")
//            multipartFormData.append((self.sapDocTF.text!.data(using: .utf8))!, withName: "sapDoc")
//
//            multipartFormData.append((self.sapPostingTF.text!.data(using: .utf8))!, withName: "sapPosting")
//            multipartFormData.append(("/path/to/file".data(using: .utf8))!, withName: "associatedFile")
//            multipartFormData.append((self.DepartmentId.data(using: .utf8))!, withName: "departmentId")
//            multipartFormData.append(("false".data(using: .utf8))!, withName: "status")
//            multipartFormData.append((self.DepartmentId.data(using: .utf8))!, withName: "dmsCategoryId")
//
//            multipartFormData.append((self.DepProcessNameId.data(using: .utf8))!, withName: "dmsSubCategoryId")
//
//            multipartFormData.append((self.GetfileName.data(using: .utf8))!, withName: "dmsFile")
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
//                to: MyStrings().AddDMSRequest,
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
//                                    self.AskConfirmation(title: "My Alert", message: "DMS Request Data Empty") { (result) in
//                                    if result {
//                                     self.navigationController?.popViewController(animated: true)
//                                    } else {
//
//                                    }
//                                    }
//                                    }
//                                }else{
//                                    DispatchQueue.main.async {
//                                    self.AskConfirmation(title: "My Alert", message: "DMS Request Added Successfully") { (result) in
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
        func DMSDepartmentInfo()
        {
            self.DMSDepDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().DMSDepartmentInfo
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

                    let alert = UIAlertController(title: "My alert", message: "DMS Department Name List empty", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        (result : UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    }
                }else{
                 for (index,subJson):(String, JSON) in json {
                     print(index)
                     print(subJson)
                     let details = DMSDepModel.init(json: subJson)
                     self.DMSDepDetails.append(details)
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
    func DMSDepartmentProcessNameInfo()
    {
        
        self.DMSDepProcessNameDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().DMSDepartmentProcessName
            let params = par + "/" + self.DepartmentId
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
                let alert = UIAlertController(title: "My alert", message: "DMS Process Name List empty", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (result : UIAlertAction) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
                }
            }else{
             for (index,subJson):(String, JSON) in json {
                 print(index)
                 print(subJson)
                 let details = DMSDepProcessModel.init(json: subJson)
                 self.DMSDepProcessNameDetails.append(details)
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
    func DmsReqApprovalList()
    {
        self.DMSDepApprovalDetails.removeAll()
        self.DMSDepApprovalListDetails.removeAll()

        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().DMSDepartmentApprovalList
            let params = par + "/" + self.DepProcessNameId
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
                let alert = UIAlertController(title: "My alert", message: "DMS Approval Flow List empty", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (result : UIAlertAction) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
                }
            }else{
             for (index,subJson):(String, JSON) in json {
                 print(index)
                 print(subJson)
                 let approval = subJson["approver"].dictionaryObject
                 let details = DMSDepApprovalModel.init(json: subJson)
                 self.DMSDepApprovalDetails.append(details)
                self.DMSDepApprovalListDetails.append(approval!)
             }
            }
            print(self.DMSDepApprovalListDetails)
            DispatchQueue.main.async {
                self.DMSApprovalCV.dataSource = self
                self.DMSApprovalCV.delegate = self
                self.DMSApprovalCV.reloadData()
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
extension dmsReqViewController: UIDocumentPickerDelegate{
    
    
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
extension dmsReqViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if DMSDepApprovalListDetails.count == 0
        {
            return 0
        }else{
            return self.DMSDepApprovalListDetails.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.DMSApprovalCV.dequeueReusableCell(withReuseIdentifier: "DMSApprovalCollectionViewCell", for: indexPath)as! DMSApprovalCollectionViewCell
        let dict = self.DMSDepApprovalListDetails[indexPath.item]
        if let name = dict["firstName"] as? String
        {
            cell.DMSAppNameLbl.text = name
        }else{
            cell.DMSAppNameLbl.text = ""
        }
        if let name = dict["firstName"] as? String
        {
            cell.DMSAppNameLbl.text = name
        }else{
            cell.DMSAppNameLbl.text = ""
        }
        let approvalLevel = self.DMSDepApprovalDetails[indexPath.item].approvalLevel
        cell.DMSAppNumLbl.text = String(approvalLevel)
        cell.DMSAppImg.layer.cornerRadius = cell.DMSAppImg.frame.size.width / 2
        cell.DMSAppImg.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.DMSApprovalCV.frame.size.width/4, height:self.DMSApprovalCV.frame.size.height)
    }
    
    
}

