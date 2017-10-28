//
//  ViewController.swift
//  add-up-meijer
//
//  Created by Henrique Nascimento on 2017-10-25.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets    
    //Buttons    
    @IBOutlet var shortButtons: [UIButton]!
    @IBOutlet var longButtons: [UIButton]!
    @IBOutlet var plusButtons: [UIButton]!
    @IBOutlet var plusTaxeButtons: [UIButton]!
    //Buttons
    //Labels
    @IBOutlet var plusSignLabels: [UILabel]!
    @IBOutlet var displayLabels: [UILabel]!
    //Labels
    
    //MARK: Properties
    var numberToDisplay: String = ""
    var decimalClicked: Bool = false
    var decimalCounter: Int = -1
    var totalAmount: Float = 0.00
    
    //# MARK: - Instances
    var michiganTaxeObj: MichiganTaxe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        michiganTaxeObj = MichiganTaxe()
        let amount = addUpArray()
        displayLabel(text: informationToDisplay(theSum: amount))
        totalAmount = amount
        
        if plusButtons[0].alpha == 0.2 {
            plusSignHidden(newStatus: false)
        }        
        
        setButtonStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if numberToDisplay == "" {
            displayLabel(text: informationToDisplay(theSum: addUpArray()))
        } else {
            displayLabel(text: "$\(numberToDisplay)")
        }
    }
    
    //# MARK: - addUpArray
    private func addUpArray() -> Float {
        var amountToReturn: Float = 0.00
        for i in 0 ..< Singleton.sharedInstance.arrayOfItems.count {
            amountToReturn += Singleton.sharedInstance.arrayOfItems[i]
        }
        return amountToReturn
    }
    
    //# MARK: - informationToDisplay
    func informationToDisplay(theSum: Float) -> String {
        let sum: Float = theSum
        let bud: Float = Float(Singleton.sharedInstance.theBudget)
        let budgetLeft: Float = (bud - sum)
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let b: String = String(format: "Budget = $%.2f", budgetLeft)
            let s: String = String(format: "Total = $%.2f", sum)
            return "\(b)\n\(s)"
        } else {
            let b: String = String(format: "Budget:\n $%.2f", budgetLeft)
            let s: String = String(format: "Total:\n $%.2f", sum)
            return "\(b)\n\(s)"
        }
    }
    
    //# MARK: - buttonsManager
    @IBAction func buttonsManager(_ sender: UIButton) {
        switch sender.tag {
        case 0 ... 9 :            
            setAlphaToPlusButtons(1.0)
            setAlphaToPlusTaxeButtons(1.0)
            plusSignHidden(newStatus: true)
            displayAmount(theString: String(sender.tag))
            
        case 10 :
            if !decimalClicked {
                decimalClicked = true
                displayAmount(theString: ".")
            }
        case 11 :
            if sender.alpha != 0.2 {
                addingTotal()
                setAlphaToPlusButtons(0.2)
                setAlphaToPlusTaxeButtons(0.2)
            }
        case 12 :
            if sender.alpha != 0.2 {
                addingTotalWithTaxes()
                setAlphaToPlusButtons(0.2)
                setAlphaToPlusTaxeButtons(0.2)
            }
        default:
            break
        }
    }
    
    //# MARK: - displayAmount
    private func displayAmount(theString: String) {
        if decimalClicked {
            decimalCounter += 1
            if decimalCounter <= 2 {
                numberToDisplay += theString
                displayLabel(text: "$\(numberToDisplay)")
            }
        } else {
            numberToDisplay += theString
            displayLabel(text: "$\(numberToDisplay)")
        }
    }
    
    //# MARK: - addingTotal
    private func addingTotal() {
        if self.numberToDisplay == "" {
            return
        }
        Singleton.sharedInstance.addToArray(theNumber: Float(numberToDisplay)!)
        totalAmount = self.addUpArray()
        numberToDisplay = ""
        displayLabel(text: informationToDisplay(theSum: totalAmount))
        decimalClicked = false
        decimalCounter = -1
        plusSignHidden(newStatus: false)
    }
    
    //# MARK: - addingTotalWithTaxes
    private func addingTotalWithTaxes() {
        if self.numberToDisplay == "" {
            return
        }
        
        let amountWithTaxes = michiganTaxeObj.getAmountWithTaxes(initialAmount: Float(numberToDisplay)!)
        Singleton.sharedInstance.addToArray(theNumber: Float(amountWithTaxes)!)
        totalAmount = addUpArray()
        numberToDisplay = ""
        displayLabel(text: informationToDisplay(theSum: totalAmount))
        decimalClicked = false
        decimalCounter = -1
        plusSignHidden(newStatus: false)
    }
    
    //# MARK: - erase
    @IBAction func erase(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Message", message: "Do you really want to erase everything?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.numberToDisplay = ""
            self.displayLabel(text: self.informationToDisplay(theSum: 0.0))
            self.decimalClicked = false
            self.decimalCounter = -1
            self.totalAmount = 0.00
            self.setAlphaToPlusButtons(0.2)
            self.setAlphaToPlusTaxeButtons(0.2)
            self.plusSignHidden(newStatus: true)
            Singleton.sharedInstance.emptyArray()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if numberToDisplay == "" {
            displayLabel(text: informationToDisplay(theSum: addUpArray()))
        } else {
            displayLabel(text: "$\(numberToDisplay)")
        }
    }
    
    private func displayLabel(text: String!) {
        for label in displayLabels {
            label.text = text
        }
    }
    
    private func plusSignHidden(newStatus: Bool!) {
        for label in plusSignLabels {
            label.isHidden = newStatus
        }
    }
    
    private func setAlphaToPlusButtons(_ alpha: CGFloat!) {
        for button in plusButtons {
            button.alpha = alpha
            if alpha < 1 {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
        }
    }
    
    private func setAlphaToPlusTaxeButtons(_ alpha: CGFloat!) {
        for button in plusTaxeButtons {
            button.alpha = alpha
            if alpha < 1 {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
        }
    }
}

//MARK: Extension to style
extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setButtonStyle() {
        for button in longButtons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.backgroundColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.05)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 6/255, green: 147/255, blue: 35/255, alpha: 0.5).cgColor
            button.setBackgroundColor(color: UIColor.white, forState: UIControlState.highlighted)
        }
        
        for button in shortButtons {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.backgroundColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.05)
            button.layer.cornerRadius = (button.layer.frame.size.width / 2)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 6/255, green: 147/255, blue: 35/255, alpha: 0.5).cgColor
            button.setBackgroundColor(color: UIColor.white, forState: UIControlState.highlighted)
        }
    }
}

