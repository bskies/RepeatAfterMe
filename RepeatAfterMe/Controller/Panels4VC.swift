//
//  Panels4VC.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 17/3/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//


// MARK: General To Dos
// Remove hard coding of progress bar extremity
// * Try to fix sound. Clipping, stops working for one or more panels.
// * before game play begins, label buttons as High Scores, Practice mode, Game Modes, Start
// * Practice mode could include:
//      - set number, will iterate through different sequences of same length
//      - practice same sequence repeatedly
//
//      - buttons could be labelled Practice Same Sequence, Different Sequences of same length, Return
//
// * Game Mode could include:
//      - same sequence, incremented each round
//      - different sequences but DO NOT increment each round


import UIKit
import SwiftyTimer
import RealmSwift
import ChameleonFramework
import AVFoundation

class Panels4VC: UIViewController {
    
    let realm = try! Realm()

    var highScores: Results<HighScores>!
    
    var moveTimer = Timer()
    var currentNoteItemPlayed = 0
    var currentNoteItemInput = 0
    var gameIsOver = true
    
    var playbackTempo = 1.0
    var playbackFlashDuration = 0.3
    
    var score = 0
    var scoreIncrementor = 1

    var panelToFlash = 0
    
    var noteCount = 0
    var panelSequence:[Int] = []
     
//    let yourAttributes : [NSAttributedStringKey: Any] = [
//        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30),
//        NSAttributedStringKey.foregroundColor : UIColor.white,
//        //        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
//    ]
    
    var greenPlayer = AVAudioPlayer()
    var redPlayer = AVAudioPlayer()
    var yellowPlayer = AVAudioPlayer()
    var bluePlayer = AVAudioPlayer()
    var audioPlayer = AVAudioPlayer()


//    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet var panels: [GamePanel]!

    @IBOutlet weak var scorePanel: GamePanel!
    //    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var startPanel: GamePanel!
    
    @IBOutlet weak var highScoreNameLabel: UILabel!
    
    @IBOutlet weak var highScoreScoreLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        for panel in panels {
//            panel.roundCorner()
//        }
//
//        scorePanel.roundCorner()
//        startPanel.roundCorner()

        loadHighScores()
        
//        for i in highScores {
//            print("\(i.date); \(i.name); \(i.score)")
//        }
        
        
//        for i in panels {
//            i.light(brightHexValue: brightColours[i.tag - 1])
//        }
//
//        startPanel.setLabel(labelText: "")
//        highScoreNameLabel.text = ""
//        highScoreScoreLabel.text = ""
//
//        Timer.after(playbackTempo * 30) {
//            self.prepareForStart()
//        }
        
        let greenAudioPath = Bundle.main.path(forResource: "Green", ofType: "m4a")
        let redAudioPath = Bundle.main.path(forResource: "Red", ofType: "m4a")
        let yellowAudioPath = Bundle.main.path(forResource: "Yellow", ofType: "m4a")
        let blueAudioPath = Bundle.main.path(forResource: "Blue", ofType: "m4a")

//        print("\(sounds[panelNumber])")
        
        do {
            try greenPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: greenAudioPath!))
        } catch {
            print("Unable to play green sound.")
        }
        
        do {
            try redPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: redAudioPath!))
        } catch {
            print("Unable to play red sound.")
        }
        
        do {
            try yellowPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: yellowAudioPath!))
        } catch {
            print("Unable to play yellow sound.")
        }
        
        do {
            try bluePlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: blueAudioPath!))
        } catch {
            print("Unable to play blue sound.")
        }
        
        
        
        prepareForStart()
        
//        let gradientColours = [UIColor.green,UIColor.red]
//    
//        progressBar.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: progressBar.frame, andColors: gradientColours)
//        progressBarBackground.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: progressBarBackground.frame, andColors: gradientColours)

            
            
//        panels[0].setTitle("Zero 0", for: .normal)
//        panels[1].setTitle("One 1", for: .normal)
//        panels[2].setTitle("Two 2", for: .normal)
//        panels[3].setTitle("Three 3", for: .normal)
//        panels[4].setTitle("Four 4", for: .normal)
//        panels[5].setTitle("Five 5", for: .normal)

        scorePanel.disable()
