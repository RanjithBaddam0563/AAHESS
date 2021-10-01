//
//  ItSupportViewController.swift
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


class ItSupportViewController: UIViewController,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var categoryTypeDetails : [categoryDetailsModel] = []
    var subcategoryTypeDetails : [subcategoryDetailsModel] = []
    var serviceTypeDetails : [serviceTypeModel] = []
    var PriorityTypeDetails : [PriorityTypeModel] = []

    var textFieldName : String = ""

    var categoryId : String = ""
    var subcategoryId : String = ""
    var serviceTypeId : String = ""
    var PriorityTypeId : String = ""

    @IBOutlet weak var txtView: UITextView!
     var myPickerView : UIPickerView!
    @IBOutlet var titleTF: TextField!
    @IBOutlet var priorityTF: TextField!
    @IBOutlet var serviceTypeTF: TextField!
    @IBOutlet var subCategoryTF: TextField!
    @IBOutlet var categoryTF: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList()
        fetchserviceTypeDetails()
        self.PriorityDetails()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        txtView.delegate = self
        txtView.text = "Description"
        txtView.textColor = UIColor.lightGray
        
        let logo = UIImage(named: "logo1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor.white)
        self.navigationItem.titleView = imageView
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = UIColor.darkGray.cgColor
      
    }
    func textViewDidBeginEditing(_ textView: UITextView) {

           if txtView.textColor == UIColor.lightGray {
               txtView.text = ""
               txtView.textColor = UIColor.black
           }
       }
       func textViewDidEndEditing(_ textView: UITextView) {

           if txtView.text == "" {
               txtView.text = "Description"
               txtView.textColor = UIColor.lightGray
           }
       }
    @IBAction func ClickOnCancelBtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ClickOnSubmit(_ sender: UIButton)
    {
        if categoryTF.text == "" {
            categoryTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please choose category", controller: self)
        }else if subCategoryTF.text == "" {
            subCategoryTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please choose subcategory", controller: self)
        }else if serviceTypeTF.text == "" {
            serviceTypeTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please choose service type", controller: self)
        }else if priorityTF.text == "" {
            priorityTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
            Toast.show(message: "Please choose priority", controller: self)
        }else{
            SubmitItsupportDetails()
        }
    }
    func SubmitItsupportDetails()
    {
        if Connectivity.isConnectedToInternet {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
//       var semaphore = DispatchSemaphore (value: 0)

            let parameters = "{ \"itSupportApplicationsId\": \"\("1")\",\"itSupportCategoryId\": \"\(self.categoryId)\",\"itSupportSubCategoryId\": \"\(self.subcategoryId)\",\"itSupportServiceTypeId\": \"\(self.serviceTypeId)\",\"priorityId\": \"\(self.PriorityTypeId)\", \"title\": \"\(self.titleTF.text!)\",\"description\": \"\(self.txtView.text!)\"}\n"
        print(parameters)
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string:MyStrings().submitITsupport)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token =  UserDefaults.standard.string(forKey: "Token")!

        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("citrix_ns_id=Zru2trWjmyk78uEatbqye7/1Pu00000", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        request.httpBody = postData

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
                       if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                           print("statusCode should be 200, but is \(httpStatus.statusCode)")
                           DispatchQueue.main.async(execute: {() -> Void in
                               Toast.show(message: "Service not available please try again", controller: self)
                           })
                       }else{
                           var jsonDictionary1 : NSDictionary?
                           do {
                               jsonDictionary1 = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                           
                               print(jsonDictionary1!)
                               DispatchQueue.main.async {
                               self.AskConfirmation(title: "My Alert", message: "IT Support Request Added Successfully") { (result) in
                                  if result {
                                   self.navigationController?.popViewController(animated: true)
                                  } else {
                                      
                                  }
                              }
                                          }
                           } catch {
                               print(error)
                               DispatchQueue.main.async(execute: {() -> Void in
                                   Toast.show(message: "Service not available please try again", controller: self)
                               })
                           }
                       }
//          semaphore.signal()
        }

        task.resume()
