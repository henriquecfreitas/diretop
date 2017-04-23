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
    var timeLeft = 0
    var timer = Timer()
    
    @IBOutlet weak var minutePicker: UIPickerView!
    var minutePickerDts = SimplePickerViewDataSource()
    let minutesToPick = Array(0...59).map { String(format: "%02d", $0)}
    
    @IBOutlet weak var secondPicker: UIPickerView!
    var secondPickerDts = SimplePickerViewDataSource()
    let secondsToPick = Array(0...59).map { String(format: "%02d", $0)}
    
    @IBOutlet weak var timerNavBar: UINavigationItem!
    var startButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var rightButtonsArr = Array<UIBarButtonItem>()
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speechTime = appDelegate.speechTime
        timeLeft = appDelegate.speechTime
        
        minutePickerDts.setData(dataToSet: minutesToPick)
        minutePicker.dataSource = minutePickerDts
        minutePicker.delegate = minutePickerDts
        
        secondPickerDts.setData(dataToSet: secondsToPick)
        secondPicker.dataSource = secondPickerDts
        secondPicker.delegate = secondPickerDts
        
        startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(TimerPageController.timerStart(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(TimerPageController.timerPause(_:)))
        timerNavBar.rightBarButtonItems![0] = startButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        timerNavBar.rightBarButtonItems![0] = pauseButton
    }
    
    @IBAction func timerRestart(_ sender: Any) {
        timer.invalidate()
        timeLeft = speechTime
        let minutes = String(format: "%02d", (timeLeft / 60))
        let seconds = String(format: "%02d", (timeLeft % 60))
        timerLabel.text = minutes + ":" + seconds
    }
    
    @IBAction func timerPause(_ sender: Any) {
        if (timer.isValid) {
            timer.invalidate()
        }
        timerNavBar.rightBarButtonItems![0] = startButton
    }
}