//        scorePanel.isHidden = true
//        panels[greenPanelNumber].setLabel(labelText: "Zero 0")
//        panels[redPanelNumber].setLabel(labelText: "One 1")
//        panels[yellowPanelNumber].setLabel(labelText: "Two 2")
//        panels[bluePanelNumber].setLabel(labelText: "Three 3")
//        panels[4].setLabel(labelText: "Four 4")
//        panels[5].setLabel(labelText: "Five 5")
        
    }
    
    func gameOver () {
        gameIsOver = true
        
        if self.highScores.count < 5 || score > self.highScores[4].score {
            if self.highScores.count > 4 {
                for i in 4...self.highScores.count - 1 {
                    if let hScore = self.highScores?[i] {
                        do {
                            try self.realm.write {
                                self.realm.delete(hScore)
                            }
                        } catch {
                            print("Error deleting item, \(error)")
                        }
                    }

                }
            }
            
            let highScore = HighScores()
            highScore.name = "Jes"
            highScore.score = score
            highScore.mode = "Standard"
            
            do {
                try realm.write {
                    realm.add(highScore)
                }
            } catch {
                print("Error initialising new realm: \(error)")
            }
        }

//        let highScore = HighScores()
//        highScore.name = "Jes"
//        highScore.score = score
//        highScore.mode = "Standard"
//
//        do {
//            try realm.write {
//                realm.add(highScore)
//            }
//        } catch {
//            print("Error initialising new realm: \(error)")
//        }

//        if let hScore = self.highScores?[5] {
//            do {
//                try self.realm.write {
//                    self.realm.delete(hScore)
//                }
//            } catch {
//                print("Error deleting item, \(error)")
//            }
//        }

        print("Setting up score panel: Round: \(panelSequence.count) Score: \(score)")
        
        panels[redPanelNumber].setLabel(labelText: "Last Game Stats:\n\nRound: \(panelSequence.count)\nScore: \(score)")
        
        prepareForStart()
    }

    func dimPanels () {
        for panel in panels {
//            print(panel.tag)
            panel.dim(brightHexValue: brightColours[panel.tag - 1])
//            panel.setPanelColour(colourHex: dimColours[panel.tag - 1])
        }
        scorePanel.dim(brightHexValue: brightColours[greenPanelNumber])
        startPanel.dim(brightHexValue: brightColours[bluePanelNumber])
    }
    
    func lockPanels () {
        for panel in panels {
            panel.disable()
        }
    }
    
    func prepareForInput () {
        for panel in panels {
            panel.enable()
        }
    }
    
    func updateProgressBar (itemNumber: Int, of: Int) {
        if itemNumber == 0 {
            
            self.progressBar.frame.size.width = 0
            
        } else {
            
            UIView.animate(withDuration: 0.3) {
                let viewWidth = self.view.frame.width - 35
                
                
                //            self.progressBar.frame.size.width = viewWidth * CGFloat(itemNumber + 1) / CGFloat(of)
                self.progressBar.frame.size.width = viewWidth * CGFloat(itemNumber) / CGFloat(of)
                
                //                currentNoteItemInput >= panelSequence.count
                //
                //            self.progressBar.frame.size.width = viewWidth * CGFloat(self.currentNoteItemInput + 1) / CGFloat(self.panelSequence.count)
                //
                //                print(viewWidth)
                //
                //                self.progressBar.frame.size.width += 50
            }
        }
    }
    
    
    
    
    
    func handlePressedPanel(_ sender: UILongPressGestureRecognizer, panelNumber: Int, audioPlayer: AVAudioPlayer) {
        let panel = panels[panelNumber]

        if sender.state == UIGestureRecognizerState.began
        {
            panel.light(brightHexValue: brightColours[panelNumber])
            
//            let audioPath = Bundle.main.path(forResource: sounds[panelNumber], ofType: "m4a")
            
            print("\(sounds[panelNumber])")
            
            audioPlayer.play()

//            do {
//                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
//
//                player.play()
//
//            } catch {
//                print("Unable to play sound.")
//            }
            
            
            
            updateProgressBar(itemNumber: self.currentNoteItemInput + 1, of: self.panelSequence.count)
            
//            UIView.animate(withDuration: 0.3) {
//                let viewWidth = self.view.frame.width - 35
//
////                currentNoteItemInput >= panelSequence.count
//
//                self.progressBar.frame.size.width = viewWidth * CGFloat(self.currentNoteItemInput + 1) / CGFloat(self.panelSequence.count)
////
////                print(viewWidth)
////
////                self.progressBar.frame.size.width += 50
//            }
            
        } else if sender.state == UIGestureRecognizerState.ended {
//            print("Panel released - \(panelNumber)")
            moveTimer.invalidate()

            if !gameIsOver {
                moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(missedMove), userInfo: nil, repeats: false)
                
                panel.dim(brightHexValue: brightColours[panelNumber])

                audioPlayer.stop()

                if panelNumber == panelSequence[currentNoteItemInput] {
//                    print("score: \(score) scoreIncrementor \(scoreIncrementor)")
                    
                    currentNoteItemInput += 1
                    score += panelSequence.count // scoreIncrementor
                    
                    if currentNoteItemInput >= panelSequence.count {
                        moveTimer.invalidate()
                        lockPanels()
                        
                        Timer.after(playbackTempo * 0.5) {
                            self.progressBar.frame.size.width = 0
                        }
                        
                        playRound()
                        
//                        progressBar.frame.size.width = 0
                    }
                } else {
//                    print("INCORRECT panel pressed, wanted \(panelSequence[currentNoteItemInput]) pressed \(panelNumber)")
                    wrongPanelPressed(number: panelSequence[currentNoteItemInput])
                }
            }
        }
    }
    
    @objc func missedMove () {
        
        print ("missedMove initiated")

        panelToFlash = panelSequence[currentNoteItemInput]

        moveTimer.invalidate()

        lockPanels()
        
        if panelToFlash == 0 {
            audioPlayer = greenPlayer
        } else if panelToFlash == 1 {
            audioPlayer = redPlayer
        } else if panelToFlash == 2 {
            audioPlayer = yellowPlayer
        } else if panelToFlash == 3 {
            audioPlayer = bluePlayer
        }

        panels[panelToFlash].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration, brightHexValue: brightColours[panelToFlash], audioPlayer: audioPlayer)

