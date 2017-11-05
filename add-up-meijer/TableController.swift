//
//  TableController.swift
//  add-up-meijer
//
//  Created by Henrique Nascimento on 2017-10-26.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit
import Foundation

class TableController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var setButton: UIButton!
    
    //# MARK: - Properties
    var data = ["10"]
    var budget: Int = 0
    
    //# MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 2...30 {
            data.append(String(x * 10))
        }
        
        let theRow: Int = Singleton.sharedInstance.theBudget / 10 - 1
        picker.selectRow(theRow, inComponent: 0, animated: true)
        
        setButtonStyle()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func handleTap(sender: UIButton) {
        if sender.backgroundColor == UIColor.red {
            sender.backgroundColor = UIColor.blue
        } else {
            sender.backgroundColor = UIColor.red
        }
    }
    
    func setButtonStyle() {
        setButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setButton.backgroundColor = UIColor(red: 14/255, green: 59/255, blue: 144/255, alpha: 0.05)
        setButton.layer.cornerRadius = (setButton.layer.frame.size.width / 2)
        setButton.layer.borderWidth = 1
        setButton.layer.borderColor = UIColor(red: 6/255, green: 147/255, blue: 35/255, alpha: 0.5).cgColor
        
        setButton.setBackgroundColor(color: UIColor.white, forState: UIControlState.highlighted)
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //# MARK: - settingBudget
    @IBAction func settingBudget(_ sender: UIButton) {
        Singleton.sharedInstance.setBudget(aBudget: self.budget)
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

// Extension to the table view
extension TableController: UITableViewDelegate, UITableViewDataSource {
    //# MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.clear
        return Singleton.sharedInstance.arrayOfItems.count
    }
    
    //# MARK: - tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel!.text = String(format: "$%.2f", Singleton.sharedInstance.arrayOfItems[indexPath.row])
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        
        return cell
    }
    
    //# MARK: - tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Singleton.sharedInstance.arrayOfItems.remove(at: indexPath.row)
            Singleton.sharedInstance.saveArray()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

// Extension to the picker
extension TableController: UIPickerViewDelegate, UIPickerViewDataSource {
    //# MARK: - pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //# MARK: - pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    //# MARK: - pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    //# MARK: - pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.budget = Int(self.data[row])!
    }
    
    //# MARK: - pickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = data[row]
        pickerLabel.font = UIFont(name: "Bradley Hand", size: 30)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}
