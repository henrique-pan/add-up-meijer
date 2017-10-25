//=================================
import UIKit
//=================================
class ViewController: UIViewController {
    //# MARK: - IBOutlets
    @IBOutlet weak var labelNumberToDisplay: UILabel!
    
    @IBOutlet weak var plusSign: UILabel!    
    
    // Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonPoint: UIButton!
    @IBOutlet weak var taxesButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var shortButtonsArray: [UIButton]!
    var longButtonsArray: [UIButton]!
    // Buttons
    
    //# MARK: - Properties
    var numberToDisplay: String = ""
    var decimalClicked: Bool = false
    var decimalCounter: Int = -1
    var totalAmount: Float = 0.00
    var h: CGFloat! = 0.0
    var w: CGFloat! = 0.0
    
    //# MARK: - Instances
    var quebecTaxesObj: QuebecTaxes!
    
    //# MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.quebecTaxesObj = QuebecTaxes()
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.addUpArray())
        self.totalAmount = self.addUpArray()
        if self.plusButton.alpha == 0.2 {
            self.plusSign.alpha = 1.0
        }
        
        shortButtonsArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9]
        longButtonsArray = [button0, buttonPoint, taxesButton, plusButton]
        setButtonStyle()

    }
    
    func setButtonStyle() {
        for button in longButtonsArray {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
            //button.backgroundColor = .clear
            button.backgroundColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.05)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            //button.layer.borderColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.5).cgColor
            button.layer.borderColor = UIColor(red: 6/255, green: 147/255, blue: 35/255, alpha: 0.5).cgColor
        }
        
        for button in shortButtonsArray {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
            //button.backgroundColor = .clear
            button.backgroundColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.05)
            button.layer.cornerRadius = (button.layer.frame.size.width / 2)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 6/255, green: 147/255, blue: 35/255, alpha: 0.5).cgColor
        }
    }
    
    
    //# MARK: - informationToDisplay
    func informationToDisplay(theSum: Float) -> String {
        let sum: Float = theSum
        let bud: Float = Float(Singleton.sharedInstance.theBudget)
        let budgetLeft: Float = (bud - sum)
        let b: String = String(format: "Budget = $%.2f", budgetLeft)
        let s: String = String(format: "Total = $%.2f", sum)
        return "\(b)\n\(s)"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //# MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# MARK: - buttonsManager
    @IBAction func buttonsManager(_ sender: UIButton) {
        switch sender.tag {
        case 0 ... 9 :
            self.plusButton.alpha = 1.0
            self.taxesButton.alpha = 1.0
            self.plusSign.alpha = 0.0
            self.displayAmount(theString: String(sender.tag))
            
        case 10 :
            if !self.decimalClicked {
                self.decimalClicked = true
                self.displayAmount(theString: ".")
            }
        case 11 :
            if sender.alpha != 0.2 {
                self.addingTotal()
                sender.alpha = 0.2
                self.taxesButton.alpha = 0.2
            }
        case 12 :
            if sender.alpha != 0.2 {
                self.addingTotalWithTaxes()
                sender.alpha = 0.2
                self.plusButton.alpha = 0.2
            }
        default:
            break
        }
    }
    
    //# MARK: - displayAmount
    private func displayAmount(theString: String) {
        if self.decimalClicked {
            self.decimalCounter += 1
            if self.decimalCounter <= 2 {
                self.numberToDisplay += theString
                self.labelNumberToDisplay.text = "$\(self.numberToDisplay)"
            }
        } else {
            self.numberToDisplay += theString
            self.labelNumberToDisplay.text = "$\(self.numberToDisplay)"
        }
    }
    
    //# MARK: - erase
    @IBAction func erase(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Message", message: "Do you really want to erase everything?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
                self.numberToDisplay = ""
                self.labelNumberToDisplay.text = self.informationToDisplay(theSum: 0.00)
                self.decimalClicked = false
                self.decimalCounter = -1
                self.totalAmount = 0.00
                self.plusButton.alpha = 0.2
                self.taxesButton.alpha = 0.2
                self.plusSign.alpha = 0.0
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
    
    //# MARK: - addingTotal
    private func addingTotal() {
        Singleton.sharedInstance.addToArray(theNumber: Float(self.numberToDisplay)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    //# MARK: - addingTotalWithTaxes
    private func addingTotalWithTaxes() {
        let amountWithTaxes = self.quebecTaxesObj.getAmountWithTaxes(initialAmount: Float(self.numberToDisplay)!)
        Singleton.sharedInstance.addToArray(theNumber: Float(amountWithTaxes)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    //# MARK: - addUpArray
    private func addUpArray() -> Float {
        var amountToReturn: Float = 0.00
        for i in 0 ..< Singleton.sharedInstance.arrayOfItems.count {
            amountToReturn += Singleton.sharedInstance.arrayOfItems[i]
        }
        return amountToReturn
    }
}











