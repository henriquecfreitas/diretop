//
//  TimerPageController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class TimerPageController: UIViewController {
    //VARS
    @IBOutlet weak var timerLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var speechTime = 0
    var timeLeft = 0.0
    var timer = Timer()
    
    @IBOutlet weak var timerNavBar: UINavigationItem!
    var startButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var rightButtonsArr = Array<UIBarButtonItem>()
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speechTime = appDelegate.speechTime
        timeLeft = Double(speechTime)
        
        updateLabel()
        
        startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(TimerPageController.timerStart(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(TimerPageController.timerPause(_:)))
        enableStartButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(_ timer: Timer) {
        timeLeft = timeLeft - 0.1
        updateLabel()
        if(timeLeft <= 0) {
            timer.invalidate()
            enableStartButton()
            
        }
    }
    
    func enableStartButton() {
        timerNavBar.rightBarButtonItems![0] = startButton
    }
    func enablePauseButton() {
        timerNavBar.rightBarButtonItems![0] = pauseButton
    }
    
    func updateLabel () {
        let intTimeLeft = Int(ceil(timeLeft))
        let minutes = String(format: "%02d", (intTimeLeft / 60))
        let seconds = String(format: "%02d", (intTimeLeft % 60))
        timerLabel.text = minutes + ":" + seconds
    }
    
    @IBAction func timerStart(_ sender: Any) {
        if (timeLeft == 0) {
            timeLeft = Double(speechTime)
        }
        
        if (timer.isValid) {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
        enablePauseButton()
    }
    
    @IBAction func timerRestart(_ sender: Any) {
        timer.invalidate()
        timeLeft = Double(speechTime)
        updateLabel()
        enableStartButton()
    }
    
    @IBAction func timerPause(_ sender: Any) {
        if (timer.isValid) {
            timer.invalidate()
        }
        enableStartButton()
    }
}
