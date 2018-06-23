//
//  FlashingPanel.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 22/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import UIKit

class FlashingPanel: UIButton {
    func flashPanel (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double) {
        var timesFlashed = 0
        
        Timer.every(everySecs) { (timer: Timer) in
            self.alpha = 1
            timesFlashed += 1

            Timer.after(lightUpForSecs) {
//            Timer.after(0.5.seconds) {
                self.alpha = 0.3
            }

            if timesFlashed >= numberOfTimes {
                timer.invalidate()
            }
//        Timer.every(intervalSeconds) { (timer: Timer) in

//            let buttonChosen = self.allButtons[self.sequence[self.count]]
            
//            buttonChosen.alpha = 1
//
//            Timer.after(0.5.seconds) {
//                buttonChosen.alpha = 0.3
//            }
            
//            self.count += 1
//            if self.count >= self.sequence.count {
//                timer.invalidate()
//            }
        }
    }

}
