//
//  Color.swift
//  TicketBash
//
//  Created by Nicolai Safai on 8/9/15.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import Foundation

let backgroundColor = UIColorFromHex(0x34495E, alpha: 1.0)
let paletteWhite = UIColorFromHex(0xECF0F1, alpha: 1.0)
let paletteGrey = UIColorFromHex(0x95A5A6, alpha: 1.0)
let paletteOrange = UIColorFromHex(0xE67E22, alpha: 1.0)
let paletteDarkBlue = UIColorFromHex(0x222F3C, alpha: 1.0)


// RGB
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// HEX
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

