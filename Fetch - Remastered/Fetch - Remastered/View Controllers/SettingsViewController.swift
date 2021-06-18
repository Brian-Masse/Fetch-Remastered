//
//  SettingsViewController.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/6/20.
//  Copyright © 2020 Brian Masse. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let cloudToggle = UIButton()
    let soundToggle = UIButton()
    let replay = UIButton()
    let header = UILabel(frame: CGRect(x: globalScene.width(c: 24), y: 0, width: frame.width, height: globalScene.width(c: 100)))
    
    let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    let cloudToggleImage = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 164 - 91.5), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let soundToggleImage = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 298 - 91.5), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    let replayImage = UIImageView(frame: CGRect(x: globalScene.width(c: 12), y: globalScene.width(c: 432 - 91.5), width: globalScene.width(c: 390), height: globalScene.width(c: 122)))
    
    let customGrey = UIColor(red: 47 / 255, green: 115 / 255, blue: 143 / 255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .green
        
        setupImages()
        setupButtons(button: cloudToggle, image: UIImage(named: "Game Modifiers")!, action: #selector(cloudToggleTapped), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y: -view.bounds.height / 2 + globalScene.width(c: 164))
        setupButtons(button: soundToggle, image: UIImage(named: "Game Modifiers")!, action: #selector(soundToggleTapped), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y:   -view.bounds.height / 2 + globalScene.width(c: 298))
        setupButtons(button: replay, image: UIImage(named: "Game Modifiers")!, action: #selector(replayTapped), leading: globalScene.width(c: 12), trailing: globalScene.width(c: -12), height: globalScene.width(c: 122), y:   -view.bounds.height / 2 + globalScene.width(c: 432))
        createText(text: header, messgae: "Settings", color: customGrey, fontSize: globalScene.width(c: 30))
    }
    
    func setupImages() {
        backgroundImage.image = UIImage(named: "SettingsBackground")
        cloudToggleImage.image = UIImage(named: "SettingsBackground")
        soundToggleImage.image = UIImage(named: "SettingsBackground")
        replayImage.image = UIImage(named: "Replay")
        updateToggles(toggle: cloudToggleImage, check: globalScene.cloudsOff, starter: "CloudToggle")
        updateToggles(toggle: soundToggleImage, check: globalScene.soundOff, starter: "SoundToggle")
        view.addSubview(backgroundImage)
        view.addSubview(cloudToggleImage)
        view.addSubview(soundToggleImage)
        view.addSubview(replayImage)
    }
    
    func setupButtons(button: UIButton, image: UIImage, action: Selector, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
//            button.setImage(image, for: .normal)
            button.addTarget(self, action: action, for: .touchUpInside)
            
            view.addSubview(button)
            setupButtonConstraints(button: button, leading: leading, trailing: trailing, height: height, y: y)
        }
        
    func setupButtonConstraints(button: UIButton, leading: CGFloat, trailing: CGFloat, height: CGFloat, y: CGFloat) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y).isActive = true
                
    }
    
    func createText(text: UILabel, messgae: String, color: UIColor, fontSize: CGFloat) {
        text.text = messgae
        text.textColor = color
        text.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        text.font = UIFont(name: "Pixel Emulator", size: fontSize)
        view.addSubview(text)
        
    }
    
    func updateToggles(toggle: UIImageView, check: Bool, starter: String) {
        globalScene.playBeepSound()
        switch check {
        case true: toggle.image = UIImage(named:"\(starter)Off")
        case false: toggle.image = UIImage(named:"\(starter)On")
        }
    }
    
    @objc func cloudToggleTapped() {
        switch globalScene.cloudsOff {
        case true: globalScene.cloudsOff = false
        case false: globalScene.cloudsOff = true
        }
        globalScene.saveData()
        updateToggles(toggle: cloudToggleImage, check: globalScene.cloudsOff, starter: "CloudToggle")
    }
    
    @objc func soundToggleTapped() {
        switch globalScene.soundOff {
        case true: globalScene.soundOff = false
        case false: globalScene.soundOff = true
        }
        globalScene.saveData()
        updateToggles(toggle: soundToggleImage, check: globalScene.soundOff, starter: "SoundToggle")
    }
    
    @objc func replayTapped() {
        globalScene.playBeepSound()
        
        globalScene.tutorialComplete = false
        globalScene.saveData()
        globalScene.runTutorial()
    }
}
