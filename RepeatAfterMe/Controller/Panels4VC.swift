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
    
//    do {
//        let realm = try! Realm()
//    //            try realm.write {
//    //                realm.add(score)
//    //            }
//    } catch {
//    print("Error initialising new realm: \(error)")
//    }
    
    var moveTimer = Timer()
    var currentNoteItemPlayed = 0
    var currentNoteItemInput = 0
    var gameIsOver = true
    
    var playbackTempo = 1.0
    var playbackFlashDuration = 0.3
    
    var score = 0
    var scoreIncrementor = 1

//    var flashRepeatsOnError = 4
//    var flashCount = 0
    var panelToFlash = 0
    
//    var noteInterval = 2

    var noteCount = 0
    var panelSequence:[Int] = []
     

    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet var panels: [GamePanel]!

    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadHighScores()
        
        for i in highScores {
            print("\(i.date); \(i.name); \(i.score)")
        }
        panels[1].setTitle("ABCEEE", for: .normal)
//        panels[1].setTitle("ABC", for: .disabled)

        panels[1].setLabel()
        
        prepareForStart()
    }
    
    func gameOver () {
        gameIsOver = true
        
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
        
        userMessage.text = "Game Over.\nRound: \(panelSequence.count)\nScore: \(score)"
        userMessage.isHidden = false
        prepareForStart()
    }

    @objc func dimPanels () {
        for panel in panels {
            panel.dim()
            panel.setPanelColour(colourHex: dimColours[panel.tag])
//            panel.backgroundColor( dimColours[panel.tag]
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
        if sender.state == UIGestureRecognizerState.began
        {
//            print("Panel pressed - \(panelNumber)")
            panels[panelNumber].light()
        } else if sender.state == UIGestureRecognizerState.ended {
//            print("Panel released - \(panelNumber)")
            moveTimer.invalidate()

            if !gameIsOver {
                moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(missedMove), userInfo: nil, repeats: false)
                
                panels[panelNumber].dim()
                
                if panelNumber == panelSequence[currentNoteItemInput] {
//                    print("Correct panel pressed, wanted \(panelSequence[currentNoteItemInput]) pressed \(panelNumber)")
                    currentNoteItemInput += 1
//                    print("Score Incrementor: \(scoreIncrementor); Score: \(score)")
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
                //            dimPanels()
            }
        }
    }
    
    @objc func missedMove () {
        print ("missedMove initiated")

//        flashCount = 0
        panelToFlash = panelSequence[currentNoteItemInput]

        moveTimer.invalidate()

        lockPanels()
//        dimPanels()

        panels[panelToFlash].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
    func wrongPanelPressed (number panelNumber: Int) {
        lockPanels()
//        flashCount = 0
        panelToFlash = panelNumber
        moveTimer.invalidate()
        
//        print("Just before flashPanel in wrongPanelPressed")
        
        panels[panelNumber].flash(numberOfTimes: numberFlashesOnFail, everySecs: flashDuration * 2, lightUpForSecs: flashDuration)

        Timer.after(Double(numberFlashesOnFail) * flashDuration * 2) {
            self.gameOver()
        }
    }
    
//    MARK: Game functions
    func prepareForStart () {
        var highScoreText = ""
        
        dimPanels()
        startButton.isHidden = false
        lockPanels()
        
        print(String(highScores[0].score))
//        panels[1].setTitle(String(highScores[0].score), for: .disabled)
//        panels[1].setTitle(String(highScores[0].score), for: .normal)
        
        for highScore in highScores {
            print(highScore.score)
            highScoreText += String(highScore.score) + "\n"
        }
        panels[0].setTitle(highScoreText, for: .normal)

    }

    func playRound () {
        currentNoteItemPlayed = 0
        
        if playbackTempo > 0.2 && panelSequence.count % 2 == 0 && panelSequence.count > 0 {
//            print("Increasing difficulty - panelSequence.count: \(panelSequence.count)")
            playbackTempo -= 0.05
            playbackFlashDuration = playbackTempo / 3
            scoreIncrementor += 1
        }

        lockPanels()
        panelSequence += [Int(arc4random_uniform(numberOfPanels))]

        print(panelSequence)
        
        noteCount = panelSequence.count
        currentNoteItemInput = 0

        startButton.isHidden = true
        
        //        MARK: TODO: use SwiftyTimer
        Timer.every(playbackTempo) { (timer: Timer) in
            let currentNote = self.panelSequence[self.currentNoteItemPlayed]
//            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: 0.3)
            self.panels[currentNote].flash(numberOfTimes: 1, everySecs: 0, lightUpForSecs: self.playbackFlashDuration)
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
        gameIsOver = false
        
        playbackTempo = 1.0
//        playbackFlashDuration = 0.3
        
        score = 0
        scoreIncrementor = 1

        playRound()
    }
    
    func loadHighScores () {
        highScores = realm.objects(HighScores.self)
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
//        print("Blue pressed")
        handlePressedPanel(sender, panelNumber: 3)
    }
}
