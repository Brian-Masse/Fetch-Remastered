////
////  GameViewController.swift
////  Fetch - Remastered
////
////  Created by Brian Masse on 7/30/20.
////  Copyright © 2020 Brian Masse. All rights reserved.
////
//
//import UIKit
//import SpriteKit
//import GameplayKit
//import StoreKit
//import GoogleMobileAds
//
//let globalModifiers = GameModifiersViewController()
//
//class GameViewController: UIViewController {
//
//    let gameModifier = UIButton()
//    let Gold = UIButton()
//    let profile = UIButton()
//    let returnBall = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//    }
//
//    func setup() {
//
////        print(self.view, "THIS IS THE VIEW RIGHT HERE")
////        PresentScene()
//        setupButtons(button: gameModifier, image: UIImage(named: "Profile")!, action: #selector(modifiersTapped), leading: globalScene.width(c: 280), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: globalFrame.height / 2 - globalScene.height(c: 100))
//        setupButtons(button: profile, image: UIImage(named: "Game Modifiers")!, action: #selector(profileTapped), leading: globalScene.width(c: 146), trailing: globalScene.width(c: -146), height: globalScene.width(c: 122), y: globalFrame.height / 2 - globalScene.height(c: 100))
//        setupButtons(button: Gold, image: UIImage(named: "Game Modifiers")!, action: #selector(GoldTapped), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -280), height: globalScene.width(c: 122), y: globalFrame.height / 2 - globalScene.height(c: 100))
//        setupButtons(button: returnBall, image: UIImage(named: "Game Modifiers")!, action: #selector(returnBallTapped), leading: globalScene.width(c: 100), trailing: globalScene.width(c: -100), height: globalScene.width(c: 75), y: globalScene.height(c: -150))
//    }
//
//    func PresentScene() {
//
//
//
//        if let view = self.view as! SKView? {
//            let scene = globalScene
//                scene.scaleMode = .aspectFill
//                view.presentScene(scene)
//
//                view.ignoresSiblingOrder = false
//                view.showsFPS = false
//                view.showsNodeCount = false
//                view.showsPhysics = false
//          }
//      }
//    func hideReturnButton() {
//        returnBall.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100000).isActive = true
//    }
//    func showReturnButton() {
//        returnBall.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: globalScene.width(c: 100)).isActive = true
//    }
//
//    func setupButtons(button: UIButton, image: UIImage, action: Selector, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
//
//
//        let newImage = image.resized(to: CGSize(width: 500, height: 500))
//
//
////        if let contextReference: CGContext = UIGraphicsGetCurrentContext(){
////            CGContextSetInterpolationQuality(contextReference, kCGInterpolationNone)
////        }
////        print("THIS IS A SUBVIEW", view.subviews)
//        button.setImage(newImage, for: .normal)
//
//
//        button.addTarget(self, action: action, for: .touchUpInside)
//
//        view.addSubview(button)
//        setupButtonConstraints(button: button, leading: leading, trailing: trailing, height: height, y: y)
//    }
//
//    func setupButtonConstraints(button: UIButton, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
//        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
//        button.heightAnchor.constraint(equalToConstant: height).isActive = true
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y).isActive = true
//
//    }
//
//    @objc func modifiersTapped() {
//        if !globalScene.throwing && globalScene.tutorialComplete || !globalScene.throwing && globalScene.currentSlide.name == "shops"{
//            present(GameModifiersViewController(), animated: true, completion: nil)
//            globalScene.playBeepSound()
//        }
//    }
//    @objc func profileTapped() {
//        if !globalScene.throwing && globalScene.tutorialComplete || !globalScene.throwing && globalScene.currentSlide.name == "shops"{
//            present(ProfileViewController(), animated: true, completion: nil)
//            globalScene.playBeepSound()
//        }
//
//    }
//    @objc func GoldTapped() {
//        print("yes")
//////        if !globalScene.throwing && globalScene.tutorialComplete || !globalScene.throwing && globalScene.currentSlide.name == "shops"{
////            present(TestViewController, animated: true, completion: nil)
//////            globalScene.playBeepSound()
//////        }
////
////        if let view = testTestView as? SKView {
////
////        }
//    }
//    @objc func returnBallTapped() {
//
//        if globalScene.dog.zRotation.rounded() == CGFloat(Double.pi).rounded(){
//            globalScene.returnBall()
//            globalScene.playBeepSound()
//        }
//    }
//}
//
//extension UIImage {
//    func resized(to size: CGSize) -> UIImage {
//        return UIGraphicsImageRenderer(size: size).image { _ in
//            draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
//}
//