//        panels[panelToFlash].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
    func wrongPanelPressed (number panelNumber: Int) {
        lockPanels()
        panelToFlash = panelNumber
        moveTimer.invalidate()
        
        if panelToFlash == 0 {
            audioPlayer = greenPlayer
        } else if panelToFlash == 1 {
            audioPlayer = redPlayer
        } else if panelToFlash == 2 {
            audioPlayer = yellowPlayer
        } else if panelToFlash == 3 {
            audioPlayer = bluePlayer
        }
        
        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration, brightHexValue: brightColours[panelNumber], audioPlayer: audioPlayer)

//        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration, dimHexValue: dimColours[panelNumber], brightHexValue: brightColours[panelNumber])

//        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
//    MARK: Game functions
    func prepareForStart () {
//        var highScoreText = ""
        var highScoreName = ""
        var highScoreScore = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_AU")

        
        dimPanels()             // was hidden. Tryng to ID where extra dimming coming from
//        startButton.isHidden = false
//        startButton.isHidden = true
//        lockPanels()
        
//        if let text = panels[redPanelNumber].titleLabel?.text {
//            panels[redPanelNumber].setLabel(labelText: text)
//        }
        
//      Set up START panel
        panels[greenPanelNumber].hidePanel()
        panels[bluePanelNumber].hidePanel()
        startPanel.unhidePanel()
        scorePanel.unhidePanel()
        highScoreNameLabel.isHidden = false
        highScoreScoreLabel.isHidden = false
        
//        print("About to size progressBar to 0")
//        progressBar.frame.size.width = 0

//        panels[4].unhidePanel()
//        panels[4].enable()


//        let attributeString = NSMutableAttributedString(string: "START", attributes: yourAttributes)
//        panels[3].setAttributedTitle(attributeString, for: .normal)


        
        
        
        //      Set up High Score panel
//        panels[0].hidePanel()
//        panels[5].unhidePanel()
//        panels[5].enable()

        for highScore in highScores {
//            print(highScore.score)
//            highScoreText += String(highScore.score) + "\n"
            highScoreName += "\(highScore.name) \(dateFormatter.string(from: highScore.date)) \n"
            highScoreScore += String(highScore.score) + "\n"
            
//            print(dateFormatter.string(from: highScore.date))
        }
        
//        scorePanel.setTitle(highScoreText, for: .normal)
        highScoreNameLabel.text = highScoreName
        highScoreScoreLabel.text = highScoreScore
        
//        panels[0].setTitle(highScoreText, for: .normal)
//        panels[5].setLabel(labelText: highScoreText)
//        panels[0].setTitle(highScoreText, for: .normal)
//        panels[5].setTitle(highScoreText, for: .normal)
    }

    func playRound () {
        gameIsOver = false

        // Change not being displayed until later
//        self.progressBar.frame.size.width = 0

        currentNoteItemPlayed = 0
        
        if playbackTempo > 0.2 && panelSequence.count % 2 == 0 && panelSequence.count > 0 {
            playbackTempo -= 0.05
            playbackFlashDuration = playbackTempo / 3
            scoreIncrementor += 1
        }

//        lockPanels()
        panelSequence += [Int(arc4random_uniform(numberOfPanels))]

        print(panelSequence)
        
        noteCount = panelSequence.count
        currentNoteItemInput = 0
        
        // Hide info panels; activate game panels
        startPanel.isHidden = true
        scorePanel.isHidden = true
        panels[greenPanelNumber].unhidePanel()
        panels[bluePanelNumber].unhidePanel()

//        startButton.isHidden = true
//        panels[0].unhidePanel()
//        panels[5].hidePanel()
//        panels[3].unhidePanel()
//        panels[4].hidePanel()

        //        MARK: TODO: use SwiftyTimer
        Timer.every(playbackTempo) { (timer: Timer) in
            let currentNote = self.panelSequence[self.currentNoteItemPlayed]
//            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration, dimHexValue: dimColours[currentNote], brightHexValue: brightColours[currentNote])

            if currentNote == 0 {
                self.audioPlayer = self.greenPlayer
            } else if currentNote == 1 {
                self.audioPlayer = self.redPlayer
            } else if currentNote == 2 {
                self.audioPlayer = self.yellowPlayer
            } else if currentNote == 3 {
                self.self.audioPlayer = self.bluePlayer
            }
            
            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration, brightHexValue: brightColours[currentNote], audioPlayer: self.audioPlayer)
            
            

            self.updateProgressBar(itemNumber: self.currentNoteItemPlayed + 1, of: self.noteCount)
            
//            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration)

            self.currentNoteItemPlayed += 1
            
            if self.currentNoteItemPlayed >= self.noteCount {
                timer.invalidate()

//                self.progressBar.frame.size.width = 0
                
                Timer.after(self.playbackTempo * 0.5, {
                    self.updateProgressBar(itemNumber: 0, of: 1)
//                                    self.progressBar.frame.size.width = 0
                })

                print ("Sequence done")
    
                self.moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(self.missedMove), userInfo: nil, repeats: false)
                self.prepareForInput()
            }
        }
    }
    
    func startGame () {
        panelSequence = []
//        panelSequence = [1,0,3,2,1,1,2,0]
        currentNoteItemPlayed = 0
        
//        userMessage.isHidden = true
        
        playbackTempo = 1.0
        
        score = 0
        scoreIncrementor = 1
//        panels[greenPanelNumber].setLabel(labelText: "")
        highScoreNameLabel.isHidden = true
        highScoreScoreLabel.isHidden = true
        panels[redPanelNumber].setLabel(labelText: "")

        playRound()
    }
    
    func loadHighScores () {
//        highScores = realm.objects(HighScores.self)
        highScores = realm.objects(HighScores.self).sorted(byKeyPath: String("score"), ascending: false)

//        func loadItems() {
//            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//
//            tableView.reloadData()
//        }

    }
    
//    @IBAction func startButtonPressed(_ sender: Any) {
//        startGame()
//    }
    
    @IBAction func handleGreenPress (_ sender: UILongPressGestureRecognizer) {
//        print("Green pressed")
        handlePressedPanel(sender, panelNumber: greenPanelNumber, audioPlayer: greenPlayer )
    }
    
    @IBAction func handleRedPress(_ sender: UILongPressGestureRecognizer) {
//        print("Red pressed")
        handlePressedPanel(sender, panelNumber: redPanelNumber, audioPlayer: redPlayer)
    }
    
    @IBAction func handleYellowPress(_ sender: UILongPressGestureRecognizer) {
//        print("Yellow pressed")
        handlePressedPanel(sender, panelNumber: yellowPanelNumber, audioPlayer: yellowPlayer)
    }
    
    @IBAction func handleBluePress(_ sender: UILongPressGestureRecognizer) {
//        print("Blue pressed")
        handlePressedPanel(sender, panelNumber: bluePanelNumber, audioPlayer: bluePlayer)
    }
    
    @IBAction func handleStartButtonPress(_ sender: Any) {
//        print("Blue START pressed")
        startGame()
    }
}
