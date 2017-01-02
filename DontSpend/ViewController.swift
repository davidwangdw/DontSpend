//
//  ViewController.swift
//  DontSpend
//
//  Created by David Wang on 12/30/16.
//  Copyright © 2016 David Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var resultLabel1: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var resultLabel3: UILabel!
    @IBOutlet weak var resultLabel4: UILabel!
    
    // these are the geometric returns calculated from the bottom website for the years 1928 - 2014
    // http://pages.stern.nyu.edu/~adamodar/New_Home_Page/datafile/histretSP.html
    // http://data.bls.gov/cgi-bin/cpicalc.pl
    
    var inflation: Double = 0.0307
    var returnForSP500: Double = 0.0960
    var returnForShortTerm: Double = 0.0349
    var returnForLongTerm: Double = 0.0500
    
    //for real or nominal values
    var dollarValue: Int = 0
    
    //Creating the alert controller
    let alertController = UIAlertController(title: "Error", message: "Please input a number between 1 and 100,000", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var categoryPickerData = ["Short Term Treasuries", "Long Term Treasuries (10 Years)", "S&P 500"]
    
    
    //can clean up this function, no need for so many parameters because they already exist
    func returnsIfInvested(amount: Double, rate: Double, years: Double, dollar: Int) -> NSNumber{
        
        if dollar == 0 {
            return NSNumber(value: amount*pow(1 + rate - inflation,years))
        } else if dollar == 1 {
            return NSNumber(value: amount*pow(1 + rate,years))
        }
        
 
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        alertController.addAction(defaultAction)
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.resultLabel1.text = ""
        self.resultLabel2.text = ""
        self.resultLabel3.text = ""
        self.resultLabel4.text = ""

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func calculateButton(_ sender: Any) {
        
        
        //get values for rates from second tab
        let secondTab = self.tabBarController?.viewControllers?[1] as! AboutViewController
        
        inflation = secondTab.inflationRate
        returnForShortTerm = secondTab.shortTermRate
        returnForLongTerm = secondTab.longTermRate
        returnForSP500 = secondTab.SP500Rate
        dollarValue = secondTab.dollarValue
        
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        guard let text = self.amountField.text, !text.isEmpty else {
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        let selection = categoryPicker.selectedRow(inComponent: 0)
        
        let amountDollars = Double(amountField.text!)
        
        if let v = amountDollars, v > 100000.00 {
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        
        
        if selection == 0 {
            
            self.resultLabel1.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForShortTerm, years: 5))! + " in 5 years"
            self.resultLabel2.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForShortTerm, years: 10))! + " in 10 years"
            self.resultLabel3.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForShortTerm, years: 20))! + " in 20 years"
            self.resultLabel4.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForShortTerm, years: 30))! + " in 30 years"
            
            
            
        } else if selection == 1 {
            self.resultLabel1.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForLongTerm, years: 5))! + " in 5 years"
            self.resultLabel2.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForLongTerm, years: 10))! + " in 10 years"
            self.resultLabel3.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForLongTerm, years: 20))! + " in 20 years"
            self.resultLabel4.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForLongTerm, years: 30))! + " in 30 years"
            
            
            
        } else if selection == 2 {
            
            self.resultLabel1.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForSP500, years: 5))! + " in 5 years"
            self.resultLabel2.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForSP500, years: 10))! + " in 10 years"
            self.resultLabel3.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForSP500, years: 20))! + " in 20 years"
            self.resultLabel4.text = currencyFormatter.string(from: self.returnsIfInvested(amount: amountDollars!, rate: self.returnForSP500, years: 30))! + " in 30 years"
        }
        
        
    }
    
    //following code for animations - implement later
    /*
 
 func showLogoView() {
 if !logoVisible {
 logoVisible = true
 containerView.isHidden = true
 logoTop.isHidden = true
 view.addSubview(logoButton)
 }
 }
 
 func hideLogoView() {
 
 // to animate logo
 
 if !logoVisible { return }
 
 logoVisible = false
 containerView.isHidden = false
 logoTop.isHidden = false
 
 let logoFade = CABasicAnimation(keyPath: "opacity")
 logoFade.isRemovedOnCompletion = false
 logoFade.fromValue = 1
 logoFade.duration = 1
 logoFade.toValue = 0
 logoButton.layer.add(logoFade, forKey: "logoFade")
 
 logoButton.removeFromSuperview()
 
 let panelMover = CABasicAnimation(keyPath: "opacity")
 panelMover.isRemovedOnCompletion = false
 panelMover.fromValue = 0
 panelMover.duration = 1
 panelMover.toValue = 1
 containerView.layer.add(panelMover, forKey: "panelMover")
 logoTop.layer.add(panelMover, forKey: "panelMover")
 
 
 }
 
 */
 
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //myLabel.text = pickerData[row]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }

}

