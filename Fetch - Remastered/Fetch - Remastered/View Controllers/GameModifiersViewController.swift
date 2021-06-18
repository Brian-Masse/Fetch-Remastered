//
//  GameModifiersViewController.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/31/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import SwiftUI

class GameModifiersViewController: UIViewController {
    
    let Title = UILabel()
    let Title2 = UILabel()
    let Title3 = UILabel()
    let Title4 = UILabel()
    let costLabel = UILabel()
    let costLabel2 = UILabel()
    let costLabel3 = UILabel()
    
    let throwUpgrade = UIButton()
    let moneyUpgrade = UIButton()
    let aroUpgrade = UIButton()
    let settings = UIButton()
    
    let mickey = UIButton()
    let tennisBall = UIButton()
    let rubberBall = UIButton()
    let discoBall = UIButton()
    let footBall = UIButton()
    let baseBall = UIButton()
    let basketBall = UIButton()
    let earth = UIButton()
    let disk = UIButton()
    let orange = UIButton()
    let apple = UIButton()
    let lemon = UIButton()
    let beach = UIButton()
    let death = UIButton()
    let puffer = UIButton()
    let spike = UIButton()
    let clock = UIButton()
    let saturn = UIButton()
    let moon = UIButton()
    let air = UIButton()
    let rubix = UIButton()
    let bull = UIButton()
    let poodle = UIButton()
    let black = UIButton()
    let dal = UIButton()
    let hound = UIButton()
    let fox = UIButton()
    let bot = UIButton()
    let bud = UIButton()
    let space = UIButton()
    
    var mickeyRect =  CGRect()
    var tennisBallRect =  CGRect()
    var rubberBallRect =  CGRect()
    var discoBallRect =  CGRect()
    var footBallRect =  CGRect()
    var baseBallRect =  CGRect()
    var basketBallRect =  CGRect()
    var earthRect =  CGRect()
    var diskRect =  CGRect()
    var orangeRect =  CGRect()
    var appleRect =  CGRect()
    var lemonRect =  CGRect()
    var beachRect =  CGRect()
    var deathRect =  CGRect()
    var pufferRect =  CGRect()
    var spikeRect =  CGRect()
    var clockRect =  CGRect()
    var saturnRect =  CGRect()
    var moonRect =  CGRect()
    var airRect =  CGRect()
    var rubixRect =  CGRect()
    var bullRect =  CGRect()
    var poodleRect =  CGRect()
    var blackRect =  CGRect()
    var dalRect =  CGRect()
    var houndRect =  CGRect()
    var foxRect =  CGRect()
    var botRect =  CGRect()
    var budRect =  CGRect()
    var spaceRect =  CGRect()


    let armDay = UIImageView()
    let dynamicBall = UIImageView()
    let goldMagnet = UIImageView()
    let goldLabel = UIImageView()
    let settingsImage = UIImageView()
    let mickeyImage = UIImageView()
    let tennisImage = UIImageView()
    let rubberImage = UIImageView()
    let discoImage = UIImageView()
    let footImage = UIImageView()
    let baseImage = UIImageView()
    let basketImage = UIImageView()
    let earthImage = UIImageView()
    let diskImage = UIImageView()
    let orangeImage = UIImageView()
    let appleImage = UIImageView()
    let lemonImage = UIImageView()
    let beachImage = UIImageView()
    let deathImage = UIImageView()
    let pufferImage = UIImageView()
    let spikeImage = UIImageView()
    let clockImage = UIImageView()
    let saturnImage = UIImageView()
    let moonImage = UIImageView()
    let airImage = UIImageView()
    let rubixImage = UIImageView()
    let bullImage = UIImageView()
    let poodleImage = UIImageView()
    let blackImage = UIImageView()
    let dalImage = UIImageView()
    let houndImage = UIImageView()
    let foxImage = UIImageView()
    let botImage = UIImageView()
    let budImage = UIImageView()
    let spaceImage = UIImageView()

    
    var micketLock = true
    var tennisBallLock = true
    var rubberBallLock = false
    var discoBallLock = false
    var footBallLock = false
    var baseBallLock = false
    var basketBallLock = false
    var earthLock = false
    var diskLock = false
    var orangeLock = false
    var appleLock = false
    var lemonLock = false
    var beachLock = false
    var deathLock = false
    var pufferLock = false
    var spikeLock = false
    var clockLock = false
    var saturnLock = false
    var moonLock = false
    var airLock = false
    var rubixLock = false
    
