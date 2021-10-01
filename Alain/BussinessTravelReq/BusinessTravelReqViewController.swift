//
//  BusinessTravelReqViewController.swift
//  Alain
//
//  Created by MicroExcel on 5/25/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit
import Material
import MBProgressHUD
import MobileCoreServices
import Foundation
import Alamofire
import SwiftyJSON

class BusinessTravelReqViewController: UIViewController,UITextFieldDelegate {

    var TravfromDatePassingString : String = ""
       var TravtoDatePassingString : String = ""
    ///UploadPDF
    var FilePathUrl = NSURL()
    var File_Type : String = ""
    var PdfstrBase64 : String = ""
    var DocPath: URL!
    var fileData: Data!
    var airLineTickBool = Bool()
    var HotelBookingBool = Bool()

    
    var checkFrom : String = ""
    
    var GetfileData: Data!
    var GetfileName: String = ""
    var last15Char : String = ""
     @IBOutlet weak var uploadTimePathNameLbl: UILabel!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var travelFromDateTF: TextField!
    @IBOutlet weak var destinationTF: TextField!
    @IBOutlet weak var travelToDatTF: TextField!
    @IBOutlet weak var purposeTF: TextField!
    @IBOutlet weak var airLineTickerTF: TextField!
    @IBOutlet weak var hotelBookingTF: TextField!
    let startDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadView.layer.borderWidth = 1
        self.uploadView.layer.borderColor = UIColor.lightGray.cgColor

