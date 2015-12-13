//
//  ViewController.swift
//  retro-calc
//
//  Created by James on 12/12/15.
//  Copyright © 2015 The Infinite Actuary. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation {
        case Multiply
        case Divide
        case Add
        case Subtract
        case Equal
    }
    
    var audioPlayer = AVAudioPlayer()
    var userInTheMiddleOfEnteringNumber = false
    var operands = [Double]()
    var currentOperation = Operation.Equal
    
    @IBOutlet weak var displayLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup sound
        let btnSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("btn", ofType: "wav")!)

        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: btnSoundURL)
        } catch {
            print(error)
        }
        
        audioPlayer.prepareToPlay()
    }
    
    @IBAction func numberButtonPressed(btn: AnyObject) {
        playSound()
        
        if !userInTheMiddleOfEnteringNumber  {
            // first number can't be 0
            if btn.tag != 0 {
                displayLabel.text = "\(btn.tag)"
                userInTheMiddleOfEnteringNumber = true
            }
            
            // if current operation is equal then clear the operands 
            if currentOperation == Operation.Equal {
                operands.removeAll()
            }
        } else {
            displayLabel.text = displayLabel.text! + "\(btn.tag)"
        }

    }
    
    @IBAction func multiplyButtonPressed(sender: AnyObject) {
        performOperation(Operation.Multiply)
    }
    
    @IBAction func divideButtonPressed(sender: AnyObject) {
        performOperation(Operation.Divide)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        performOperation(Operation.Add)
    }
    
    @IBAction func subtractButtonPressed(sender: AnyObject) {
        performOperation(Operation.Subtract)
    }
    
    @IBAction func equalButtonPressed(sender: AnyObject) {
        performOperation(Operation.Equal)
    }
    
    func performOperation (op: Operation) {
        playSound()
        
        // only addpend the display once
        // this guards against cases where user keeps hitting operations
        if userInTheMiddleOfEnteringNumber {
            operands.append(Double(displayLabel.text!)!)
        }
        
        // if at least two operators then do some math
        if operands.count > 1 {
            let leftOperand = operands.first!
            operands.removeFirst()
            
            let rightOperand = operands.first!
            operands.removeFirst()
            
            var answer = 0.0
            if currentOperation == Operation.Multiply {
                answer = leftOperand * rightOperand
            } else if currentOperation == Operation.Divide {
                answer = leftOperand / rightOperand
            } else if currentOperation == Operation.Add {
                answer = leftOperand + rightOperand
            } else if currentOperation == Operation.Subtract {
                answer = leftOperand - rightOperand
            }
            
            // add the answer back to the front of the array
            operands.insert(answer, atIndex: 0)
            displayLabel.text = "\(answer)"
        }
        
        currentOperation = op
        userInTheMiddleOfEnteringNumber = false
    }
    
    
    func playSound() {
        if audioPlayer.playing {
            audioPlayer.stop()
        }
        
        audioPlayer.play()
    }


}

