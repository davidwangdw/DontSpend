//
//  RetirementViewController.swift
//  DontSpend
//
//  Created by David Wang on 1/29/17.
//  Copyright © 2017 David Wang. All rights reserved.
//
//  palm tree tab icon is designed by Vexels.com

import UIKit

class RetirementViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentNWInput: UITextField!
    @IBOutlet weak var amtPerYear: UITextField!
    @IBOutlet weak var targetRetirementAmt: UITextField!
    @IBOutlet weak var yearsUntilRetirement: UILabel!
    
    @IBOutlet weak var spendAmount: UITextField!
    
    @IBOutlet weak var summaryField: UITextView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var frequencyControl: UISegmentedControl!
    
    var inflation: Double = 0.0329
    var returnForSP500: Double = 0.0950
    var returnForShortTerm: Double = 0.0345
    var returnForLongTerm: Double = 0.0496
    
    //0 is once, 1 is per month
    var onceOrMonth: Int = 0
    
    var yearDifference: Double = 0.0
    
    let alertController = UIAlertController(title: "Error", message: "Please fill all fields with a number between 1 and 9,000,000, and make sure your target retirement amount is more than your current net worth. If you just want to see how long it'll take you to retire on your current savings rate, enter 0 as your spend amount.", preferredStyle: .alert)
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
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        
        if let i = currentNWDouble, i < 9000000, let j = amtPerYearDouble, j < 9000000, let l = targetRetirementAmtDouble, l < 9000000, spendAmountDouble == nil, i < l {
            
            let yearsUntilRetirementDouble: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForSP500 - inflation, targetWorth: targetRetirementAmtDouble!, payment: 12.0*amtPerYearDouble!)
            
            yearsUntilRetirement.text = String(format: "%.2f", yearsUntilRetirementDouble)
            
            return
        }
        
        if let i = currentNWDouble, i < 9000000, let j = amtPerYearDouble, j < 9000000, let l = targetRetirementAmtDouble, l < 9000000, let m = spendAmountDouble, m < 9000000, i < l {
                    let yearsUntilRetirementDouble: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForSP500 - inflation, targetWorth: targetRetirementAmtDouble!, payment: 12.0*amtPerYearDouble!)
                
                yearsUntilRetirement.text = String(format: "%.2f", yearsUntilRetirementDouble)
                
                if onceOrMonth == 0 { //once
                    let newYearsUntilRetirement: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble! + spendAmountDouble!, rate: returnForSP500 - inflation, targetWorth: targetRetirementAmtDouble!, payment: 12.0*amtPerYearDouble!)
                    
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
    
                }
            
                if onceOrMonth == 1 { //monthly
                    let newYearsUntilRetirement: Double = yearsUntilRetirementFunc(netWorth: currentNWDouble!, rate: returnForSP500 - inflation, targetWorth: targetRetirementAmtDouble!, payment: 12.0*(amtPerYearDouble! + spendAmountDouble!))
        
                    yearDifference = yearsUntilRetirementDouble - newYearsUntilRetirement
                }
            
            summaryField.text = "If you saved $" + spendAmount.text! + " instead of spending it, you would be able to retire " + String(format: "%.2f", yearDifference) + " years, or " + String(format: "%.2f", yearDifference * 365) + " days earlier!"
            
            self.view.endEditing(true)
            
            return
            
        }

        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        alertController.addAction(defaultAction)
        
        yearsUntilRetirement.text = ""
        summaryField.text = ""
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func yearsUntilRetirementFunc(netWorth: Double, rate: Double, targetWorth: Double, payment: Double) -> Double {
        return log((targetWorth * (rate-inflation) + payment) / (payment + netWorth * (rate-inflation)))/log(1 + (rate-inflation))
    }

    func returnOfAnnuity(payment: Double, rate: Double, years: Double) {
        
    }
    func returnsIfInvested(amount: Double, rate: Double, years: Double) -> NSNumber {
            return NSNumber(value: amount*pow(1 + rate - inflation,years))
    }

    func didTapView(){
        self.view.endEditing(true)
    }


}
