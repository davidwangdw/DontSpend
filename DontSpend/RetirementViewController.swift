//
//  RetirementViewController.swift
//  DontSpend
//
//  Created by David Wang on 1/29/17.
//  Copyright © 2017 David Wang. All rights reserved.
//
// palm tree tab icon is designed by Vexels.com

import UIKit

class RetirementViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var currentNWInput: UITextField!
    @IBOutlet weak var amtPerYear: UITextField!
    @IBOutlet weak var targetRetirementAmt: UITextField!
    @IBOutlet weak var yearsUntilRetirement: UILabel!
    
    @IBOutlet weak var spendAmount: UITextField!
    
    @IBOutlet weak var summaryField: UITextView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var frequencyControl: UISegmentedControl!
    
    var categoryPickerData = ["Short Term (3 Month T. Bill)", "Long Term (10 Year T. Bond)", "S&P 500"]
    
    var inflation: Double = 0.0329
    var returnForSP500: Double = 0.0950
    var returnForShortTerm: Double = 0.0345
    var returnForLongTerm: Double = 0.0496
    
    //0 is once, 1 is per month
    var onceOrMonth: Int = 0
    
    var yearDifference: Double = 0.0
    
    let alertController = UIAlertController(title: "Error", message: "Please input a number between 1 and 1,000,000", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    
    @IBAction func frequencyControlChanged(_ sender: Any) {
        
        switch frequencyControl.selectedSegmentIndex {
            
        case 0:
            onceOrMonth = 0
        case 1:
            onceOrMonth = 1
        default:
            ()
            
        }
        
    }

    
    @IBAction func calculateButton(_ sender: Any) {
        
        let currentNWDouble = Double(currentNWInput.text!)
        let amtPerYearDouble = Double(amtPerYear.text!)
        let targetRetirementAmtDouble = Double(targetRetirementAmt.text!)
        let spendAmountDouble = Double(spendAmount.text!)
        
        
        
        //get values for rates from second tab
        let secondTab = self.tabBarController?.viewControllers?[2] as! AboutViewController
        
        inflation = secondTab.inflationRate
        returnForShortTerm = secondTab.shortTermRate
        returnForLongTerm = secondTab.longTermRate
        returnForSP500 = secondTab.SP500Rate
        
        let selection = categoryPicker.selectedRow(inComponent: 0)
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        
        if let i = currentNWDouble, i < 1000000, let j = amtPerYearDouble, j < 1000000, let l = targetRetirementAmtDouble, l < 1000000, let m = spendAmountDouble, m < 1000000 {
            
            
            
            if selection == 0 {
                let yearsUntilRetirementDouble: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForShortTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                
                yearsUntilRetirement.text = String(format: "%.2f", yearsUntilRetirementDouble)
                
                if onceOrMonth == 0 { //once
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble! + spendAmountDouble!, rate: returnForShortTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
    
                }
            
                if onceOrMonth == 1 { //monthly
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForShortTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble! + spendAmountDouble!)
        
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                }
                
                
            } else if selection == 1 {
                let yearsUntilRetirementDouble: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForLongTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                
                yearsUntilRetirement.text = String(format: "%.2f", yearsUntilRetirementDouble)
                
                if onceOrMonth == 0 { //once
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble! + spendAmountDouble!, rate: returnForLongTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                    
                }
                
                if onceOrMonth == 1 { //monthly
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForLongTerm, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble! + spendAmountDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                }

                
                
            } else if selection == 2 {
                let yearsUntilRetirementDouble: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForSP500, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                
                yearsUntilRetirement.text = String(format: "%.2f", yearsUntilRetirementDouble)
                
                if onceOrMonth == 0 { //once
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble! + spendAmountDouble!, rate: returnForSP500, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                    
                }
                
                if onceOrMonth == 1 { //monthly
                    let newYearsUntilRetirement = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForSP500, targetWorth: targetRetirementAmtDouble!, payment: amtPerYearDouble! + spendAmountDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                }

                
                
            }
            
            summaryField.text = "If you saved $" + spendAmount.text! + " instead of spending it, you would be able to retire " + String(format: "%.2f", yearDifference) + " years, or " + String(format: "%.2f", yearDifference * 365) + " days earlier!"
            
            return
            
        }

        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        alertController.addAction(defaultAction)
        
        yearsUntilRetirement.text = ""
        summaryField.text = ""
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func yearsUntilRetirementFunc(netWorth: Double, rate: Double, targetWorth: Double, payment: Double) -> Double {
        //figure out correct equation for this
        return log((targetWorth * rate + payment) / (payment + netWorth * rate))/log(1 + rate)
    }

    func returnOfAnnuity(payment: Double, rate: Double, years: Double) {
        
    }
    func returnsIfInvested(amount: Double, rate: Double, years: Double) -> NSNumber {
            return NSNumber(value: amount*pow(1 + rate - inflation,years))
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return categoryPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // LOOK AGAIN AT THIS CODE
        let pickerLabel = UILabel()
        let titleData = categoryPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor(red: 207.0/255.0, green: 211.0/255.0, blue: 212.0/255.0, alpha: 1)])
        
        
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .center
        //pickerLabel.backgroundColor = UIColor(hue: 1, saturation: 1.0, brightness:1.0, alpha: 1.0)
        return pickerLabel
    }


}
