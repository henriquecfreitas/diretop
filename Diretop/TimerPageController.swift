//
//  TimerPageController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class TimerPageController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var timerLabel: UILabel!
    var timeSet = 60
    var timeLeft = 60
    var timer = Timer()
    
    func update(_ timer: Timer) {
        timeLeft = timeLeft - 1
        let minutes = String(format: "%02d", (timeLeft / 60))
        let seconds = String(format: "%02d", (timeLeft % 60))
        timerLabel.text = minutes + ":" + seconds
        if(timeLeft <= 0) {
            timer.invalidate()
        }
    }
    
    @IBAction func timerStart(_ sender: Any) {
        if (timer.isValid) {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @IBAction func timerRestart(_ sender: Any) {
        timer.invalidate()
        timeLeft = timeSet
        let minutes = String(format: "%02d", (timeLeft / 60))
        let seconds = String(format: "%02d", (timeLeft % 60))
        timerLabel.text = minutes + ":" + seconds
    }
    
    @IBAction func timerPause(_ sender: Any) {
        if (timer.isValid) {
            timer.invalidate()
        }
    }
}
