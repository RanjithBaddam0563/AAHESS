//
//  DocumentsViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/8/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import Alamofire
import SwiftyJSON
import MobileCoreServices


class DocumentsViewController: UIViewController,UITextFieldDelegate {
    var employeeDocumentsId : String = ""
    var employeeDocumentsDetails : [employeeDocumentModel] = []
    var expireDatePassingString : String = ""
    let startDatePicker = UIDatePicker()

    @IBOutlet weak var docExpaireOnTF: TextField!
    @IBOutlet weak var docNameTF: TextField!
    @IBOutlet weak var TBV: UITableView!
    @IBOutlet weak var uploadFileBtn: UIButton!
    var last15Char : String = ""
     @IBOutlet weak var uploadTimePathNameLbl: UILabel!
    //UploadPDF
    var FilePathUrl = NSURL()
    var File_Type : String = ""
    var PdfstrBase64 : String = ""
    var DocPath: URL!
    var fileData: Data!
    
    var GetfileData: Data!
       var GetfileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadFileBtn.backgroundColor = .clear
        uploadFileBtn.layer.cornerRadius = 5
        uploadFileBtn.layer.borderWidth = 1
        uploadFileBtn.layer.borderColor = UIColor.darkGray.cgColor
        FetchAccountingInfoDetails()
    }
    public func textFieldDidBeginEditing(_ textField: UITextField)
       {
           if textField == docExpaireOnTF
           {
               showDatePicker()
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
              
              self.docExpaireOnTF.inputAccessoryView = toolbar
              self.docExpaireOnTF.inputView = startDatePicker
              
          }
          @objc func donedatePicker()
          {
              
              let formatter = DateFormatter()
              formatter.dateFormat = "dd/MM/yyyy"
           let formatter1 = DateFormatter()
          formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          self.expireDatePassingString = formatter1.string(from: startDatePicker.date)
              self.docExpaireOnTF.text = formatter.string(from: startDatePicker.date)
              self.view.endEditing(true)
          }
          
          @objc func cancelDatePicker()
          {
              self.view.endEditing(true)
          }
    @objc func DocumentDeleteBtn(sender: UIButton!)
    {
        self.employeeDocumentsId = String(self.employeeDocumentsDetails[sender.tag].employeeDocumentsId)
        DispatchQueue.main.async(execute: {() -> Void in
               let alertController = UIAlertController(title: "My Alert", message:"Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
               
               let okAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                   (result : UIAlertAction) -> Void in
               }
               let okAction1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                   (result : UIAlertAction) -> Void in
                self.DeleteDocuments()
               }
               alertController.addAction(okAction)
               alertController.addAction(okAction1)
               self.present(alertController, animated: true, completion: nil)
            })
    }
    struct Connectivity {
          static let sharedInstance = NetworkReachabilityManager()!
          static var isConnectedToInternet:Bool {
              return self.sharedInstance.isReachable
          }
      }
      func FetchAccountingInfoDetails()
      {
        self.employeeDocumentsDetails.removeAll()
              if Connectivity.isConnectedToInternet {
                  DispatchQueue.main.async {
                      MBProgressHUD.showAdded(to: self.view, animated: true)
                  }
                  
                  let token =  UserDefaults.standard.string(forKey: "Token")!
                  var request = URLRequest(url: URL(string: MyStrings().EmployeeDocumentsInfo)!,timeoutInterval: Double.infinity)
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
                    for (index,subJson):(String, JSON) in json {
                        print(index)
                        print(subJson)
                        let details = employeeDocumentModel.init(json: subJson)
                        self.employeeDocumentsDetails.append(details)
                    }
                  DispatchQueue.main.async {
                    self.TBV.dataSource = self
                    self.TBV.delegate = self
                    self.TBV.reloadData()
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
    
    func DeleteDocuments()
    {
        if Connectivity.isConnectedToInternet {
                         DispatchQueue.main.async {
                             MBProgressHUD.showAdded(to: self.view, animated: true)
                         }
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: MyStrings().DeleteEmployeeDocumentsInfo + "/" + self.employeeDocumentsId)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("citrix_ns_id=oKzrES3hTgYC2wRv5Y+TMwTUEhk0001", forHTTPHeaderField: "Cookie")

        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {() -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                })
          guard let data = data else {
            print(String(describing: error))
            DispatchQueue.main.async(execute: {() -> Void in
              Toast.show(message: (String(describing: error)), controller: self)
          })
            return
          }
          print(String(data: data, encoding: .utf8)!)
            print("response = \(String(describing: response))")
                       if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                           print("statusCode should be 204, but is \(httpStatus.statusCode)")
                           DispatchQueue.main.async(execute: {() -> Void in
                               Toast.show(message: "Service not available please try again", controller: self)
                           })
                       }else{
                           DispatchQueue.main.async {
                             self.AskConfirmation(title: "My Alert", message: "Document Deleted Successfully") { (result) in
                             if result {
                             self.navigationController?.popViewController(animated: true)
                             } else {

                             }
                             }
                                }
                       }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
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
    
    @IBAction func ClickOnUploadBtn(_ sender: Any)
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

    @IBAction func ClickOnSubmitBtn(_ sender: Any)
    {
        if self.docNameTF.text == ""
        {
            docNameTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter name", controller: self)
        }else if self.docExpaireOnTF.text == ""
        {
            docExpaireOnTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter expire date", controller: self)
        }else{
            submitDocumentApi()
            
//            if Connectivity.isConnectedToInternet {
//                                   DispatchQueue.main.async {
//                                       MBProgressHUD.showAdded(to: self.view, animated: true)
//                                   }
//
//             var semaphore = DispatchSemaphore (value: 0)
//
//                    let parameters = [
//                              [
//                                "key": "employeeDocumentsId",
//                                "value": "1",
//                                "type": "text"
//                              ],
//                              [
//                                "key": "name",
//                                "value": self.docNameTF.text!,
//                                "type": "text"
//                              ],
//                              [
//                                "key": "expiresOn",
//                                "value": self.expireDatePassingString,
//                                "type": "text"
//                              ],
//                              [
//                                "key": "associatedFile",
//                                "value": self.GetfileName,
//                                "type": "text"
//                              ]] as [[String : Any]]
//
//                    let boundary = "Boundary-\(UUID().uuidString)"
//                    var body = ""
//                    var error: Error? = nil
//                    for param in parameters {
//                      if param["disabled"] == nil {
//                        let paramName = param["key"]!
//                        body += "--\(boundary)\r\n"
//                        body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                        let paramType = param["type"] as! String
//                        if paramType == "text" {
//                          let paramValue = param["value"] as! String
//                          body += "\r\n\r\n\(paramValue)\r\n"
//                        } else {
//                          let paramSrc = param["src"] as! String
//
//                            print(self.GetfileData)
//                            var bytes: Data = self.GetfileData // [67, 97, 102, 195, 169]
//
//                            bytes.removeLast()
//                          let backToString =  String(data: bytes, encoding: .utf8)
//                         let backToString1 = String(decoding: bytes, as: UTF8.self)
//            //                let backToString = String(describing: paramSrc.cString(using: String.Encoding.utf8))
//
//            //                let backToString = String(data: file, encoding: String.Encoding.utf8) as String?
//                            print(backToString1)
//                          body += "; filename=\"\(paramSrc)\"\r\n"
//                            + "Content-Type: \"content-type header\"\r\n\r\n\(backToString1)\r\n"
//                        }
//                      }
//                    }
//                    body += "--\(boundary)--\r\n";
//                    let postData = body.data(using: .utf8)
//
//                    var request = URLRequest(url: URL(string: MyStrings().AddEmployeeDocument)!,timeoutInterval: Double.infinity)
//                    let token =  UserDefaults.standard.string(forKey: "Token")!
//
//                    request.addValue(token, forHTTPHeaderField: "Authorization")
//                    request.addValue("citrix_ns_id=hSiXNmROg8vo8kizVNR+eHpFHQM0001", forHTTPHeaderField: "Cookie")
//                    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//                    request.httpMethod = "POST"
//                    request.httpBody = postData
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        DispatchQueue.main.async(execute: {() -> Void in
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                            })
//                      guard let data = data else {
//                        print(String(describing: error))
//                        DispatchQueue.main.async(execute: {() -> Void in
//                          Toast.show(message: (String(describing: error)), controller: self)
//                      })
//                        return
//                      }
//                      print(String(data: data, encoding: .utf8)!)
//                        print("response = \(String(describing: response))")
//                                   if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
//                                       print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                                       DispatchQueue.main.async(execute: {() -> Void in
//                                           Toast.show(message: "Service not available please try again", controller: self)
//                                       })
//                                   }else{
//                                       var jsonDictionary1 : NSDictionary?
//                                       do {
//                                           jsonDictionary1 = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
//
//                                           print(jsonDictionary1!)
//                                           DispatchQueue.main.async {
//                                           self.AskConfirmation(title: "My Alert", message: "Employee Document Added Successfully") { (result) in
//                                              if result {
//                                               self.navigationController?.popViewController(animated: true)
//                                              } else {
//
//                                              }
//                                          }
//                                                      }
//                                       } catch {
//                                           print(error)
//                                           DispatchQueue.main.async(execute: {() -> Void in
//                                               Toast.show(message: "Service not available please try again", controller: self)
//                                           })
//                                       }
//                                   }
//                      semaphore.signal()
//                    }
//
//                    task.resume()
//                    semaphore.wait()
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
            
//        var semaphore = DispatchSemaphore (value: 0)
//
//        let parameters = [
//          [
//            "key": "employeeDocumentsId",
//            "value": "1",
//            "type": "text"
//          ],
//          [
//            "key": "name",
//            "value": self.docNameTF.text!,
//            "type": "text"
//          ],
//          [
//            "key": "expiresOn",
//            "value": self.expireDatePassingString,
//            "type": "text"
//          ],
//          [
//            "key": "associatedFile",
//            "value": self.GetfileName,
//            "type": "text"
//          ]] as [[String : Any]]
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var error: Error? = nil
//        for param in parameters {
//          if param["disabled"] == nil {
//            let paramName = param["key"]!
//            body += "--\(boundary)\r\n"
//            body += "Content-Disposition:form-data; name=\"\(paramName)\""
//            let paramType = param["type"] as! String
//            if paramType == "text" {
//              let paramValue = param["value"] as! String
//              body += "\r\n\r\n\(paramValue)\r\n"
//            } else {
//              let paramSrc = param["src"] as! String
//                do {
//                    let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
//                    print("i eat it \(fileData)")
//                }  catch let error {
//                    print(error.localizedDescription)
//                }
//              let fileContent = String(data: fileData, encoding: .utf8)!
//              body += "; filename=\"\(paramSrc)\"\r\n"
//                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//            }
//          }
//        }
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: MyStrings().AddEmployeeDocument)!,timeoutInterval: Double.infinity)
//        let token =  UserDefaults.standard.string(forKey: "Token")!
//
//        request.addValue(token, forHTTPHeaderField: "Authorization")
//        request.addValue("citrix_ns_id=XKWA/r4R7w6Tj/ncfvbb8cLz2hE0000", forHTTPHeaderField: "Cookie")
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async(execute: {() -> Void in
//                MBProgressHUD.hide(for: self.view, animated: true)
//                })
//          guard let data = data else {
//            print(String(describing: error))
//            DispatchQueue.main.async(execute: {() -> Void in
//              Toast.show(message: (String(describing: error)), controller: self)
//          })
//            return
//          }
//          print(String(data: data, encoding: .utf8)!)
//            print("response = \(String(describing: response))")
//                       if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
//                           print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                           DispatchQueue.main.async(execute: {() -> Void in
//                               Toast.show(message: "Service not available please try again", controller: self)
//                           })
//                       }else{
//                           var jsonDictionary1 : NSDictionary?
//                           do {
//                               jsonDictionary1 = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
//
//                               print(jsonDictionary1!)
//                               DispatchQueue.main.async {
//                               self.AskConfirmation(title: "My Alert", message: "Employee Document Added Successfully") { (result) in
//                                  if result {
//                                    self.FetchAccountingInfoDetails()
//                                  } else {
//
//                                  }
//                              }
//                                          }
//                           } catch {
//                               print(error)
//                               DispatchQueue.main.async(execute: {() -> Void in
//                                   Toast.show(message: "Service not available please try again", controller: self)
//                               })
//                           }
//                       }
//          semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
        }
    }
    func submitDocumentApi()
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
                                 "name": "employeeDocumentsId",
                                 "value": "1",
                             ],
                             
                             [
                                 "name": "name",
                                 "value": self.docNameTF.text!,
                             ],
                             [
                                 "name": "expiresOn",
                                 "value": self.expireDatePassingString,
                             ],
                             [
                                 "name": "associatedFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "associatedFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "associatedFile", fileName:
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
                   to: MyStrings().AddEmployeeDocument,method:HTTPMethod.post,
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
extension DocumentsViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if employeeDocumentsDetails.count == 0
        {
            return 0
        }else{
            return employeeDocumentsDetails.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TBV.dequeueReusableCell(withIdentifier: "DocumentTableViewCell")as! DocumentTableViewCell
        
        cell.DocumentNameLbl.text = self.employeeDocumentsDetails[indexPath.row].name
        let expiresOn = self.employeeDocumentsDetails[indexPath.row].expiresOn
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date1 = dateFormatter1.date(from: expiresOn)
        dateFormatter1.dateFormat = "MMM d, yyyy"
        let goodDate1 = dateFormatter1.string(from: date1!)
        cell.DocumentDateLbl.text = goodDate1
        
        cell.DocumentDeleteBtn.tag = indexPath.row
        cell.DocumentDeleteBtn.addTarget(self, action: #selector(self.DocumentDeleteBtn), for: .touchUpInside)

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
extension DocumentsViewController: UIDocumentPickerDelegate{
    
    
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
