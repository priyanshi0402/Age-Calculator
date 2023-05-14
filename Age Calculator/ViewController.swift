//
//  ViewController.swift
//  Age Calculator
//
//  Created by SARVADHI on 04/05/23.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var txtBirthDate: CustomTextField!
    @IBOutlet weak var txtBirthMonth: CustomTextField!
    @IBOutlet weak var txtBirthYear: CustomTextField!
    @IBOutlet weak var txtCurrentDate: CustomTextField!
    @IBOutlet weak var txtCurrentMonth: CustomTextField!
    @IBOutlet weak var txtCurrentYear: CustomTextField!
    
    var tag = 0
    var birthDate: Date?
    var choosedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDate()
        self.dateView.isHidden = true
        self.menuView.isHidden = true
        self.menuView.roundCorners(radius: 10, corners: [.topLeft, .bottomLeft])
    
        // Do any additional setup after loading the view.
    }
    
    func setupDate() {
        let currentDate = Date()
        self.choosedDate = currentDate
        self.birthDate = currentDate
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year], from: currentDate)
        
        self.txtBirthDate.text = dateComponents.day?.toString
        self.txtBirthMonth.text = dateComponents.month?.toString
        self.txtBirthYear.text = dateComponents.year?.toString
        self.txtCurrentDate.text = dateComponents.day?.toString
        self.txtCurrentMonth.text = dateComponents.month?.toString
        self.txtCurrentYear.text = dateComponents.year?.toString
    }
    

    @IBAction func actionDone(_ sender: Any) {
        print(self.datePicker.date)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year], from: self.datePicker.date)
        if self.tag == 101 {
            self.txtBirthDate.text = dateComponents.day?.toString
            self.txtBirthMonth.text = dateComponents.month?.toString
            self.txtBirthYear.text = dateComponents.year?.toString
            self.birthDate = self.datePicker.date
        } else {
            self.txtCurrentDate.text = dateComponents.day?.toString
            self.txtCurrentMonth.text = dateComponents.month?.toString
            self.txtCurrentYear.text = dateComponents.year?.toString
            self.choosedDate = self.datePicker.date
        }
        self.dateView.isHidden = true
    }
    
    @IBAction func openDatePicker(_ sender: UIButton) {
        if self.tag == 101 {
            self.datePicker.date = self.birthDate ?? Date()
        } else {
            self.datePicker.date = self.choosedDate ?? Date()
        }
        self.tag = sender.tag
        self.dateView.isHidden = false
    }
    
    @IBAction func actionMore(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden
    }
    
    func ShareMyApp() {
        let activityItems : NSArray = ["itms-apps://itunes.apple.com/us/app/apple-store/id6447046704?mt=8"]
        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: activityItems as! [Any], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6447046704") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }


    @IBAction func shareAppAction(_ sender: Any) {
        self.ShareMyApp()
    }
    
    @IBAction func feedBackAction(_ sender: Any) {
        self.rateApp()
    }
    
    @IBAction func aboutUs(_ sender: Any) {
        self.showAlert(vc: self, title: "Welcome to Age Master", message: "Welcome to our age calculator app, where we help you easily calculate your age and other important dates. Our mission is to provide a simple and efficient tool for calculating age, days between two dates, and other useful information. With our intuitive interface and accurate calculations, you can quickly determine your age in years, months, days, and even seconds. Our app is perfect for anyone who needs to calculate important dates quickly and easily!")
    }
    
    @IBAction func actionConvert(_ sender: Any) {
        let calendar = Calendar.current
        var birthDateComponents = DateComponents()
        birthDateComponents.day = self.txtBirthDate.text?.toInt
        birthDateComponents.month = self.txtBirthMonth.text?.toInt
        birthDateComponents.year = self.txtBirthYear.text?.toInt
        self.birthDate = birthDateComponents.date
        let targetCalendar = Calendar.current
        self.birthDate = targetCalendar.date(from: birthDateComponents)
        
        var dateComponents = DateComponents()
        dateComponents.day = self.txtCurrentDate.text?.toInt
        dateComponents.month = self.txtCurrentMonth.text?.toInt
        dateComponents.year = self.txtCurrentYear.text?.toInt
        self.choosedDate = dateComponents.date
        self.choosedDate = targetCalendar.date(from: dateComponents)
        
        if let birthDate = self.birthDate, let secondDate = self.choosedDate {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.choosedDate = secondDate
            vc.birthDate = birthDate
            self.navigationController?.pushViewController(vc , animated: true)
        }
        
    }
    
    func showAlert(vc: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension Int {
    var toString: String {
        return String(self)
    }
}

extension String {
    var toInt: Int {//
        return Int(self) ?? 0
    }
}
