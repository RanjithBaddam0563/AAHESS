//
//  forgotPasswordViewController.swift
//  Alain
//
//  Created by MicroExcel on 9/3/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class forgotPasswordViewController: UIViewController {

    @IBOutlet var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white


        // Do any additional setup after loading the view.
    }
    
    @IBAction func ClickOnSubmitBtn(_ sender: UIButton)
    {
       if emailTF.text == "" {
           self.emailTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
           Toast.show(message: "Please enter email", controller: self)
       }else if !(self.emailTF.text!.isEmail) { // true
           self.emailTF.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
           Toast.show(message: "Please enter valid email", controller: self)
       }else{
        DispatchQueue.main.async {

            let alert = UIAlertController(title: "My alert", message: "Your request for reset password has been sent to admin. It will be updated within 24 hours and sent to your", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (result : UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        }
        
    }
    

}
extension String {
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))

        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    public var length: Int {
        return self.count
    }
}