    var bullLock = false
    var poodleLock = false
    var blackLock = false
    var dalLock = false
    var houndLock = false
    var foxLock = false
    var botLock = false
    var budLock = false
    var spaceLock = false
    
    
    enum keys: String {
        case throwPressed = "numberOfThrowUpgrades"
        case throwCost = "CostOfThrow"
        case moneyPressed = "numberOfMoneyUpgrades"
        case moneyCost = "CostOfMoney"
        case aroPressed = "numberOfAroUpgrades"
        case aroCost = "CostOfAro"
        case rubberBallLock = "rubberBallLock"
        case discoBallLock = "discoBallLock"
        case footBallLock = "footBallLock"
        case baseBallLock = "baseBallLock"
        case basketBallLock = "basketBallLock"
        case earthLock = "earthLock"
        case diskLock = "diskLock"
        case orangeLock = "orangeLock"
        case appleLock = "appleLock"
        case lemonLock = "lemonLock"
        case beachLock = "beachLock"
        case deathLock = "deathLock"
        case pufferLock = "pufferLock"
        case spikeLock = "spikeLock"
        case clockLock = "clockLock"
        case saturnLock = "saturnLock"
        case moonLock = "moonLock"
        case airLock = "airLock"
        case rubixLock = "rubixLock"
        
        case mickeyLock = "MickeyLock"
        case bullLock = "bullLock"
        case poodleLock = "poodleLock"
        case blackLock = "blackLock"
        case dalLock = "dalLock"
        case houndLock = "houndLock"
        case foxLock = "foxLock"
        case botLock = "botLock"
        case budLock = "budLock"
        case spaceLock = "spaceLock"
    }
    
    var armDayRect = CGRect()
    var dynamicBallRect = CGRect()
    var goldMagnetRect = CGRect()
    var settingsRect = CGRect()
    var titleRect =  CGRect()
    var titelRect2 = CGRect()
    var titelRect3 = CGRect()
    var titelRect4 = CGRect()

    var costs = Array([CGFloat(2), CGFloat(30), CGFloat(100)])
    var timesPressed = Array([0, 0, 0])
    var ballUnlocks = Array([Bool()])
    var dogUnlocks = Array([Bool()])
    // 0-throwUpgardes, 1-moneyUpgrades, 2-aeroUpgrades
    // 0-throwUpgrades, 1-moneyUpgrades, 2-aeroUpgrades
    
