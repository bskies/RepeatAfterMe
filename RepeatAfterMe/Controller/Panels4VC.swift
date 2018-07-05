//
//  Panels4VC.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 17/3/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//


// General To Dos
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

//Changes made to incorporate SwiftyTimer and outlet collection
//* existing outlets removed
//* outlet collection added and buttons linked
//* tags changed from 0-3 to 1-4 (0 default for all objects)
//* SwiftyTimer pod installed
//* changed code to use outlet collection
//
//To do:
//* replace my timer stuff with SwiftyTimer


import UIKit
import SwiftyTimer
import RealmSwift

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

    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet var panels: [GamePanel]!

    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        for panel in panels {
            panel.roundCorner()
        }

        loadHighScores()
        
        for i in highScores {
            print("\(i.date); \(i.name); \(i.score)")
        }
        
        prepareForStart()
        
//        panels[0].setTitle("Zero 0", for: .normal)
//        panels[1].setTitle("One 1", for: .normal)
//        panels[2].setTitle("Two 2", for: .normal)
//        panels[3].setTitle("Three 3", for: .normal)
//        panels[4].setTitle("Four 4", for: .normal)
//        panels[5].setTitle("Five 5", for: .normal)
//        panels[0].setLabel(labelText: "Zero 0")
//        panels[1].setLabel(labelText: "One 1")
//        panels[2].setLabel(labelText: "Two 2")
//        panels[3].setLabel(labelText: "Three 3")
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

        panels[1].setLabel(labelText: "Last Game Stats:\n\nRound: \(panelSequence.count)\nScore: \(score)")
        
        prepareForStart()
    }

    func dimPanels () {
        for panel in panels {
            print(panel.tag)
            panel.dim(brightHexValue: brightColours[panel.tag - 1])
//            panel.setPanelColour(colourHex: dimColours[panel.tag - 1])
        }
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
    
    func handlePressedPanel(_ sender: UILongPressGestureRecognizer, panelNumber: Int) {
        let panel = panels[panelNumber]

        if sender.state == UIGestureRecognizerState.began
        {
            panel.light(brightHexValue: brightColours[panelNumber])
        } else if sender.state == UIGestureRecognizerState.ended {
//            print("Panel released - \(panelNumber)")
            moveTimer.invalidate()

            if !gameIsOver {
                moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(missedMove), userInfo: nil, repeats: false)
                
                panel.dim(brightHexValue: brightColours[panelNumber])

                if panelNumber == panelSequence[currentNoteItemInput] {
                    currentNoteItemInput += 1
                    score += scoreIncrementor
                    
                    if currentNoteItemInput >= panelSequence.count {
                        moveTimer.invalidate()
                        lockPanels()
                        playRound()
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

        panels[panelToFlash].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration, dimHexValue: dimColours[panelToFlash], brightHexValue: brightColours[panelToFlash])

//        panels[panelToFlash].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
    func wrongPanelPressed (number panelNumber: Int) {
        lockPanels()
        panelToFlash = panelNumber
        moveTimer.invalidate()
        
        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration, dimHexValue: dimColours[panelNumber], brightHexValue: brightColours[panelNumber])

//        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
//    MARK: Game functions
    func prepareForStart () {
        var highScoreText = ""
        
        dimPanels()             // was hidden. Tryng to ID where extra dimming coming from
        startButton.isHidden = false
        startButton.isHidden = true
//        lockPanels()
        if let text = panels[1].titleLabel?.text {
            panels[1].setLabel(labelText: text)
        }
        
//      Set up START panel
        panels[3].hidePanel()
        panels[4].unhidePanel()
        panels[4].enable()
//        panels[3].setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: <#T##UIControlState#>)
//        let attributeString = NSMutableAttributedString(string: "START",
//                                                        attributes: yourAttributes)
//        panels[3].setAttributedTitle(attributeString, for: .normal)

//      Set up High Score panel
        panels[0].hidePanel()
        panels[5].unhidePanel()
        panels[5].enable()

        for highScore in highScores {
            print(highScore.score)
            highScoreText += String(highScore.score) + "\n"
        }
//        panels[0].setTitle(highScoreText, for: .normal)
        panels[5].setLabel(labelText: highScoreText)
//        panels[0].setTitle(highScoreText, for: .normal)
        panels[5].setTitle(highScoreText, for: .normal)
    }

    func playRound () {
        gameIsOver = false

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

        startButton.isHidden = true
        panels[0].unhidePanel()
        panels[5].hidePanel()
        panels[3].unhidePanel()
        panels[4].hidePanel()

        //        MARK: TODO: use SwiftyTimer
        Timer.every(playbackTempo) { (timer: Timer) in
            let currentNote = self.panelSequence[self.currentNoteItemPlayed]
            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration, dimHexValue: dimColours[currentNote], brightHexValue: brightColours[currentNote])

//            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration)

            self.currentNoteItemPlayed += 1
            
            if self.currentNoteItemPlayed >= self.noteCount {
                timer.invalidate()
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
        
        userMessage.isHidden = true
        
        playbackTempo = 1.0
        
        score = 0
        scoreIncrementor = 1
        panels[0].setLabel(labelText: "")
        panels[1].setLabel(labelText: "")

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
    
    @IBAction func startButtonPressed(_ sender: Any) {
        startGame()
    }
    
    @IBAction func handleGreenPress (_ sender: UILongPressGestureRecognizer) {
//        print("Green pressed")
        handlePressedPanel(sender, panelNumber: 0)
    }
    
    @IBAction func handleRedPress(_ sender: UILongPressGestureRecognizer) {
//        print("Red pressed")
        handlePressedPanel(sender, panelNumber: 1)
    }
    
    @IBAction func handleYellowPress(_ sender: UILongPressGestureRecognizer) {
//        print("Yellow pressed")
        handlePressedPanel(sender, panelNumber: 2)
    }
    
    @IBAction func handleBluePress(_ sender: UILongPressGestureRecognizer) {
        handlePressedPanel(sender, panelNumber: 3)
    }
    
    @IBAction func handleBlueInfoButtonPress(_ sender: Any) {
        print("Blue START pressed")
        startGame()
    }
}