       self.navigationController?.navigationBar.tintColor = UIColor.white
               let logo = UIImage(named: "logo1")
               let imageView = UIImageView(image:logo)
               imageView.contentMode = .scaleAspectFit
               imageView.setImageColor(color: UIColor.white)
               self.navigationItem.titleView = imageView
        

           }
           
    @IBAction func ClickOnUploadFile(_ sender: UIButton)
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
            if self.destinationTF.text == ""
            {
                destinationTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter destination", controller: self)
            }else if self.travelFromDateTF.text == ""
            {
                travelFromDateTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter travel From Date", controller: self)
            }else if self.travelToDatTF.text == ""
            {
                travelToDatTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please enter travel To Date", controller: self)
            }else{
              BusinessTravelReq_Api()
            }
            
          }
   
    func BusinessTravelReq_Api()
    {
       
//        var semaphore = DispatchSemaphore (value: 0)

        if self.airLineTickerTF.text == "Yes"
        {
            self.airLineTickBool = true
        }else{
            self.airLineTickBool = false
        }
        if self.hotelBookingTF.text == "Yes"
        {
            self.HotelBookingBool = true
        }else{
            self.HotelBookingBool = false
        }
        submitTrainingApi()
        
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
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
                                 "name": "Destination",
                                 "value": self.destinationTF.text!,
                             ],
                             
                             [
                                 "name": "Purpose",
                                 "value": self.purposeTF.text!,
                             ],
                             [
                                 "name": "AirlineTicket",
                                 "value": String(self.airLineTickBool),
                             ],
                             [
                                 "name": "HotelBooking",
                                 "value": String(self.HotelBookingBool),
                             ],
                             [
                                 "name": "TravelDateFrom",
                                 "value": self.TravfromDatePassingString,
                             ],
                             [
                                 "name": "TravelDateTO",
                                 "value": self.TravtoDatePassingString,
                             ],
                             [
                                 "name": "BusinessTravelApplicationFile",
                                 "filename": self.GetfileName,
                             ]
                         ]
                
               Alamofire.upload(
                   multipartFormData: { multipartFormData in
                       for strRecord in parameters {
                           if strRecord["name"] == "BusinessTravelApplicationFile"{
                               if self.GetfileData == nil {
                               }
                               else{
                                let url: String? = strRecord["filename"] as! String
                                   let parts: [Any]? = url?.components(separatedBy: "/")
                                   let _: String? = parts?.last as? String
                                let imageData1 = self.GetfileData
                                multipartFormData.append(self.GetfileData, withName: "BusinessTravelApplicationFile", fileName:
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
                   to: MyStrings().BusinessTravelApplications,method:HTTPMethod.post,
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
                                 self.AskConfirmation(title: "My Alert", message: "Business Travel Request Data Empty") { (result) in
                                    if result {
                                 self.navigationController?.popViewController(animated: true)
                                    } else {
                                        
                                    }
                                }
                                            }
                               }else{
                                DispatchQueue.main.async {
                                 self.AskConfirmation(title: "My Alert", message: "Business Travel Request Added Successfully") { (result) in
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
//    func submitBusinessTravelApi()
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
//            multipartFormData.append(self.GetfileData, withName: "BusinessTravelApplicationFile", fileName:
//                                       self.GetfileName, mimeType: "application/pdf")
//            multipartFormData.append((self.destinationTF.text!.data(using: .utf8))!, withName: "Destination")
//            multipartFormData.append((self.purposeTF.text!.data(using: .utf8))!, withName: "Purpose")
//            multipartFormData.append((String(self.airLineTickBool).data(using: .utf8))!, withName: "AirlineTicket")
//            multipartFormData.append((String(self.HotelBookingBool).data(using: .utf8))!, withName: "HotelBooking")
//            multipartFormData.append((self.TravfromDatePassingString.data(using: .utf8))!, withName: "TravelDateFrom")
//
//            multipartFormData.append((self.TravtoDatePassingString.data(using: .utf8))!, withName: "TravelDateTO")
//
//            multipartFormData.append((self.GetfileName.data(using: .utf8))!, withName: "BusinessTravelApplicationFile")
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
//                to: MyStrings().BusinessTravelApplications,
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
//                                    self.AskConfirmation(title: "My Alert", message: "Business Travel Request Data Empty") { (result) in
//                                    if result {
//                                     self.navigationController?.popViewController(animated: true)
//                                    } else {
//
//                                    }
//                                    }
//                                    }
//                                }else{
//                                    DispatchQueue.main.async {
//                                    self.AskConfirmation(title: "My Alert", message: "Business Travel Request Added Successfully") { (result) in
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
    public func textFieldDidBeginEditing(_ textField: UITextField)
       {
           if textField == travelFromDateTF
           {
               showDatePicker()
           }else if textField == travelToDatTF
           {
               showDatePicker1()
           }else if textField == airLineTickerTF
           {
               checkFrom = "airLineTickerTF"
               AirlineTickrtDetails()
           }else if textField == hotelBookingTF
           {
               checkFrom = "hotelBookingTF"
               AirlineTickrtDetails()
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
              
              self.travelFromDateTF.inputAccessoryView = toolbar
              self.travelFromDateTF.inputView = startDatePicker
              
          }
          @objc func donedatePicker()
          {
              
              let formatter = DateFormatter()
              formatter.dateFormat = "dd/MM/yyyy"
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
              self.travelFromDateTF.text = formatter.string(from: startDatePicker.date)
            self.TravfromDatePassingString = formatter1.string(from: startDatePicker.date)

              self.view.endEditing(true)
          }
          
          @objc func cancelDatePicker()
          {
              self.view.endEditing(true)
          }
       
       func showDatePicker1()
       {
           startDatePicker.datePickerMode = .date
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
           
           self.travelToDatTF.inputAccessoryView = toolbar
           self.travelToDatTF.inputView = startDatePicker
           
       }
    @objc func donedatePicker1()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
      let formatter1 = DateFormatter()
     formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
     self.TravtoDatePassingString = formatter1.string(from: startDatePicker.date)
        self.travelToDatTF.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
       
       @objc func cancelDatePicker1()
       {
           self.view.endEditing(true)
       }
   
    func AirlineTickrtDetails()
    {
        if (UIDevice.current.userInterfaceIdiom  == .pad)
        {
            DispatchQueue.main.async(execute: {() -> Void in
                self.airLineTickerTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Airline Ticket", message: nil, preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.checkFrom == "airLineTickerTF"
                        {
                        self.airLineTickerTF.text = "Yes"
                        self.airLineTickerTF.resignFirstResponder()

                        }else{
                        self.hotelBookingTF.text = "Yes"
                        self.hotelBookingTF.resignFirstResponder()

                        }
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.checkFrom == "airLineTickerTF"
                       {
                       self.airLineTickerTF.text = "No"
                        self.airLineTickerTF.resignFirstResponder()

                       }else{
                       self.hotelBookingTF.text = "No"
                        self.hotelBookingTF.resignFirstResponder()

                       }
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
                alertController.addAction(okAction)
                alertController.addAction(okAction1)
                self.present(alertController, animated: true, completion: nil)
            })
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                self.airLineTickerTF.resignFirstResponder()
                let alertController = UIAlertController(title: "Choose Airline Ticket", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.checkFrom == "airLineTickerTF"
                        {
                        self.airLineTickerTF.text = "Yes"
                         self.airLineTickerTF.resignFirstResponder()

                        }else{
                        self.hotelBookingTF.text = "Yes"
                         self.hotelBookingTF.resignFirstResponder()

                        }
                        
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }
                let okAction1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.checkFrom == "airLineTickerTF"
                        {
                        self.airLineTickerTF.text = "No"
                         self.airLineTickerTF.resignFirstResponder()

                        }else{
                        self.hotelBookingTF.text = "No"
                         self.hotelBookingTF.resignFirstResponder()

                        }
                        
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
           self.uploadTimePathNameLbl.text = self.GetfileName

          
       }
}



extension BusinessTravelReqViewController: UIDocumentPickerDelegate{
    
    
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
