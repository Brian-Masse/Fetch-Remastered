//
//  CosmeticsViewController.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/31/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import GoogleMobileAds
import UIKit
import StoreKit

class GoldViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, GADFullScreenContentDelegate {

    let smallGold = UIButton()
    let mediumGold = UIButton()
    let largeGold = UIButton()
    let extraLargeGold = UIButton()
    let doubleExtraLargeGold = UIButton()
    let ad = UIButton()
    
    var sG: SKProduct?
    var mG: SKProduct?
    var lG: SKProduct?
    var elG:  SKProduct?
    var delG: SKProduct?
    var currentProduct = ""
    
    
    var rewardedAd: GADRewardedAd?
    
    
    let smallGoldButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 315 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let mediumGoldButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 449 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let largeGoldButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 583 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let extralargeGoldButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 717 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let doubleExtralargeGoldButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 851 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let adButton = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 181 - 61), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let Title = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: 0, width: frame.width, height: globalScene.height(c: 125)))
    
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 300)
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.contentSize = contentViewSize
        view.frame = self.view.bounds
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        Setup()
        
    }
    
    lazy var background = UIImageView(frame: CGRect(x: 0, y: 0, width: contentViewSize.width, height: contentViewSize.height))
    let darkYellow = UIColor(red: 247 / 255, green: 182 / 255, blue: 48 / 255, alpha: 1)
    
    // MARK: load ads
    
    func loadAd(){
        print("ad requested to load")
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()) {
            (ad, error) in
          if let error = error {
            print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            return
          }
          print("Loading Succeeded")
          self.rewardedAd = ad
          self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    // MARK: Present ads
    func presentAd() {
        print("attemtpting to present ad")
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                print("ad completed")
                self.rewardGold(amount: 1000)
            }
        }else {
            print("ad failed to present")
        }
        self.loadAd()
    }
    
    func Setup() {
        containerView.backgroundColor = .yellow
        
        background.image = UIImage(named: "GoldBackground")
        containerView.addSubview(background)
    
        getProducts()
        loadAd()
        
        setupButtons(button: smallGold, image: UIImage(named: "Game Modifiers")!, action: #selector(sGPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 315))
        setupButtons(button: mediumGold, image: UIImage(named: "Game Modifiers")!, action: #selector(mGPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 449))
        setupButtons(button: largeGold, image: UIImage(named: "Game Modifiers")!, action: #selector(lGPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 583))
        setupButtons(button: extraLargeGold, image: UIImage(named: "Game Modifiers")!, action: #selector(elGPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 717))
        setupButtons(button: doubleExtraLargeGold, image: UIImage(named: "Game Modifiers")!, action: #selector(delGPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 851))
        setupButtons(button: ad, image: UIImage(named: "Game Modifiers")!, action: #selector(adPressed), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -contentViewSize.height / 2 + globalScene.width(c: 181))
        
        
        createText(text: Title, messgae: "Gold Shop", color: darkYellow, fontSize: globalScene.height(c: 40))
        
        smallGoldButton.image = UIImage(named: "SmallGold")
        mediumGoldButton.image = UIImage(named: "MediumGold")
        largeGoldButton.image = UIImage(named: "LargeGold")
        extralargeGoldButton.image = UIImage(named: "ExtraLargeGold")
        doubleExtralargeGoldButton.image = UIImage(named: "DoubleExtraLargeGold")
        adButton.image = UIImage(named: "adButtonGrey")
        containerView.addSubview(smallGoldButton)
        containerView.addSubview(mediumGoldButton)
        containerView.addSubview(largeGoldButton)
        containerView.addSubview(extralargeGoldButton)
        containerView.addSubview(doubleExtralargeGoldButton)
        containerView.addSubview(adButton)
    }
    
    func animatePurchase(amount: Int) {
        for i in 0...50 {
            globalScene.animateCoins(time: CGFloat(i) / CGFloat(20))
        }
        globalScene.addedGold = 0
        globalScene.goldCount += CGFloat(amount)
        globalScene.saveData()
        dismiss(animated: true, completion: nil)
    }
    
    func getProducts() {
        let request = SKProductsRequest(productIdentifiers: ["Brian.Masse.Fetch.Remastered.SmallGold",
                                                             "BrianMasse.FetchRemastered.MediumGold",
                                                             "BrianMasse.FetchRemastered.LargeGold",
                                                             "BrianMasse.FetchRemastered.ExtraLargeGold",
                                                             "BrianMasse.FetchRemastered.DoubleExtraLargeGold"])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            if product.price == 0.99 {
                sG = product
            }
            if product.price == 5.99 {
                mG = product
            }
            if product.price == 10.99 {
                lG = product
            }
            if product.price == 49.99 {
                elG = product
            }
            if product.price == 99.99 {
                delG = product
            }
            
        }
    }
    
    func rewardGold(amount: Int) {
        globalScene.playBeepSound()
        globalScene.goldCount += CGFloat(amount)
        globalScene.saveData()
        self.isModalInPresentation = false
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case.purchased:
                print("trasnaction completed")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                switch currentProduct {
                    case "sG": animatePurchase(amount: 10000)
                    case "mG": animatePurchase(amount: 50000)
                    case "lG": animatePurchase(amount: 100000)
                    case "elG": animatePurchase(amount: 500000)
                    case "delG": animatePurchase(amount: 1000000)
                    default: print("none")
                }
                
            case .failed, .deferred:
                print("transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
                
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    
    func setupButtons(button: UIButton, image: UIImage, action: Selector, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
//        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        containerView.addSubview(button)
        setupButtonConstraints(button: button, leading: leading, trailing: trailing, height: height, y: y)
    }
    
    func setupButtonConstraints(button: UIButton, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading).isActive = true
        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: y).isActive = true
            
    }
    
    func createText(text: UILabel, messgae: String, color: UIColor, fontSize: CGFloat) {
        text.text = messgae
        text.textColor = color
        text.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        text.font = UIFont(name: "Pixel Emulator", size: fontSize)
        containerView.addSubview(text)
        
    }
    
    func buy(product: SKProduct?) {
        globalScene.playBeepSound()
        self.isModalInPresentation = true
        guard let myProduct = product else{
            return
        }
        let payment = SKPayment(product: myProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    @objc func sGPressed() {
        buy(product: sG)
        currentProduct = "sG"
    }
    @objc func mGPressed() {
        buy(product: mG)
        currentProduct = "mG"
    }
    @objc func lGPressed() {
        buy(product: lG)
        currentProduct = "lG"
    }
    @objc func elGPressed() {
        buy(product: elG)
        currentProduct = "elG"
    }
    @objc func delGPressed() {
        buy(product: delG)
        currentProduct = "delG"
    }
    
    @objc func adPressed() {
        globalScene.playBeepSound()
        presentAd()
    }
    
    

}
