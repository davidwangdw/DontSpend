//
//  AboutViewController.swift
//  DontSpend
//
//  Created by David Wang on 1/1/17.
//  Copyright © 2017 David Wang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func changeValueButton(_ sender: Any) {
        
        let inflationRate = Double(inflationRateField.text!)
        let shortTermRate = Double(shortTermRateField.text!)
        let longTermRate = Double(longTermRateField.text!)
        let SP500Rate = Double(SP500RateField.text!)
        
        if let i = inflationRate, i < 100
        
        /*
         
         
         
         if let v = amountDollars, v > 100000.00 {
         
         present(alertController, animated: true, completion: nil)
         
         return
         }*/
        print("change button pressed")
    }
    @IBOutlet weak var dollarValue: UISegmentedControl!
    
    @IBOutlet weak var inflationRateField: UITextField!
    @IBOutlet weak var shortTermRateField: UITextField!
    @IBOutlet weak var longTermRateField: UITextField!
    @IBOutlet weak var SP500RateField: UITextField!

    
    @IBAction func defaultButton(_ sender: Any) {
        print("Default button pressed")
    }

    @IBAction func linkButton(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.davidwangdw.com")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        
        inflationRateField.delegate = self
        shortTermRateField.delegate = self
        longTermRateField.delegate = self
        SP500RateField.delegate = self

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return true
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }


}
