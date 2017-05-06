//
//  PayPalVC.swift
//  CleverDiner
//
//  Created by admin on 5/5/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class PayPalVC: UIViewController, PayPalPaymentDelegate, PayPalFuturePaymentDelegate {
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    lazy var buyBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Make Payment", for: .normal)
        btn.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        btn.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var futurePaymentBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Authorize Future Payment", for: .normal)
        btn.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        btn.addTarget(self, action: #selector(authorizeFuturePaymentsAction), for: .touchUpInside)
        return btn
    }()

    var paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Chose your payment option below"
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let paymentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Screen2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var payPalConfig = PayPalConfiguration() // default
    var resultText = "" // empty

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Paypal Payment Test"
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "The Clever Diner LLC"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both;
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }

    func buyAction() {
        // Remove our last completed payment, just for demo purposes.
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
        
        let items = [item1, item2, item3]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            self.resultText = completedPayment.description
        })
    }
    
    // MARK: Future Payments
    
    func authorizeFuturePaymentsAction() {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        print("PayPal Future Payment Authorization Canceled")
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
        print("PayPal Future Payment Authorization Success!")
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = futurePaymentAuthorization.description
        })
    }
    
    func setupViews() {
        
        view.addSubview(paymentImage)
        view.addSubview(paymentLabel)
        view.addSubview(buyBtn)
        view.addSubview(futurePaymentBtn)
        
        paymentImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        paymentImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
        paymentImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paymentImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        paymentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paymentLabel.topAnchor.constraint(equalTo: paymentImage.bottomAnchor, constant: 20).isActive = true
        paymentLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        paymentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        buyBtn.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 5).isActive = true
        buyBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buyBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buyBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        futurePaymentBtn.topAnchor.constraint(equalTo: buyBtn.bottomAnchor, constant: 10).isActive = true
        futurePaymentBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        futurePaymentBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        futurePaymentBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true

    }
}
