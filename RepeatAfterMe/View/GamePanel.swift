//
//  FlashingPanel.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 22/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import UIKit
import ChameleonFramework

class GamePanel: UIButton {
    let panelDimAlphaValue = CGFloat(0.3)
    
    init() {
        super.init(frame: .zero)
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .disabled)
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

//        fatalError("init(coder:) has not been implemented")
    }
    
//    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double) {
//        var timesFlashed = 0
//
//        Timer.every(everySecs) { (timer: Timer) in
//            self.alpha = 1
//            timesFlashed += 1
//
//            Timer.after(lightUpForSecs) {
////            Timer.after(0.5.seconds) {
//                self.alpha = self.panelDimAlphaValue
//            }
//
//            if timesFlashed >= numberOfTimes {
//                timer.invalidate()
//            }
//
//        }
//    }

    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double, dimHexValue: String, brightHexValue:String) {
        var timesFlashed = 0
        
        Timer.every(everySecs) { (timer: Timer) in
            self.alpha = 1
//            self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: self.panelDimAlphaValue)
            self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: 1)
            timesFlashed += 1
            
            Timer.after(lightUpForSecs) {
                //            Timer.after(0.5.seconds) {
                self.alpha = self.panelDimAlphaValue
            }
            
            if timesFlashed >= numberOfTimes {
                timer.invalidate()
            }
            
        }
    }
    
    func light () {
        self.alpha = 1
    }

    func dim () {
        self.alpha = panelDimAlphaValue
    }
    
    func setPanelColour (colourHex: String) {
        self.backgroundColor = UIColor(hexString: colourHex)
    }

    func enable () {
        self.isEnabled = true
    }

    func disable () {
        self.isEnabled = false
    }
    
    func setLabel () {
        self.setTitle("ABCWWW", for: .normal)
    }
}
