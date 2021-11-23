////
////  Particle.swift
////  Fetch - Remastered
////
////  Created by Brian Masse on 9/21/21.
////  Copyright © 2021 Brian Masse. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
//class CurrentParticle: SKEmitterNode {
//
////    var type: Particle
//
//
////    func defineTextureAndSize() {
////
////    }
////
//    class func fromFile(file : String) -> CurrentParticle? {
////        guard let path = Bundle.main.path(forResource: file, ofType: "sks") else { return nil }
////        let data = try! NSData(contentsOfFile: path, options: .dataReadingMapped ) as Data
////
////        print(data)
////
////        do {
////            let archiver = try NSKeyedUnarchiver(forReadingFrom: data)
////
////            archiver.setClass(CurrentParticle.self, forClassName: "SKEmitterNode")
////
////            print("data, retrieved, class set")
////
////            guard let initializedClass = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? CurrentParticle else { return nil}
////
////            print("Emitter Node initialized")
////            guard let test = initializedClass as? CurrentParticle else { return nil}
////
////            //other setup is done here
////
////            return test
////        }
////        catch { print(error); return nil }
////    }
//
//        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
//            var fileData = try! NSData(contentsOfFile: path, options: .dataReadingMapped)
//
//            print("file data found")
//
//            var archiver = try! NSKeyedUnarchiver(forReadingFrom: fileData as Data)
//
////            archiver.setClass(CurrentParticle.self, forClassName: "SKEmitterNode")
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "CurrentParticle")
//
//            print(archiver)
//
//            let node = archiver.decodeArrayOfObjects(ofClass: CurrentParticle.self, forKey: NSKeyedArchiveRootObjectKey)
////            let node = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
//
////            archiver.decode
//
//            print(node)
//            archiver.finishDecoding()
//
//               return nil
//           } else {
//               return nil
//           }
//    }
//}
//
//struct Particle: gameObject {
//
//    let id: String
//
//    let cost: Int
//    let skin: String
//    let UIPreview: UIImage?
//
//    var isUnlocked = false
//    var isCurrent = false
//
//    enum CodableKeys: String, CodingKey {
//        case isCurrent
//        case isUnlocked
//    }
//
//    init(skin: String, cost: Int) {
//        self.skin = skin
//        self.cost = cost
//
//        id = skin + "ball"
//
//        self.UIPreview = UIImage()
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var values = encoder.container(keyedBy: CodableKeys.self)
//        try values.encode(isCurrent, forKey: .isCurrent)
//        try values.encode(isUnlocked, forKey: .isUnlocked)
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodableKeys.self)
//
//        isCurrent = try values.decode(Bool.self, forKey: .isCurrent)
//        isUnlocked = try values.decode(Bool.self, forKey: .isUnlocked)
//
//        id = ""; UIPreview = UIImage(); cost = 0; skin = ""
//    }
//}
