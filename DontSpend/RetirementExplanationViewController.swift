//
//  RetirementExplanationViewController.swift
//  DontSpend
//
//  Created by David Wang on 2/4/17.
//  Copyright © 2017 David Wang. All rights reserved.
//

import Foundation
import UIKit

class RetirementExplanationViewController: UIViewController {
    
    @IBOutlet weak var monthlyExpenses: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    let alertController = UIAlertController(title: "Error", message: "Please fill the expenses field with a vaue less than 100,000", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismisses keyboard on tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        alertController.addAction(defaultAction)
        
        self.view.backgroundColor = UIColor(red: 93/255.0, green: 100/255.0, blue: 118/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.resultLabel.text = ""

        
    }
    
    @IBAction func calculateButton(sender: AnyObject)
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        
        let monthlyExpensesDouble = Double(monthlyExpenses.text!)
        
        if let i = monthlyExpensesDouble, i < 100000 {
            let retirementAmount = monthlyExpensesDouble! * 25 * 12
            
            self.resultLabel.text = currencyFormatter.string(from: NSNumber(value:retirementAmount))!
            
            return
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func didTapView(){
        self.view.endEditing(true)
    }


    @IBAction func cancelScreen(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
