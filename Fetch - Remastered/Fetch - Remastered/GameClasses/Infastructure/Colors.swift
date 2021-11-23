//
//  WidgetColorOptions.swift
//  Fetch - Remastered
//
//  Created by Brian Masse on 8/30/21.
//  Copyright © 2021 Brian Masse. All rights reserved.
//

import Foundation
import SwiftUI

struct Colors {
    
    static let darkShadow = Color(UIColor(red: 0 , green: 0, blue: 0, alpha: 1))
    static let lightShadow = Color(UIColor(red: 1 , green: 1, blue: 1, alpha: 0.22))
    static let darkGrey = Color(UIColor(red: 69 / 255, green: 69 / 255, blue: 69 / 255, alpha: 1))
    static let darkTextGrey = Color(UIColor(red: 31 / 255, green: 31 / 255, blue: 31 / 255, alpha: 1))

    static let goldLightColor = Color(UIColor(red: 256 / 255, green: 204 / 255, blue: 108 / 255, alpha: 1))
    static let goldShadow = Color(UIColor(red: 256 / 255, green: 100 / 255, blue: 92 / 255, alpha: 1))
    
    static let cosmeticsShadow = Color(UIColor(red: 247 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1))
    static let cosmeticsLighShadow = Color(UIColor(red: 247 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1))
    static let cosmeticsLightColor = Color(UIColor(red: 255 / 255, green: 190 / 255, blue: 189 / 255, alpha: 1))

    static let upgradesThrowLightColor = Color(UIColor(red: 81 / 255, green: 216 / 255, blue: 176 / 255, alpha: 1))
    static let upgradesThrowLightShadow = Color(UIColor(red: 0, green: 186 / 255, blue: 128 / 255, alpha: 1))
    static let upgradesThrowDarkColor = Color(UIColor(red: 8 / 255, green: 108 / 255, blue: 68 / 255, alpha: 1))
    
    static let upgradesAeroDarkColor = Color(UIColor(red: 216 / 255, green: 44 / 255, blue: 92 / 255, alpha: 1))

    static let upgradesGoldDarkColor = Color(UIColor(red: 224 / 255, green: 116 / 255, blue: 124 / 255, alpha: 1))
    static let upgradesGoldLightColor = Color(UIColor(red: 1, green: 225 / 255, blue: 138 / 255, alpha: 1))
    static let upgradesGoldLightShadow = Color(UIColor(red: 1, green: 179 / 255, blue: 144 / 255, alpha: 1))
    
    static let profilePink = Color(UIColor(red: 248 / 255, green: 76 / 255, blue: 84 / 255, alpha: 1))
    static let profileLightPink = Color(UIColor(red: 256 / 255, green: 148 / 255, blue: 156 / 255, alpha: 1))
    
    static let builderShadowColor = Color(UIColor(red: 188 / 255, green: 138 / 255, blue: 1, alpha: 1))
    static let builderDarkPurple = Color(UIColor(red: 145 / 255, green: 88 / 255, blue: 1, alpha: 1))
    static let builderDarkRed = Color(UIColor(red: 189 / 255, green: 0 / 255, blue: 8 / 255, alpha: 1))
    static let builderLightColor = Color(UIColor(red: 228 / 255, green: 208 / 255, blue: 1, alpha: 1))
    
    static let settingsShadow = Color(UIColor(red: 1, green: 188 / 255, blue: 167 / 255, alpha: 1))
    static let settingsDarkPink = Color(UIColor(red: 1, green: 172 / 255, blue: 172 / 255, alpha: 1))
    static let settingsLightPink = Color(UIColor(red: 1, green: 210 / 255, blue: 195 / 255, alpha: 1))
    
    static let WidgetColors: [[ CGFloat ]] = [
        [196,196,196,255],
        [134,132,130,255],
        [64,64,64,255],
        [0,0,0,255],
        [255,255,255,255],
        [192,125,92,255],
        [205,151,87,255],
        [129,113,86,255],
        [255,212,223,255],
        [224,152,241,255],
        [237,110,239,255],
        [136,69,254,255],
        [182,216,255,255],
        [72,69,252,255],
        [60,174,244,255],
        [94,209,236,255],
        [196,239,211,255],
        [118,233,176,255],
        [116,183,94,255],
        [188,220,100,255],
        [244,236,180,255],
        [247,234,120,255],
        [252,215,180,255],
        [252,196,75,255],
        [252,192,145,255],
        [252,152,73,255],
        [246,177,108,255],
        [252,132,108,255],
        [252,196,196,255],
        [252,115,92,255],
        [252,124,140,255],
        [252,104,110,255]
]
    
    static func compressColorData(index: Int) -> String {
        let mappedStrings = Colors.WidgetColors.map({ dataArray in
            dataArray.map( { data in "\(Int(data))"  }  ) })
        
        let formattedString = mappedStrings[index].joined(separator: ",")
        return "rgba("+formattedString+")"
    }
    
    static func decodeColor(_ data: [CGFloat]) -> Color {
        return Color( UIColor( red: data[0] / 255, green: data[1] / 255, blue: data[2] / 255, alpha: data[3] / 255 ) )
    }
}
