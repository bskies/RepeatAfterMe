//
//  Panels4VC.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 17/3/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//


//
//Changes made to incorporate SwiftyTimer and outlet collection
//* existing outlets removed
//* outlet collection added and buttons linked
//* tags changed from 0-3 to 1-4 (0 default for all objects)
//* SwiftyTimer pod installed
//
//To do:
//* replace my timer stuff with SwiftyTimer
//* change code to use outlet collection - may need


import UIKit
import SwiftyTimer

class Panels4VC: UIViewController {

    var startTimer = Timer()
    var offTimer = Timer()
    var moveTimer = Timer()
    var lightTimer = Timer()
    var currentNote = 0
    var currentNoteItemPlayed = 0
    var currentNoteItemInput = 0

    var flashRepeatsOnError = 4
    var flashDuration = 1.0
    var flashCount = 0
    var flashPanel = 0
    
    var noteInterval = 2

    var noteCount = 0
    var panelSequence:[Int] = []

    @IBOutlet weak var userMessage: UILabel!
    
//    @IBOutlet var panels: [UIButton]!
    @IBOutlet var panels: [FlashingPanel]!

    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let redPanel = FlashingPanel ()

        panels[0].flashPanel(numberOfTimes: 50, everySecs: 0.1, lightUpForSecs: 0.05)
//        panels[0].flashPanel(numberOfTimes: 5)
        prepareForStart()
    }

    @objc func gameOver () {
        userMessage.text = "Game Over. Score: \(panelSequence.count - 1)"
        userMessage.isHidden = false
        prepareForStart()
    }
    
    func processPressedPanel (panel: Int) {
        print("Processing panel \(panel)")
        
        if panel == panelSequence[currentNoteItemInput] {
            print("Correct panel pressed, wanted \(panelSequence[currentNoteItemInput]) pressed \(panel)")
            currentNoteItemInput += 1
            if currentNoteItemInput >= panelSequence.count {
                moveTimer.invalidate()
                lockPanels()
                processNextRound()
            }
        } else {
            print("INCORRECT panel pressed, wanted \(panelSequence[currentNoteItemInput]) pressed \(panel)")
            wrongPanelPressed(number: panelSequence[currentNoteItemInput], for: 0.2, repeats: 8)
        }
    }
    
    //    MARK: Panel functions
    func lightPanel (_ panelNumber: Int) {
        panels[panelNumber].alpha = 1.0
    }
    
    @objc func dimPanels () {
        for panel in panels {
            panel.alpha = panelDimAlphaValue
        }
    }
    
    func lockPanels () {
        for panel in panels {
            panel.isEnabled = false
        }
    }
    
    func prepareForInput () {
        for panel in panels {
            panel.isEnabled = true
        }
    }
    
    func handlePressedPanel(_ sender: UILongPressGestureRecognizer, panelNumber: Int) {
        if sender.state == UIGestureRecognizerState.began
        {
            print("Panel pressed - \(panelNumber)")
            lightPanel(panelNumber)
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Panel released - \(panelNumber)")
            moveTimer.invalidate()
            moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(missedMove), userInfo: nil, repeats: false)
            processPressedPanel(panel: panelNumber)
            dimPanels()
        }
    }
    
    @objc func missedMove () {
        print ("missedMove initiated")

        flashDuration = 0.2
        flashRepeatsOnError = 8
        flashCount = 0
        flashPanel = panelSequence[currentNoteItemInput]

        startTimer.invalidate()
        moveTimer.invalidate()

        lockPanels()

        lightTimer = Timer.scheduledTimer(timeInterval: flashDuration, target: self, selector: #selector(flashLight), userInfo: nil, repeats: true)
    }
    
    @objc func flashLight () {
        lockPanels()
        if flashCount >= flashRepeatsOnError {
            lightTimer.invalidate()
            gameOver()
        } else {
            lightPanel(flashPanel)
            flashCount += 1
        }
        
        offTimer = Timer.scheduledTimer(timeInterval: flashDuration / 2, target: self, selector: #selector(dimPanels), userInfo: nil, repeats: false)
    }
    
    func wrongPanelPressed (number panelNumber: Int, for duration: Double, repeats: Int) {
        lockPanels()
        flashDuration = duration
        flashRepeatsOnError = repeats
        flashCount = 0
        flashPanel = panelNumber
        startTimer.invalidate()
        moveTimer.invalidate()
        
        lightTimer = Timer.scheduledTimer(timeInterval: flashDuration, target: self, selector: #selector(flashLight), userInfo: nil, repeats: true)
    }
    
//    MARK: Game functions
    func prepareForStart () {
        dimPanels()
        startButton.isHidden = false
        lockPanels()
    }
    
    func processNextRound () {
        startNextRound()
    }
    
    func startNextRound () {
        currentNoteItemPlayed = 0

        lockPanels()
        panelSequence += [Int(arc4random_uniform(numberOfPanels))]

        print(panelSequence)
        
        noteCount = panelSequence.count
        currentNoteItemInput = 0

        startButton.isHidden = true
        
        //        MARK: TODO: use SwiftyTimer
        startTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playSequence), userInfo: nil, repeats: true)
    }
    
    func startGame () {
        panelSequence = []
//        panelSequence = [1,0,3,2,1,1,2,0]
        currentNoteItemPlayed = 0
        
        userMessage.isHidden = true
        processNextRound()
    }

    @objc func playSequence () {
        currentNote = panelSequence[currentNoteItemPlayed]
        lightPanel(currentNote)

        currentNoteItemPlayed += 1
        if currentNoteItemPlayed >= noteCount {
            startTimer.invalidate()
            print ("Sequence done")

            moveTimer = Timer.scheduledTimer(timeInterval: allowedDelay, target: self, selector: #selector(missedMove), userInfo: nil, repeats: false)
            prepareForInput()
        }

        offTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(dimPanels), userInfo: nil, repeats: false)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        startGame()
    }
    
    @IBAction func handleGreenPress (_ sender: UILongPressGestureRecognizer) {
        handlePressedPanel(sender, panelNumber: 0)
    }
    
    @IBAction func handleRedPress(_ sender: UILongPressGestureRecognizer) {
        handlePressedPanel(sender, panelNumber: 1)
    }
    
    @IBAction func handleYellowPress(_ sender: UILongPressGestureRecognizer) {
        handlePressedPanel(sender, panelNumber: 2)
    }
    @IBAction func handleBluePress(_ sender: UILongPressGestureRecognizer) {
        handlePressedPanel(sender, panelNumber: 3)
    }
}