//        semaphore.wait()
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
        if textField == categoryTF
        {
            textFieldName = "category"
            self.pickUp(categoryTF)

        }else if textField == subCategoryTF
        {
            if categoryTF.text == "" {
                subCategoryTF.resignFirstResponder()
                categoryTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
                Toast.show(message: "Please choose category", controller: self)
            }else{
            textFieldName = "subCategory"
            self.pickUp(subCategoryTF)
            }

        }else if textField == serviceTypeTF
        {
            textFieldName = "serviceType"
            self.pickUp(serviceTypeTF)

        }else if textField == priorityTF
        {
            textFieldName = "priority"
            self.pickUp(priorityTF)

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
    @objc func   doneClick() {
        categoryTF.resignFirstResponder()
        subCategoryTF.resignFirstResponder()
        serviceTypeTF.resignFirstResponder()
        priorityTF.resignFirstResponder()
     }
    @objc func   cancelClick() {
      categoryTF.resignFirstResponder()
      subCategoryTF.resignFirstResponder()
      serviceTypeTF.resignFirstResponder()
        priorityTF.resignFirstResponder()
    }
    
    struct Connectivity {
           static let sharedInstance = NetworkReachabilityManager()!
           static var isConnectedToInternet:Bool {
               return self.sharedInstance.isReachable
           }
       }
    func categoryList()
        {
            self.categoryTypeDetails.removeAll()
            if Connectivity.isConnectedToInternet {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let par = MyStrings().categoryTypeInfo
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
                     let details = categoryDetailsModel.init(json: subJson)
                     self.categoryTypeDetails.append(details)
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
        if textFieldName == "category" {
        if categoryTypeDetails.count == 0 {
         return 0
        }else{
       return categoryTypeDetails.count
        }
        }else if textFieldName == "subCategory"{
         if subcategoryTypeDetails.count == 0 {
          return 0
         }else{
        return subcategoryTypeDetails.count
         }
        }else if textFieldName == "serviceType"{
         if serviceTypeDetails.count == 0 {
          return 0
         }else{
        return serviceTypeDetails.count
         }
        }else{
         if PriorityTypeDetails.count == 0 {
          return 0
         }else{
        return PriorityTypeDetails.count
         }
        }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textFieldName == "category" {
        return categoryTypeDetails[row].name
        }else if textFieldName == "subCategory"{
        return subcategoryTypeDetails[row].name
        }else if textFieldName == "serviceType"{
        return serviceTypeDetails[row].name
        }else{
        return PriorityTypeDetails[row].name
        }
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textFieldName == "category" {
        self.categoryTF.text = categoryTypeDetails[row].name
        self.categoryId = String(categoryTypeDetails[row].itSupportCategoriesId)
        if self.categoryTF.text != ""
        {
            self.subCategoryTF.text = ""
            self.fetchsubCategoryDetails()
        }else{
            
        }
     }else if textFieldName == "subCategory" {
        self.subCategoryTF.text = subcategoryTypeDetails[row].name
        self.subcategoryId = String(subcategoryTypeDetails[row].itSupportSubCategoriesId)
        if self.subCategoryTF.text != ""
        {
//            self.serviceTypeTF.text = ""
//            self.fetchserviceTypeDetails()
        }else{
            
        }
        }else if textFieldName == "serviceType"{
        self.serviceTypeTF.text = serviceTypeDetails[row].name
        self.serviceTypeId = String(serviceTypeDetails[row].itSupportServiceTypesId)
        if self.serviceTypeTF.text != ""
        {
//            self.PriorityDetails()
        }else{
            
        }
        }else{
        self.priorityTF.text = PriorityTypeDetails[row].name
        self.PriorityTypeId = String(PriorityTypeDetails[row].itSupportPriorityId)
        }
    }
    func fetchsubCategoryDetails()
    {
        self.subcategoryTypeDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().subcategoryTypeInfo + categoryId
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
                 let details = subcategoryDetailsModel.init(json: subJson)
                 self.subcategoryTypeDetails.append(details)
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
    func fetchserviceTypeDetails()
    {
        self.serviceTypeDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().serviceTypeInfo
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
                 let details = serviceTypeModel.init(json: subJson)
                 self.serviceTypeDetails.append(details)
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
    func PriorityDetails()
    {
        self.PriorityTypeDetails.removeAll()
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let par = MyStrings().PriorityTypeInfo
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
                 let details = PriorityTypeModel.init(json: subJson)
                 self.PriorityTypeDetails.append(details)
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
