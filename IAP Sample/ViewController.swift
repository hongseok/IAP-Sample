//
//  ViewController.swift
//  IAP Sample
//
//  Created by PIVOT on 2016. 4. 20..
//  Copyright © 2016년 PIVOT. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate  {
    
    let productId = "SAMPLE_CONSUMABLE_1"

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    // MARK: - SKPaymentTransactionObserver
    internal func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch (transaction.transactionState) {
            case .Purchasing:
                print("Purchasing")
            case .Purchased:
                purchased(transaction)
            case .Failed:
                failed(transaction)
            case .Restored:
                restored(transaction)
            case .Deferred:
                print("Deferred")
            }
        }
    }
    
    private func purchased(transaction: SKPaymentTransaction) {
        let message = "Transaction ID : \(transaction.transactionIdentifier!)"
        alert("Purchased", message: message)
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        alert("Failed", message: "Purchase Failed")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        alert("Restored", message: "Purchase Restored")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    

    // MARK: - SKProductsRequestDelegate
    internal func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if let product = response.products.first {
            let currency = product.priceLocale.objectForKey(NSLocaleCurrencyCode)!
            let message = "Price : \(product.price)\nTitle : \(product.localizedTitle)\nDescription : \(product.localizedDescription)\nCurrency : \(currency)"
            alert("Retrieved Product Info", message: message)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func actionRetrieve(sender: AnyObject) {
        let productIdentifiers: Set<String> = [productId]
        let productRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    @IBAction func actionPurchase(sender: AnyObject) {
        let payment = SKMutablePayment()
        payment.productIdentifier = productId
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    
    // MARK: Alert
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.Alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

