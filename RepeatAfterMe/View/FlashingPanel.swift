//
//  FlashingPanel.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 22/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import UIKit

class FlashingPanel: UIButton {
    let panelDimAlphaValue = CGFloat(0.3)

    func flashPanel (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double) {
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

    func lightPanel () {
        self.alpha = 1
    }

    func dimPanel () {
        self.alpha = panelDimAlphaValue
    }

    func enablePanel () {
        self.isEnabled = true
    }

    func disablePanel () {
        self.isEnabled = false
    }
}
