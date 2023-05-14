//
//  DetailViewController.swift
//  Age Calculator
//
//  Created by SARVADHI on 04/05/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nextDate: UILabel!
    @IBOutlet weak var nextMonth: UILabel!
    @IBOutlet weak var lblTotalDays: UILabel!
    @IBOutlet weak var lbTotalSeconds: UILabel!
    @IBOutlet weak var lblTotalMinutes: UILabel!
    @IBOutlet weak var lblTotalHours: UILabel!
    @IBOutlet weak var lblTotalWeeks: UILabel!
    @IBOutlet weak var lblTotalMonths: UILabel!
    @IBOutlet weak var lblTotalYears: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    var birthDate = Date()
    var choosedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblYear.text = self.choosedDate.years(from: self.birthDate).toString
        self.lblDays.text = self.calculateAge().day.toString
        self.lblMonth.text = self.calculateAge().month.toString
        self.lblTotalMonths.text = self.choosedDate.months(from: self.birthDate).toString
        self.lblTotalDays.text = self.choosedDate.days(from: self.birthDate).toString
        self.lblTotalWeeks.text = self.choosedDate.weeks(from: self.birthDate).toString
        self.lblTotalHours.text = self.choosedDate.hours(from: self.birthDate).toString
        self.lblTotalMinutes.text = self.choosedDate.minutes(from: self.birthDate).toString
        self.lbTotalSeconds.text = self.choosedDate.seconds(from: self.birthDate).toString
        self.nextDate.text = self.daysUntil(birthday: self.birthDate).1.toString
        self.nextMonth.text = self.daysUntil(birthday: self.birthDate).0.toString
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func calculateAge() -> (year :Int, month : Int, day : Int){
        var years = 0
        var months = 0
        var days = 0
        
        let cal = Calendar.current
        years = cal.component(.year, from: self.choosedDate) -  cal.component(.year, from: self.birthDate)
        
        let currMonth = cal.component(.month, from: self.choosedDate)
        let birthMonth = cal.component(.month, from: self.birthDate)
        
        //get difference between current month and birthMonth
        months = currMonth - birthMonth
        //if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0 {
            years = years - 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: choosedDate) < cal.component(.day, from: birthDate){
                months = months - 1
            }
        } else if months == 0 && cal.component(.day, from: choosedDate) < cal.component(.day, from: birthDate) {
            years = years - 1
            months = 11
        }
        
        //Calculate the days
        if cal.component(.day, from: choosedDate) > cal.component(.day, from: birthDate){
            days = cal.component(.day, from: choosedDate) - cal.component(.day, from: birthDate)
        } else if cal.component(.day, from: choosedDate) < cal.component(.day, from: birthDate) {
            let today = cal.component(.day, from: choosedDate)
            let date = cal.date(byAdding: .month, value: -1, to: choosedDate)
            days = date!.daysInMonth - cal.component(.day, from: birthDate) + today
        } else {
            days = 0
            if months == 12 {
                years = years + 1
                months = 0
            }
        }
        
        return (years, months, days)
    }
    
    func daysUntil(birthday: Date) -> (Int, Int) {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let date = cal.startOfDay(for: birthday)
        let components = cal.dateComponents([.day, .month], from: date)
        let nextDate = cal.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        var days = cal.dateComponents([.day], from: today, to: nextDate ?? today).day ?? 0
        
        let month = cal.dateComponents([.month], from: today, to: nextDate ?? today).month ?? 0
        
        if cal.component(.day, from: today) > cal.component(.day, from: birthday){
            days = cal.component(.day, from: today) - cal.component(.day, from: birthday)
        } else if cal.component(.day, from: today) < cal.component(.day, from: birthday) {
            let todayD = cal.component(.day, from: today)
            print(todayD)
            let date = cal.date(byAdding: .month, value: +1, to: today)
            print(date!.daysInMonth)
            print(cal.component(.day, from: birthday))
            days = date!.daysInMonth + cal.component(.day, from: birthday) - todayD
        } else {
            days = 0
        }
        
        return (month, days)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Date{
     var daysInMonth:Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
