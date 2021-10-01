//
//  formalitiesReqViewController.swift
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

class formalitiesReqViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var formalitiesReqDetails : [formalitiesReqModel] = []
    @IBOutlet weak var subMitBtn: UIButton!
    var formalityPaticularsArray = [String]()
    var formalityArray = [String]()

    var DetailsReqArray = [String]()
    var PurposeArray = [String]()
    var FileNameArray = [String]()
    
    var PassformalityPaticularStr : String = ""
    var PassformalityStr : String = ""
    var PassDetailsReqStr : String = ""
    var PassPurposeStr : String = ""
    var PassFileNameStr : String = ""


    var detailsRequiredBool = Bool()
    var FormalityTypeID : String = ""
    var FormalityTypeID1 : String = ""
    var FormalityTypeName : String = ""
    var FormalityTypeName1 : String = ""

    var last15Char : String = ""
    
    var myPickerView : UIPickerView!
    var RowIndex : Int = 0
    //UploadPDF
    var FilePathUrl = NSURL()
    var File_Type : String = ""
    var PdfstrBase64 : String = ""
    var DocPath: URL!
    var fileData: Data!
    var GetfileData: Data!
    var GetfileName: String = ""

    @IBOutlet weak var addBtn: UIButton!
       @IBOutlet weak var TBV: UITableView!
       var ListCount = ["1"]
     override func viewDidLoad() {
            super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
              let logo = UIImage(named: "logo1")
              let imageView = UIImageView(image:logo)
              imageView.contentMode = .scaleAspectFit
              imageView.setImageColor(color: UIColor.white)
              self.navigationItem.titleView = imageView
        }
    
    
        
    @IBAction func ClickOnSubmitBtn(_ sender: UIButton)
    {
        print(self.formalityPaticularsArray)
        print(self.DetailsReqArray)
        print(self.FileNameArray)
        print(self.PurposeArray)

        let indexPath = IndexPath(row: self.RowIndex, section: 0)
           let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
           let indexPath1 = IndexPath(row: 0, section: 0)
           let cell1 = self.TBV.cellForRow(at: indexPath1)as! CustomTableViewCell


        if cell1.formalityPaticularTF.text == ""
        {
            cell1.formalityPaticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter Paticular", controller: self)
        }
        else if cell1.formalityDetailsReqTF.text == ""
        {
            cell1.formalityDetailsReqTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter Details Required", controller: self)
        }else if cell.formalityPaticularTF.text == ""
        {
            cell.formalityPaticularTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter Paticular", controller: self)
        }
        else if cell.formalityDetailsReqTF.text == ""
        {
            cell.formalityDetailsReqTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please enter Details Required", controller: self)
        }else{
            if Connectivity.isConnectedToInternet {
              DispatchQueue.main.async {
                  MBProgressHUD.showAdded(to: self.view, animated: true)
              }
                if self.formalityPaticularsArray.count != 0
                {
                   
                    if let str = formalityPaticularsArray[optional: 0] {
                        self.PassformalityPaticularStr = str
                    } else {
                        self.PassformalityPaticularStr = ""
                    }
                    if let str4 = formalityArray[optional: 0] {
                        self.PassformalityStr = str4
                    } else {
                        self.PassformalityStr = ""
                    }
                    
                    if let str1 = DetailsReqArray[optional: 0] {
                        self.PassDetailsReqStr = str1  // --> this still wouldn't run
                    } else {
                        self.PassDetailsReqStr = "" // --> this would be printed
                    }
                    if let str2 = PurposeArray[optional: 0] {
                        self.PassPurposeStr = str2  // --> this still wouldn't run
                    } else {
                        self.PassPurposeStr = "" // --> this would be printed
                    }
                    if let str3 = FileNameArray[optional: 0] {
                        self.PassFileNameStr = str3  // --> this still wouldn't run
                    } else {
                        self.PassFileNameStr = "" // --> this would be printed
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
                                             "name": "Purpose",
                                             "value": self.PassPurposeStr,
                                         ],
                                         
                                         [
                                             "name": "FormalityTypeId",
                                             "value": self.PassformalityPaticularStr,
                                         ],
                                         [
                                             "name": "detailsRequired",
                                             "value": self.PassDetailsReqStr,
                                         ],
                                         [
                                             "name": "formalityType",
                                             "value": self.PassformalityStr,
                                         ],
                                         [
                                             "name": "FormalityFile",
                                             "filename": self.PassFileNameStr,
                                         ]
                                     ]
                            
                           Alamofire.upload(
                               multipartFormData: { multipartFormData in
                                   for strRecord in parameters {
                                       if strRecord["name"] == "FormalityFile"{
                                           if self.GetfileData == nil {
                                           }
                                           else{
                                            let url: String? = strRecord["filename"] as! String
                                               let parts: [Any]? = url?.components(separatedBy: "/")
                                               let _: String? = parts?.last as? String
                                            let imageData1 = self.GetfileData
                                            multipartFormData.append(self.GetfileData, withName: "FormalityFile", fileName:
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
                               to: MyStrings().AddFormalityApplications,method:HTTPMethod.post,
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
                                                self.AskConfirmation(title: "My Alert", message: "Formality Request Data Empty") { (result) in
                                                   if result {
                                                self.navigationController?.popViewController(animated: true)
                                                   } else {
                                                       
                                                   }
                                               }
                                                           }
                                              }else{
                                               DispatchQueue.main.async {
                                                self.AskConfirmation(title: "My Alert", message: "Formality Request Added Successfully") { (result) in
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
                   
                   
//            var semaphore = DispatchSemaphore (value: 0)
//
//            let parameters = [
//              [
//                "key": "Purpose",
//                "value": self.PassPurposeStr,
//                "type": "text"
//              ],
//              [
//                "key": "FormalityTypeId",
//                "value": self.PassformalityPaticularStr,
//                "type": "text"
//              ],
//              [
//                "key": "detailsRequired",
//                "value": self.PassDetailsReqStr,
//                "type": "text"
//              ],
//              [
//                "key": "FormalityFile",
//                "src": self.PassFileNameStr,
//                "type": "file"
//              ],
//              [
//                "key": "formalityType",
//                "value": self.PassformalityStr,
//                "type": "text"
//              ]] as [[String : Any]]
//
//            let boundary = "Boundary-\(UUID().uuidString)"
//            var body = ""
//            var error: Error? = nil
//            for param in parameters {
//              if param["disabled"] == nil {
//                let paramName = param["key"]!
//                body += "--\(boundary)\r\n"
//                body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                let paramType = param["type"] as! String
//                if paramType == "text" {
//                  let paramValue = param["value"] as! String
//                  body += "\r\n\r\n\(paramValue)\r\n"
//                } else {
//                              let paramSrc = param["src"] as! String
//
//                                print(self.GetfileData)
//                                var bytes: Data = self.GetfileData // [67, 97, 102, 195, 169]
//
//                                bytes.removeLast()
//                              let backToString =  String(data: bytes, encoding: .utf8)
//                             let backToString1 = String(decoding: bytes, as: UTF8.self)
//                //                let backToString = String(describing: paramSrc.cString(using: String.Encoding.utf8))
//
//                //                let backToString = String(data: file, encoding: String.Encoding.utf8) as String?
//                                print(backToString1)
//                              body += "; filename=\"\(paramSrc)\"\r\n"
//                                + "Content-Type: \"content-type header\"\r\n\r\n\(backToString1)\r\n"
//                            }
//              }
//            }
//            body += "--\(boundary)--\r\n";
//            let postData = body.data(using: .utf8)
//
//            var request = URLRequest(url: URL(string: MyStrings().AddFormalityApplications)!,timeoutInterval: Double.infinity)
////            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                    let token =  UserDefaults.standard.string(forKey: "Token")!
//
//            request.addValue(token, forHTTPHeaderField: "Authorization")
//            request.addValue("citrix_ns_id=z3vUOpHwJZHUUwI9jWpU1Rksamc0000", forHTTPHeaderField: "Cookie")
//            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            request.httpMethod = "POST"
//            request.httpBody = postData
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
//                                        var jsonDictionary1 : NSDictionary?
//                                        do {
//                                        jsonDictionary1 = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
//
//                                        print(jsonDictionary1!)
//                                        if let str = self.formalityPaticularsArray[optional: 0] {
//                                        self.formalityPaticularsArray.remove(at: 0)
//                                        } else {
//
//                                        }
//                                        if let str1 = self.DetailsReqArray[optional: 0] {
//                                        self.DetailsReqArray.remove(at: 0)
//                                        } else {
//
//                                        }
//                                        if let str2 = self.PurposeArray[optional: 0] {
//                                        self.PurposeArray.remove(at: 0)
//                                        } else {
//
//                                        }
//                                        if let str3 = self.FileNameArray[optional: 0] {
//                                        self.FileNameArray.remove(at: 0)
//                                        } else {
//
//                                        }
//                                        if let str4 = self.formalityArray[optional: 0] {
//                                        self.formalityArray.remove(at: 0)
//                                        } else {
//
//                                        }
//
//                                        DispatchQueue.main.async {
//                                        print(self.formalityPaticularsArray.count)
//                                        if self.formalityPaticularsArray.count == 0
//                                        {
//                                        self.AskConfirmation(title: "My Alert", message: "Formality Request Added Successfully") { (result) in
//                                        if result {
//                                        self.navigationController?.popViewController(animated: true)
//                                        } else {
//
//                                        }
//                                        }
//                                        }else{
//                                        self.ClickOnSubmitBtn(self.subMitBtn)
//                                        }
//                                        }
//
//                                        } catch {
//                                        print(error)
//                                        DispatchQueue.main.async(execute: {() -> Void in
//                                        Toast.show(message: "Service not available please try again", controller: self)
//                                        })
//                                        }
//                                                          }
//                      semaphore.signal()
//                    }
//
//            task.resume()
//            semaphore.wait()
                    
                }else{
                    
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
    func submitFormalityApi()
        {
            if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let token =  UserDefaults.standard.string(forKey: "Token")!
            let boundary = "Boundary-\(UUID().uuidString)"
            let headers = [
                            "Authorization": token,
                            "Content-Type": "multipart/form-data; boundary=\(boundary)"
                                  //"multipart/form-data; boundary=???",
                              ]
            Alamofire.upload(
               
                multipartFormData: {
                    multipartFormData in

                   
                    let data : Data = self.GetfileData
                    DispatchQueue.main.async {
            multipartFormData.append(self.GetfileData, withName: "FormalityFile", fileName:
                                       self.PassFileNameStr, mimeType: "application/pdf")
            multipartFormData.append((self.PassPurposeStr.data(using: .utf8))!, withName: "Purpose")
            multipartFormData.append((self.PassformalityPaticularStr.data(using: .utf8))!, withName: "FormalityTypeId")
            multipartFormData.append((self.PassDetailsReqStr.data(using: .utf8))!, withName: "detailsRequired")
            multipartFormData.append((self.PassformalityStr.data(using: .utf8))!, withName: "formalityType")
            
            multipartFormData.append((self.PassFileNameStr.data(using: .utf8))!, withName: "FormalityFile")
                    }
                        print("Multi part Content -Type")
                        print(multipartFormData.contentType)
                        print("Multi part FIN ")
                        print("Multi part Content-Length")
                        print(multipartFormData.contentLength)
                        print("Multi part Content-Boundary")
                        print(multipartFormData.boundary)
                    
            },
                to: MyStrings().submitTrainingReq,
                method: .post,
                headers: headers,
                encodingCompletion: { encodingResult in

                    switch encodingResult {

                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print(" responses ")
                            print(response)
                            switch response.result {
                            case let .success(value):
                                let json = JSON(value)
                                print(json)
                                if json.count == 0
                                {
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
                    case .failure(let encodingError):
                        print(encodingError.localizedDescription)
    //                    onCompletion(false, "Something bad happen...", 200)
                        DispatchQueue.main.async {
                           let alert = UIAlertController(title: "My alert", message: encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                             (result : UIAlertAction) -> Void in
                         }))
                         self.present(alert, animated: true, completion: nil)
                        }

                    }
            })
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
            cell.formalityPaticularTF.text = ""
            cell.formalityDetailsReqTF.text = ""
            self.ListCount.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.TBV.reloadWithAnimation()
            }
        }
    @objc func formalityPaticularBtnAction(sender: UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(indexPath.section)
        print(indexPath.row)
        self.RowIndex = indexPath.row
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.formalityPaticularTF.isUserInteractionEnabled = true
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().FormalityTypesInfo
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
                 let details = formalitiesReqModel.init(json: subJson)
                 self.formalitiesReqDetails.append(details)
             }
            
            DispatchQueue.main.async {
            // UIPickerView
            self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.myPickerView.delegate = self
            self.myPickerView.dataSource = self
            self.myPickerView.reloadAllComponents()

            self.myPickerView.backgroundColor = UIColor.white
            cell.formalityPaticularTF.inputView = self.myPickerView

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
            cell.formalityPaticularTF.inputAccessoryView = toolBar

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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
     }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if formalitiesReqDetails.count == 0 {
         return 0
        }else{
       return formalitiesReqDetails.count
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formalitiesReqDetails[row].name
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        self.FormalityTypeID = String(formalitiesReqDetails[row].formalityTypeId)
        cell.formalityPaticularTF.text = formalitiesReqDetails[row].name
        self.FormalityTypeName = formalitiesReqDetails[row].name
     }
     //MARK:- TextFiled Delegate

    
    @objc func   doneClick() {
       let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        self.FormalityTypeID1 = self.FormalityTypeID
        self.FormalityTypeName1 = self.FormalityTypeName

        self.formalityPaticularsArray.append(self.FormalityTypeID1)
        self.formalityArray.append(self.FormalityTypeName1)

      cell.formalityPaticularTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
      cell.formalityPaticularTF.resignFirstResponder()
    }
    struct Connectivity {
           static let sharedInstance = NetworkReachabilityManager()!
           static var isConnectedToInternet:Bool {
               return self.sharedInstance.isReachable
           }
       }
    @objc func FormUploadBtnAction(sender: UIButton!)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
              self.RowIndex = indexPath.row
               print(self.RowIndex)
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .pageSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
    @objc func formalityDetailsReqBtnAction(sender: UIButton!)
    {
       let indexPath = IndexPath(row: sender.tag, section: 0)
        print(indexPath.section)
        print(indexPath.row)
        self.RowIndex = indexPath.row
        let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
        cell.formalityDetailsReqTF.isUserInteractionEnabled = true

        
            if (UIDevice.current.userInterfaceIdiom  == .pad)
            {
                DispatchQueue.main.async(execute: {() -> Void in
                    cell.formalityDetailsReqTF.resignFirstResponder()
                    let alertController = UIAlertController(title: "Choose Details Required", message: nil, preferredStyle: UIAlertController.Style.alert)
                    
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                           cell.formalityDetailsReqTF.text = "Yes"
                            self.DetailsReqArray.append("true")
                            self.detailsRequiredBool = true
                        cell.formalityDetailsReqTF.resignFirstResponder()

                            
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                           cell.formalityDetailsReqTF.text = "No"
                            self.DetailsReqArray.append("false")

                            self.detailsRequiredBool = false
                            cell.formalityDetailsReqTF.resignFirstResponder()
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    alertController.addAction(okAction)
                    alertController.addAction(okAction1)
                    self.present(alertController, animated: true, completion: nil)
                })
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    cell.formalityDetailsReqTF.resignFirstResponder()
                    let alertController = UIAlertController(title: "Choose Details Required", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                    
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                           
                            cell.formalityDetailsReqTF.text = "Yes"
                            self.DetailsReqArray.append("true")

                            self.detailsRequiredBool = true

                             cell.formalityDetailsReqTF.resignFirstResponder()
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            cell.formalityDetailsReqTF.text = "No"
                            self.DetailsReqArray.append("false")

                            self.detailsRequiredBool = false

                           cell.formalityDetailsReqTF.resignFirstResponder()
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    alertController.addAction(okAction)
                    alertController.addAction(okAction1)
                    self.present(alertController, animated: true, completion: nil)
                })
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
        self.FileNameArray.append(self.GetfileName)
        let indexPath = IndexPath(row: self.RowIndex, section: 0)
            let cell = self.TBV.cellForRow(at: indexPath)as! CustomTableViewCell
            cell.uploadTimePathNameLbl.text = self.GetfileName
        if cell.formalityPurposeTF.text == ""
        {
            
        }else{
        self.PurposeArray.append(cell.formalityPurposeTF.text!)
        }
          
       }
    }
    extension formalitiesReqViewController : UITableViewDataSource,UITableViewDelegate
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
            
            let cell = self.TBV.dequeueReusableCell(withIdentifier: "CustomTableViewCell33")as!CustomTableViewCell
            cell.frUploadFileView.layer.borderWidth = 1
            cell.frUploadFileView.layer.borderColor = UIColor.lightGray.cgColor
            cell.frRemoveBtn.tag = indexPath.row
            cell.frRemoveBtn.addTarget(self, action: #selector(self.removeBtnAction), for: .touchUpInside)
            cell.formalityPaticularBtn.tag = indexPath.row
           
            cell.formalityPaticularBtn.addTarget(self, action: #selector(self.formalityPaticularBtnAction), for: .touchUpInside)
            cell.formalityDetailsReqBtn.tag = indexPath.row
            cell.formalityDetailsReqBtn.addTarget(self, action: #selector(self.formalityDetailsReqBtnAction), for: .touchUpInside)

            cell.formalityUploadBtn.tag = indexPath.row
                  cell.formalityUploadBtn.addTarget(self, action: #selector(self.FormUploadBtnAction), for: .touchUpInside)

            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 280
        }
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
extension formalitiesReqViewController: UIDocumentPickerDelegate{
    
    
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
