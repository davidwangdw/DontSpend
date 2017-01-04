//
//  AboutViewController.swift
//  DontSpend
//
//  Created by David Wang on 1/1/17.
//  Copyright © 2017 David Wang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextFieldDelegate {
    
    var inflationRate: Double = 3.29/100.0
    var shortTermRate: Double = 3.45/100.0
    var longTermRate: Double = 4.96/100.0
    var SP500Rate: Double  = 9.50/100.0
    var dollarValueInt: Int = 0
    
    let alertController = UIAlertController(title: "Error", message: "Please fill all the fields with a number between 0 and 100", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    
    @IBAction func dollarValueChanged(_ sender: Any) {
        
        switch dollarValue.selectedSegmentIndex {
            
        case 0:
            dollarValueInt = 0
        case 1:
            dollarValueInt = 1
        default:
            ()
            
        }
        
    }
    
    @IBAction func changeValueButton(_ sender: Any) {
        
        let inflationRate = Double(inflationRateField.text!)
        let shortTermRate = Double(shortTermRateField.text!)
        let longTermRate = Double(longTermRateField.text!)
        let SP500Rate = Double(SP500RateField.text!)
        
        if let i = inflationRate, i < 100, let j = shortTermRate, j < 100, let l = longTermRate, l < 100, let m = SP500Rate, m < 100 {
            
            //good value
            
            self.inflationRate = i/100.0
            self.shortTermRate = j/100.0
            self.longTermRate = l / 100.0
            self.SP500Rate = m / 100.0
            
            return
        }
        
        present(alertController, animated: true, completion: nil)
        
        return
        
    }
    
    @IBOutlet weak var dollarValue: UISegmentedControl!
    @IBOutlet weak var inflationRateField: UITextField!
    @IBOutlet weak var shortTermRateField: UITextField!
    @IBOutlet weak var longTermRateField: UITextField!
    @IBOutlet weak var SP500RateField: UITextField!

    
    @IBAction func defaultButton(_ sender: Any) {
        
        inflationRateField.text = "3.29"
        shortTermRateField.text = "3.45"
        longTermRateField.text = "4.96"
        SP500RateField.text = "9.50"
        
        inflationRate = 3.29/100.0
        shortTermRate = 3.45/100.0
        longTermRate = 4.96/100.0
        SP500Rate = 9.50/100.0
        
    }

    
    @IBAction func githubButton(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://github.com/davidwangdw/dontspend/blob/master/README.md")!)
    }
    
    @IBAction func linkButton(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.davidwangdw.com")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        
        //only allows one decimal place
        inflationRateField.delegate = self
        shortTermRateField.delegate = self
        longTermRateField.delegate = self
        SP500RateField.delegate = self

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        alertController.addAction(defaultAction)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //only allows one decimal place
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return true
    }
    
    //hides keyboard on tap, along with code in viewDidLoad
    func didTapView(){
        self.view.endEditing(true)
    }


}
