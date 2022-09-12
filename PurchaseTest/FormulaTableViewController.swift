//
//  FormulaTableViewController.swift
//  PurchaseTest
//
//  Created by Dias Karimov on 02.08.2022.
//

import UIKit
import StoreKit

class FormulaTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    
    
    let productID = "com.dias.PurchaseTest.premiumFormulas"
    
    var freeFormulas = [ "Density = Mass(kg)/ Volume(m^3)",
                         "Force(N) = Mass(kg) * Acceleration(m/s^2)",
                         "Impulse (Ns) = Change in Momentum"
    ]
    
    let premiumFormulas = [ "Power(W) = Work done(J) / Time(s)",
                            "Weight(N) = Mass(kg) * gravitation field strength",
                            "Work done(J) = Fornce(N) * Distance(m)"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumFormulas()
        }
    
    }
   

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return freeFormulas.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isPurchased() {
            return freeFormulas.count
        }
        return freeFormulas.count + 1

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        
        if indexPath.row < freeFormulas.count {
        cell.textLabel?.text = freeFormulas[indexPath.row]
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        // Configure the cell...
        }
        else {
            cell.textLabel?.text = "Get more formulas"
            cell.textLabel?.textColor = UIColor.orange
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == freeFormulas.count {
            buyPremiumFormulas()
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Purchase Method
    
    func buyPremiumFormulas() {
        if  SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                showPremiumFormulas()
                
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            } else if transaction.transactionState == .failed {
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("transaction failed: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                
                
                showPremiumFormulas()
                
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    func showPremiumFormulas() {
        UserDefaults.standard.set(true, forKey: productID)
        freeFormulas.append(contentsOf: premiumFormulas)
        tableView.reloadData()
    }
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        if purchaseStatus {
            return true
            print("Already purchased")
        } else {
            print("Never purchased")
            return false
        }
    }
 
    @IBAction func restoreButton(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}
