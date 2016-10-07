//
//  UIStyleUtility.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

extension UIColor {
    // Usage: UIColor(hex: 0xFC0ACE)
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    // Usage: UIColor(hex: 0xFC0ACE, alpha: 0.25)
    convenience init(hex: Int, alpha: Double) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}


extension JVFloatLabeledTextField {
    func addCBOperationDemoCustomStyle() -> Void {
        font = UIStyleUtility.FMHeading3Font
        textColor = UIStyleUtility.FMHeading3Color
        
        floatingLabelFont = UIStyleUtility.FMHeading2Font
        floatingLabelTextColor = UIStyleUtility.FMHeading2Color
    }
    
    func setCustomCBOperationDemoCustomStylePlaceholderText(text: String, isMandatory: Bool) -> Void {
        
        let mainFont = UIStyleUtility.FMHeading2Font ?? UIFont.systemFont(ofSize: 16)
        let mandatoryFont = UIStyleUtility.FMLinkFont ?? UIFont.systemFont(ofSize: 16)
        
        let mainText = [NSForegroundColorAttributeName: UIStyleUtility.FMHeading2Color, NSFontAttributeName: mainFont]
        let mandatoryStar = [NSForegroundColorAttributeName: UIStyleUtility.FMLinkColor, NSFontAttributeName: mandatoryFont]
        
        let partOne = NSMutableAttributedString(string: text, attributes: mainText)
        let partTwo = NSMutableAttributedString(string: "*", attributes: mandatoryStar)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        if isMandatory {
            combination.append(partTwo)
        }
        
        setAttributedPlaceholder(combination, floatingTitle: combination.string)
    }
}
class UIStyleUtility: NSObject {
    
    static let FMHeading1Font               = UIFont(name: "Avenir-Heavy", size: 20)
    static let FMHeading2Font               = UIFont(name: "Avenir-Medium", size: 16)
    static let FMHeading3Font               = UIFont(name: "Avenir-Heavy", size: 16)
    static let FMLinkFont                   = UIFont(name: "Avenir-Heavy", size: 16)
    
    static let FMHeading1Color              = UIColor(hex: 0x253A4B)
    static let FMHeading2Color              = UIColor(hex: 0x6E7C8E)
    static let FMHeading3Color              = UIColor(hex: 0x253A4B)
    static let FMLinkColor                  = UIColor(hex: 0x00A7F7)
    
    static let FMButtonActiveTextColor      = UIColor(hex: 0xFFFFFF)
    static let FMButtonInActiveTextColor    = UIColor(hex: 0x798698)
    static let FMButtonDisableTextColor     = UIColor(hex: 0x798698, alpha: 0.5)
    
    static let FMDarkBlur                   = UIColor(hex: 0x253A4B)
    static let FMSlateGrey                  = UIColor(hex: 0x6E7C8E)
    static let FMLightGrey                  = UIColor(hex: 0xF1F1F1)
    static let FMBrightBlue                 = UIColor(hex: 0x00AFF8)
    static let FMYellow                     = UIColor(hex: 0xFFC600)
    static let FMThemeColor                 = UIColor(hex: 0x2B9FD4)

}