    struct testView: View {
        var body: some View {
            Text("funny")
        }
    }
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 1500)
    
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
    
    lazy var background = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: containerView.bounds.height))
    let hardYellow = UIColor(red: 1, green: 213 / 255, blue: 79 / 255, alpha: 1)
    let lightGrey = UIColor(red: 214 / 255, green: 214 / 255, blue: 214 / 255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        setup()
    }
    
    func updateCosts() {
        
        costLabel.text = "Cost: \(Int(costs[0]))"
        costLabel2.text = "Cost: \(Int(costs[2]))"
        costLabel3.text = "Cost: \(Int(costs[1]))"
    }
    
    func updateImages() {
        updateIcons(locked: rubberBallLock, starter: "Rubber", image: rubberImage)
        updateIcons(locked: discoBallLock, starter: "Disco", image: discoImage)
        updateIcons(locked: footBallLock, starter: "Foot", image: footImage)
        updateIcons(locked: baseBallLock, starter: "Base", image: baseImage)
        updateIcons(locked: basketBallLock, starter: "Basket", image: basketImage)
        updateIcons(locked: earthLock, starter: "Earth", image: earthImage)
        updateIcons(locked: diskLock, starter: "Disk", image: diskImage)
        updateIcons(locked: orangeLock, starter: "Orange", image: orangeImage)
        updateIcons(locked: appleLock, starter: "Apple", image: appleImage)
        updateIcons(locked: lemonLock, starter: "Lemon", image: lemonImage)
        updateIcons(locked: beachLock, starter: "Beach", image: beachImage)
        updateIcons(locked: deathLock, starter: "Death", image: deathImage)
        updateIcons(locked: pufferLock, starter: "Puffer", image: pufferImage)
        updateIcons(locked: spikeLock, starter: "Spike", image: spikeImage)
        updateIcons(locked: clockLock, starter: "Clock", image: clockImage)
        updateIcons(locked: saturnLock, starter: "Saturn", image: saturnImage)
        updateIcons(locked: moonLock, starter: "Moon", image: moonImage)
        updateIcons(locked: airLock, starter: "Air", image: airImage)
        updateIcons(locked: rubixLock, starter: "Rubix", image: rubixImage)
        
        updateIcons(locked: bullLock, starter: "Bull", image: bullImage)
        updateIcons(locked: poodleLock, starter: "Poodle", image: poodleImage)
        updateIcons(locked: blackLock, starter: "Black", image: blackImage)
        updateIcons(locked: dalLock, starter: "Dal", image: dalImage)
        updateIcons(locked: houndLock, starter: "Hound", image: houndImage)
        updateIcons(locked: foxLock, starter: "Fox", image: foxImage)
        updateIcons(locked: botLock, starter: "Bot", image: botImage)
        updateIcons(locked: budLock, starter: "Bud", image: budImage)
        updateIcons(locked: spaceLock, starter: "Space", image: spaceImage)
        
    }
    
    func updateIcons(locked: Bool, starter: String, image: UIImageView) {
        if !locked {
            image.image = UIImage(named: "\(starter)Locked")
        } else {
            image.image = UIImage(named: "\(starter)Icon")
        }
    }
    
    func checkPreviousPurchases(Index: Int, pressedKey: String, costsKey: String) {
        let numberOfPresses = defaults.integer(forKey: pressedKey)
        if numberOfPresses > 0 {
            timesPressed[Index] = numberOfPresses
        }
        let cost = defaults.integer(forKey: costsKey)
        if cost > 0 {
            costs[Index] = CGFloat(cost)
        }
    }
    
    func setPreviousUnlocks() {
        rubberBallLock = checkPreviousUnlocks(lock: rubberBallLock, key: keys.rubberBallLock.rawValue, dog: false)
        discoBallLock = checkPreviousUnlocks(lock: discoBallLock, key: keys.discoBallLock.rawValue, dog: false)
        footBallLock = checkPreviousUnlocks(lock: footBallLock, key: keys.footBallLock.rawValue, dog: false)
        baseBallLock = checkPreviousUnlocks(lock: baseBallLock, key: keys.baseBallLock.rawValue, dog: false)
        basketBallLock = checkPreviousUnlocks(lock: basketBallLock, key: keys.basketBallLock.rawValue, dog: false)
        earthLock = checkPreviousUnlocks(lock: earthLock, key: keys.earthLock.rawValue, dog: false)
        diskLock = checkPreviousUnlocks(lock: diskLock, key: keys.diskLock.rawValue, dog: false)
        orangeLock = checkPreviousUnlocks(lock: orangeLock, key: keys.orangeLock.rawValue, dog: false)
        appleLock = checkPreviousUnlocks(lock: appleLock, key: keys.appleLock.rawValue, dog: false)
        lemonLock = checkPreviousUnlocks(lock: lemonLock, key: keys.lemonLock.rawValue, dog: false)
        beachLock = checkPreviousUnlocks(lock: beachLock, key: keys.beachLock.rawValue, dog: false)
        deathLock = checkPreviousUnlocks(lock: deathLock, key: keys.deathLock.rawValue, dog: false)
        pufferLock = checkPreviousUnlocks(lock: pufferLock, key: keys.pufferLock.rawValue, dog: false)
        spikeLock = checkPreviousUnlocks(lock: spikeLock, key: keys.spikeLock.rawValue, dog: false)
        clockLock = checkPreviousUnlocks(lock: clockLock, key: keys.clockLock.rawValue, dog: false)
        saturnLock = checkPreviousUnlocks(lock: saturnLock, key: keys.saturnLock.rawValue, dog: false)
        moonLock = checkPreviousUnlocks(lock: moonLock, key: keys.moonLock.rawValue, dog: false)
        airLock = checkPreviousUnlocks(lock: airLock, key: keys.airLock.rawValue, dog: false)
        rubixLock = checkPreviousUnlocks(lock: rubixLock, key: keys.rubixLock.rawValue, dog: false)
        
        bullLock = checkPreviousUnlocks(lock: bullLock, key: keys.bullLock.rawValue, dog: true)
        poodleLock = checkPreviousUnlocks(lock: poodleLock, key: keys.poodleLock.rawValue, dog: true)
        blackLock = checkPreviousUnlocks(lock: blackLock, key: keys.blackLock.rawValue, dog: true)
        dalLock = checkPreviousUnlocks(lock: dalLock, key: keys.dalLock.rawValue, dog: true)
        houndLock = checkPreviousUnlocks(lock: houndLock, key: keys.houndLock.rawValue, dog: true)
        foxLock = checkPreviousUnlocks(lock: foxLock, key: keys.foxLock.rawValue, dog: true)
        botLock = checkPreviousUnlocks(lock: botLock, key: keys.botLock.rawValue, dog: true)
        budLock = checkPreviousUnlocks(lock: budLock, key: keys.budLock.rawValue, dog: true)
        spaceLock = checkPreviousUnlocks(lock: spaceLock, key: keys.spaceLock.rawValue, dog: true)
        
        ProfileViewController().checkUnlocks(tempArray: dogUnlocks, dog: true)
        ProfileViewController().checkUnlocks(tempArray: ballUnlocks, dog: false)
    }
    
    func checkPreviousUnlocks(lock: Bool, key: String, dog: Bool) -> Bool{
        var newLock = lock
        let savedLock = defaults.bool(forKey: key)
        if savedLock {
            newLock = savedLock
        }
        if newLock && dog{
            dogUnlocks.append(true)
        } else if newLock{
            ballUnlocks.append(true)
        }
        return(newLock)
        
    }
    
    func savePreviousPurchases() {
        defaults.set(timesPressed[0], forKey: keys.throwPressed.rawValue)
        defaults.set(costs[0], forKey: keys.throwCost.rawValue)
        
        defaults.set(timesPressed[1], forKey: keys.moneyPressed.rawValue)
        defaults.set(costs[1], forKey: keys.moneyCost.rawValue)
        
        defaults.set(timesPressed[2], forKey: keys.aroPressed.rawValue)
        defaults.set(costs[2], forKey: keys.aroCost.rawValue)
    }
    
    func setup() {
        
        background.image = UIImage(named: "ModifiersBackground")
        containerView.addSubview(background)
        
        dogUnlocks = Array([Bool()])
        ballUnlocks = Array([Bool()])
        setupRects()
        setupButtonsInitalizers()
    
        checkPreviousPurchases(Index: 0, pressedKey: keys.throwPressed.rawValue, costsKey: keys.throwCost.rawValue)
        checkPreviousPurchases(Index: 1, pressedKey: keys.moneyPressed.rawValue, costsKey: keys.moneyCost.rawValue)
        checkPreviousPurchases(Index: 2, pressedKey: keys.aroPressed.rawValue, costsKey: keys.aroCost.rawValue)
        
        setPreviousUnlocks()
        updateCosts()
        
        createText(text: Title, messgae: "Game Modifiers", color: lightGrey, fontSize: globalScene.width(c: 35), rect: titleRect)
        createText(text: Title2, messgae: "Shop", color: lightGrey, fontSize: globalScene.width(c: 35), rect:
        titelRect2)
        createText(text: Title3, messgae: "Cosmetics Shop", color: lightGrey, fontSize: globalScene.width(c: 30), rect: titelRect3)
        createText(text: Title4, messgae: "Dog Skins:", color: lightGrey, fontSize: globalScene.width(c: 30), rect: titelRect4)
        
        updateImages()
    }
    
    func setupButtons(button: UIButton, image: UIImage, action: Selector, rect: CGRect, name: String, label: Bool, message: String, text: UILabel, imageView: UIImageView) {
//        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)

        containerView.addSubview(button)
        setupButtonConstraints(button: button, rect: rect)
        
        createImage(image: imageView, bC: rect, imageName: name, offset: 0, offset2: 0, override: false, size: CGSize(width: 0, height: 0), text: false, label: costLabel, message: "")
        
        if label {
            createImage(image: goldLabel, bC: rect, imageName: "GoldLabel", offset: globalScene.width(c: -50), offset2: globalScene.width(c:45), override: true, size: CGSize(width: globalScene.width(c:300), height: globalScene.width(c:45)), text: true, label: text, message: message)
        }
    }
    
    func setupButtonConstraints(button: UIButton, rect: CGRect) {
        
        let yPos = -containerView.bounds.height / 2 + (rect.midY - (rect.height / 2)) + globalScene.width(c: 50)
        let leadingNum = rect.midX - (rect.width / 2)
        let trailingNum = globalScene.frame.width - (rect.midX + (rect.width / 2))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingNum).isActive = true
        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -trailingNum).isActive = true
        button.heightAnchor.constraint(equalToConstant: rect.height).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: yPos).isActive = true
            
    }
    
    func createImage(image: UIImageView, bC: CGRect, imageName: String, offset: CGFloat, offset2: CGFloat, override: Bool, size: CGSize, text: Bool, label: UILabel, message: String) {
        var y = bC.midY - (bC.height / 2)
        var width = bC.width
        var height = bC.height
        if override {
            width = size.width
            height = size.height
        }
        y -= globalScene.width(c: 10) - offset
        let tempRect = CGRect(x: bC.minX + offset2, y: y, width: width, height: height)
        if image != goldLabel {
            image.frame = tempRect
            image.image = UIImage(named: imageName)
            containerView.addSubview(image)
        }else{
            let tempImage = UIImageView(frame: tempRect)
            tempImage.image = UIImage(named: imageName)
            containerView.addSubview(tempImage)
        }
        if text {
            createText(text: label, messgae: message, color: hardYellow, fontSize: globalScene.width(c: 25), rect: tempRect)
        }
    }
        
    func createText(text: UILabel, messgae: String, color: UIColor, fontSize: CGFloat, rect: CGRect) {
        let tempRect = CGRect(x: rect.minX + globalScene.width(c: 20), y: rect.minY, width: rect.width, height: rect.height)
        text.frame = tempRect
        text.text = messgae
        text.textColor = color
        text.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        text.font = UIFont(name: "Pixel Emulator", size: fontSize)
        containerView.addSubview(text)
        
    }

    
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(alert: UIAlertAction!) in print("dismiss")}))
        present(alert, animated: true, completion: nil)
    }
    
    func upgradePrice(initCost: CGFloat, scaler: CGFloat, Index: Int) {
        let x = timesPressed[Index]
        var cost = CGFloat(x * x) * scaler
        cost += initCost
        costs[Index] = CGFloat(Int(cost))
        savePreviousPurchases()
        updateCosts()
    }
    
    func upgradeButtonPressed(costIndex: Int, changed: CGFloat, changer: CGFloat, cap: Bool, capData: CGFloat, title: String, message: String, initCost: CGFloat, scaler: CGFloat) -> CGFloat {
        var changed = changed
        if globalScene.goldCount >= costs[costIndex] {
            changed += changer
            if changed < capData && cap{
                changed = capData
                showAlert(title: title, message: message)
            }
            else {
                globalScene.saveModifier()
                globalScene.goldCount -= costs[costIndex]
                timesPressed[costIndex] += 1
                upgradePrice(initCost: initCost, scaler: scaler, Index: costIndex)
            }
        }
        else {
            showAlert(title: "You do not have enough gold", message: "Try playing with your dog more before spending money :)")
        }
        return changed
    }
    
    func switchSkin(skin: String, key: String, dog: Bool) {
        if !dog {
            globalScene.ballSkin = skin
            globalScene.setupTextureBallAtlases()
            globalScene.staticBallTexture()
        } else {
            globalScene.dogSkin = skin
            globalScene.setupTextureDogAtlases()
            globalScene.setupTextureDogSitAtlases()
        }
        globalScene.saveData()
        defaults.set(true, forKey: key)
    }
    
    func ballTapped(cost: CGFloat, skin: String, check: Bool, key: String, dog: Bool) -> Bool {
        var locked = check
        if !check {
            if globalScene.goldCount > cost {
                locked = true
                globalScene.goldCount -= cost
                switchSkin(skin: skin, key: key, dog: dog)
            }else {
                showAlert(title: "You do not have enough gold", message: "Try playing with your dog more before spending money :)")
            }
        }
        else {
            switchSkin(skin: skin, key: key, dog: dog)
        }
        return(locked)
    }
    
    @objc func moneyUpgradePressed() {
        globalScene.playBeepSound()
        globalScene.Probability = upgradeButtonPressed(costIndex: 1, changed: globalScene.Probability, changer: -2, cap: true, capData: 1, title: "Maxed Out", message: "Your dog is already the very best at finding gold!", initCost: 30, scaler: 1)
        globalScene.saveModifier()
        globalScene.saveData()
    }
    
    @objc func throwUpgradePressed() {
        globalScene.playBeepSound()
        throwModifier = upgradeButtonPressed(costIndex: 0, changed: throwModifier, changer: 500, cap: false, capData: 0, title: "", message: "", initCost: 2, scaler: 0.2)
        globalScene.saveModifier()
    }
    
    @objc func aroUpgradePressed() {
        globalScene.playBeepSound()
        globalScene.updateBallDampening()
        friction = upgradeButtonPressed(costIndex: 2, changed: friction, changer: -0.01, cap: true, capData: 0.5, title: "Maxed Out", message: "You already have the most aerodynamic ball!", initCost: 100, scaler: 15)
        globalScene.saveModifier()
        globalScene.saveData()
    }
    
    
    @objc func settingsTaped() {
        globalScene.playBeepSound()
        present(SettingsViewController(), animated: true, completion: nil)
    }
    
    @objc func tennisBallPressed() {
        globalScene.playBeepSound()
        globalScene.ballSkin = "Tennis"
        globalScene.setupTextureBallAtlases()
        globalScene.staticBallTexture()
        globalScene.saveData()
    }
    @objc func mickeyPressed() {
        globalScene.playBeepSound()
        rubberBallLock = ballTapped(cost: 0, skin: "Mickey", check: true, key: keys.mickeyLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func rubberTapped() {
        globalScene.playBeepSound()
        rubberBallLock = ballTapped(cost: 100, skin: "Rubber", check: rubberBallLock, key: keys.rubberBallLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func discoTapped() {
        globalScene.playBeepSound()
        discoBallLock = ballTapped(cost: 100000, skin: "Disco", check: discoBallLock, key: keys.discoBallLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func footTapped() {
        globalScene.playBeepSound()
        footBallLock = ballTapped(cost: 1000, skin: "Foot", check: footBallLock, key: keys.footBallLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func baseTapped() {
        globalScene.playBeepSound()
        baseBallLock = ballTapped(cost: 500, skin: "Base", check: baseBallLock, key: keys.baseBallLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func basketTapped() {
        globalScene.playBeepSound()
        basketBallLock = ballTapped(cost: 10000, skin: "Basket", check: basketBallLock, key: keys.basketBallLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func earthTapped() {
        globalScene.playBeepSound()
        earthLock = ballTapped(cost: 1000000, skin: "Earth", check: earthLock, key: keys.earthLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func diskTapped() {
        globalScene.playBeepSound()
        diskLock = ballTapped(cost: 100, skin: "Disk", check: diskLock, key: keys.diskLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func orangeTapped() {
        globalScene.playBeepSound()
        orangeLock = ballTapped(cost: 500, skin: "Orange", check: orangeLock, key: keys.orangeLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func appleTapped() {
        globalScene.playBeepSound()
        appleLock = ballTapped(cost: 100000, skin: "Apple", check: appleLock, key: keys.appleLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func lemonTapped() {
        globalScene.playBeepSound()
        lemonLock = ballTapped(cost: 500, skin: "Lemon", check: lemonLock, key: keys.lemonLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func beachTapped() {
        globalScene.playBeepSound()
        beachLock = ballTapped(cost: 700, skin: "Beach", check: beachLock, key: keys.beachLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func deathTapped() {
        globalScene.playBeepSound()
        deathLock = ballTapped(cost: 700, skin: "Death", check: deathLock, key: keys.deathLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func pufferTapped() {
        globalScene.playBeepSound()
        pufferLock = ballTapped(cost: 1000000, skin: "Puffer", check: pufferLock, key: keys.pufferLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func spikeTapped() {
        spikeLock = ballTapped(cost: 1000, skin: "Spike", check: spikeLock, key: keys.spikeLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func clockTapped() {
        globalScene.playBeepSound()
        clockLock = ballTapped(cost: 50, skin: "Clock", check: clockLock, key: keys.clockLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func saturnTapped() {
        globalScene.playBeepSound()
        saturnLock = ballTapped(cost: 100000, skin: "Saturn", check: saturnLock, key: keys.saturnLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func moonTapped() {
        globalScene.playBeepSound()
           moonLock = ballTapped(cost: 1000, skin: "Moon", check: moonLock, key: keys.moonLock.rawValue, dog: false)
           updateImages()
       }
    
    @objc func airTapped() {
        globalScene.playBeepSound()
        airLock = ballTapped(cost: 3000000, skin: "Air", check: airLock, key: keys.airLock.rawValue, dog: false)
        updateImages()
    }
    
    @objc func rubixTapped() {
        globalScene.playBeepSound()
           rubixLock = ballTapped(cost: 1000000, skin: "Rubix", check: rubixLock, key: keys.rubixLock.rawValue, dog: false)
           updateImages()
       }
    
    @objc func bullTapped() {
        globalScene.playBeepSound()
           bullLock = ballTapped(cost: 10000, skin: "Bull", check: bullLock, key: keys.bullLock.rawValue, dog: true)
           updateImages()
       }
    
    @objc func poodleTapped() {
        globalScene.playBeepSound()
        poodleLock = ballTapped(cost: 90000, skin: "Poodle", check: poodleLock, key: keys.poodleLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func blackTapped() {
        globalScene.playBeepSound()
        blackLock = ballTapped(cost: 400000, skin: "Black", check: blackLock, key: keys.blackLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func dalTapped() {
        globalScene.playBeepSound()
        dalLock = ballTapped(cost: 1000000, skin: "Dal", check: dalLock, key: keys.dalLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func houndTapped() {
        globalScene.playBeepSound()
        houndLock = ballTapped(cost: 1000000, skin: "Hound", check: houndLock, key: keys.houndLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func foxTapped() {
        globalScene.playBeepSound()
        foxLock = ballTapped(cost: 10000, skin: "Fox", check: foxLock, key: keys.foxLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func botTapped() {
        globalScene.playBeepSound()
        botLock = ballTapped(cost: 3000000, skin: "Bot", check: botLock, key: keys.botLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func budTapped() {
        globalScene.playBeepSound()
        budLock = ballTapped(cost: 200, skin: "Bud", check: budLock, key: keys.budLock.rawValue, dog: true)
        updateImages()
    }
    
    @objc func spaceTapped() {
        globalScene.playBeepSound()
        spaceLock = ballTapped(cost: 100, skin: "Space", check: spaceLock, key: keys.spaceLock.rawValue, dog: true)
        updateImages()
    }
}
