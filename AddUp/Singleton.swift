//=================================
import UIKit
//=================================
class Singleton {
    //# MARK: - Properties
    var arrayOfItems: [Float] = []
    let defaults = UserDefaults.standard
    var theBudget: Int = 0
    
    //# MARK: - sharedInstance
    static let sharedInstance = Singleton()
    
    //# MARK: - Constructor method
    init() {
        if let theArray = defaults.object(forKey: "theArray") {
            self.arrayOfItems = theArray as! [Float]
        } else {
            defaults.set(self.arrayOfItems, forKey: "theArray")
        }
        
        if let budget = defaults.object(forKey: "budget") {
            self.theBudget = budget as! Int
        } else {
            defaults.set(theBudget, forKey: "budget")
        }
    }
    
    //# MARK: - addToArray
    func addToArray(theNumber: Float) {
        self.arrayOfItems.append(theNumber)
        defaults.set(self.arrayOfItems, forKey: "theArray")
    }
    
    //# MARK: - addToArray
    func saveArray() {
        defaults.set(self.arrayOfItems, forKey: "theArray")
    }
    
    //# MARK: - emptyArray
    func emptyArray() {
        self.arrayOfItems = []
        defaults.set(self.arrayOfItems, forKey: "theArray")
    }
    
    //# MARK: - setBudget
    func setBudget(aBudget: Int) {
        self.theBudget = aBudget
        defaults.set(self.theBudget, forKey: "budget")
    }
}
//=================================
