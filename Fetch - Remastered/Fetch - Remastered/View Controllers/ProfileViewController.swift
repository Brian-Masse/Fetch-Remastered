//
//  ProfileViewController.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 7/31/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import UIKit

var ballUnlocks = CGFloat(0.0)
var dogUnlocks = CGFloat(0)

class ProfileViewController: UIViewController {
    
//    let darkBlue = UIColor(red: 28 / 255, green: 37 / 255 , blue: 128 / 255, alpha: 1)
    let darkBlue = UIColor(red: 14 / 255, green: 0 / 255 , blue: 86 / 255, alpha: 1)
    
    var probability = "\(( 1 / globalScene.Probability) * 100)"
    var discoveredPerc = "\(globalScene.discoveredPerc)"

    
    let Title = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: 0, width: frame.width , height: globalScene.height(c: 100)))
    
    let CurrentGold = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 120), width: frame.width , height: globalScene.width(c: 50)))
    let CurrentGold2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 150), width: frame.width , height: globalScene.width(c: 50)))
    let mostGold = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 220), width: frame.width , height: globalScene.width(c: 50)))
     let mostGold2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 250), width: frame.width , height: globalScene.width(c: 50)))
    let farthestThrow = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 320), width: frame.width , height: globalScene.width(c: 50)))
    let farthestThrow2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 350), width: frame.width , height: globalScene.width(c: 50)))
    let strength = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 420), width: frame.width , height: globalScene.width(c: 50)))
    let strength2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 450), width: frame.width , height: globalScene.width(c: 50)))
    let goldChance = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 520), width: frame.width , height: globalScene.width(c: 50)))
    let goldChance2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 550), width: frame.width , height: globalScene.width(c: 50)))
    let goldChance3 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 580), width: frame.width , height: globalScene.width(c: 50)))
    let friction = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 650), width: frame.width , height: globalScene.width(c: 50)))
    let friction2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 680), width: frame.width , height: globalScene.width(c: 50)))
    let ballSkin = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 750), width: frame.width , height: globalScene.width(c: 50)))
    let ballSkin2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 780), width: frame.width , height: globalScene.width(c: 50)))
    let dogSkin = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 850), width: frame.width , height: globalScene.width(c: 50)))
    let dogSkin2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 880), width: frame.width , height: globalScene.width(c: 50)))
    let discovered = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 950), width: frame.width , height: globalScene.width(c: 50)))
    let discovered2 = UILabel(frame: CGRect(x: globalScene.width(c: 30), y: globalScene.width(c: 980), width: frame.width , height: globalScene.width(c: 50)))
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 400)
    
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
    
    lazy var background = UIImageView(frame: CGRect(x: 0, y: 0, width: contentViewSize.width, height: contentViewSize.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup() {
        
        background.image = UIImage(named: "ProfileBackground")
        containerView.addSubview(background)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)

        roundNumber()
        GameModifiersViewController().setPreviousUnlocks()
        
        let temp = (CGFloat((ballUnlocks / 20)) * 100)
        let temp2 = (CGFloat((dogUnlocks / 10)) * 100)
        
        
        createText(text: Title, messgae: "Profile", color: darkBlue, fontSize: globalScene.height(c: 50))
        createText(text: CurrentGold, messgae: "Current Gold:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: CurrentGold2, messgae: "\(Int(globalScene.goldCount))", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: mostGold, messgae: "Highest Gold:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: mostGold2, messgae: "\(Int(globalScene.mostGold))", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: farthestThrow, messgae: "Farthest Throw:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: farthestThrow2, messgae: "\(Int(globalScene.farthestThrow))", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: strength, messgae: "Strength:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: strength2, messgae: "\(Int(throwModifier - 3999))", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: goldChance, messgae: "Chance of Gold", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: goldChance2, messgae: "per Yard:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: goldChance3, messgae: "\(probability)%", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: friction, messgae: "Ball Friction:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: friction2, messgae: "\(friction)", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: ballSkin, messgae: "Balls Unlocked:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: ballSkin2, messgae: "\(Int(ballUnlocks))/\(20) (\(temp)%)", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: dogSkin, messgae: "Dogs Unlocked:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: dogSkin2, messgae: "\(Int(dogUnlocks))/\(10) (\(temp2)%)", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: discovered, messgae: "Map Discovered:", color: darkBlue, fontSize: globalScene.width(c: 30))
        createText(text: discovered2, messgae: "\(discoveredPerc)%", color: darkBlue, fontSize: globalScene.width(c: 30))
        containerView.backgroundColor = .blue
    }
    
    func checkUnlocks(tempArray: Array<Any>, dog: Bool) {
        if dog {
            dogUnlocks = CGFloat(tempArray.count)
        } else {
            ballUnlocks = CGFloat(tempArray.count)
        }
    }
    
    func roundNumber() {
        for _ in probability {
            
            if probability.count > 5 {
                probability.removeLast()
            }
        }
        for _ in discoveredPerc {
            if discoveredPerc.count > 7 {
                discoveredPerc.removeLast()
            }
        }
    }
    
    func createText(text: UILabel, messgae: String, color: UIColor, fontSize: CGFloat) {
        text.text = messgae
        text.textColor = color
        text.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        text.font = UIFont(name: "Pixel Emulator", size: fontSize)
        containerView.addSubview(text)
        
    }

}
