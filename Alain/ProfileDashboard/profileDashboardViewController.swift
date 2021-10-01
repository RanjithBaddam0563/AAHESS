//
//  profileDashboardViewController.swift
//  Alain
//
//  Created by MicroExcel on 7/7/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import UIKit

class profileDashboardViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        let logo = UIImage(named: "logo1")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: UIColor.white)
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
    }
    @IBAction func ClickOnGeneralInfoBtn(_ sender: Any)
    {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "generalInfoViewController")as! generalInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "generalInfoViewController")as! generalInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
    @IBAction func ClickOnPersonalInfoBtn(_ sender: Any) {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "personalInfoViewController")as! personalInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "personalInfoViewController")as! personalInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
    @IBAction func ClickOnAccountingInfoBtn(_ sender: Any) {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "AccountingInfoViewController")as! AccountingInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountingInfoViewController")as! AccountingInfoViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
    @IBAction func ClickOnDocumentBtn(_ sender: Any) {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "DocumentsViewController")as! DocumentsViewController
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController")as! DocumentsViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
    @IBAction func ClickOnSalarySlipBtn(_ sender: Any)
    {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "salarySlipsViewController")as! salarySlipsViewController
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "salarySlipsViewController")as! salarySlipsViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
}

