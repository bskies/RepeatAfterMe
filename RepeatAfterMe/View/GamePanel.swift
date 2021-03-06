//
//  FlashingPanel.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 22/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import UIKit
import ChameleonFramework
import AVFoundation

class GamePanel: UIButton {
//    let panelDimAlphaValue = CGFloat(0.3)
    
//    init() {
//        super.init(frame: .zero)
//        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .disabled)
////        self.layer.cornerRadius = 25
//        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
//    }
    
    var player = AVAudioPlayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
////        fatalError("init(coder:) has not been implemented")
//    }
    
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

//    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double, brightHexValue: String, sound: String) {
    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double, brightHexValue: String, audioPlayer: AVAudioPlayer) {
//        let audioPath = Bundle.main.path(forResource: sound, ofType: "m4a")
        
//        print("\(sounds[panelNumber])")
        
        audioPlayer.play()

//        do {
//            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
//
//            player.play()
//
//        } catch {
//            print("Unable to play sound.")
//        }

//        func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double, dimHexValue: String, brightHexValue:String) {
//    func flash (numberOfTimes: Int, everySecs: Double, lightUpForSecs: Double) {

        var timesFlashed = 0
        
        Timer.every(everySecs) { (timer: Timer) in
//            self.alpha = 1
//            self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: self.panelDimAlphaValue)

            self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: 1)

            self.light(brightHexValue: brightHexValue)
            timesFlashed += 1
            
            Timer.after(lightUpForSecs) {
                //            Timer.after(0.5.seconds) {
                self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: panelDimAlphaValue)
//                self.alpha = self.panelDimAlphaValue
//                self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
//                self.player.stop()

                audioPlayer.stop()
            }
            
            if timesFlashed >= numberOfTimes {
                timer.invalidate()
            }
        }
    }
    
    func light (brightHexValue:String) {
//        self.alpha = 1
        self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: 1)
//        self.layer.cornerRadius = 25
    }

    func dim (brightHexValue:String) {
//        self.alpha = panelDimAlphaValue
        self.backgroundColor = UIColor(hexString: brightHexValue, withAlpha: panelDimAlphaValue)
//        self.backgroundColor = UIColor(hexString: colourHex)

    }
    
    func hidePanel () {
        self.isHidden = true
    }
    
    func unhidePanel () {
        self.isHidden = false
    }
    
    func setPanelColour (colourHex: String) {
        self.backgroundColor = UIColor(hexString: colourHex)
    }
//
//    func roundCorner () {
////        self.layer.cornerRadius = 15
//    }

    func enable () {
        self.isEnabled = true
    }

    func disable () {
        self.isEnabled = false
    }
    
    func setLabel (labelText: String) {
        self.setTitle(labelText, for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
//        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .disabled)
//        self.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: <#T##UIControlState#>)
    }
}
