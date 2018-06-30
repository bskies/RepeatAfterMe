//
//  FlashingPanel.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 22/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import UIKit

class GamePanel: UIButton {
    let panelDimAlphaValue = CGFloat(0.3)

    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double) {
        var timesFlashed = 0
        
        Timer.every(everySecs) { (timer: Timer) in
            self.alpha = 1
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
