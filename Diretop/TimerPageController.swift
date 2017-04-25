//
//  TimerPageController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerPageController: UIViewController {
    //VARS
    @IBOutlet var timerPageView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var speechTime = 0
    var timeLeft: Double = 0.0
    
    var timerAlertConfig = TimerAlertConfig()
    
    var timer = Timer()
    
    @IBOutlet weak var timerNavBar: UINavigationItem!
    var startButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var rightButtonsArr = Array<UIBarButtonItem>()
    
    @IBOutlet weak var progressBar: UIProgressView!
    var progress: Float = 0.0
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speechTime = appDelegate.speechTime
        timeLeft = Double(speechTime)
        
        updateLabel()
        updateProgressBar()
        
        startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(TimerPageController.timerStart(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(TimerPageController.timerPause(_:)))
        enableStartButton()
        progressBar.progress = 0.0
        
        timerAlertConfig = TimerAlertConfig(pageView: timerPageView, secondsLeft: 5.0, totalBlinks: 3, duration: 2.0, alreadyCalled: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(_ timer: Timer) {
        timeLeft = timeLeft - 0.1
        
        updateLabel()
        updateProgressBar()
        
        if (timeLeft <= timerAlertConfig.secondsLeft && timerAlertConfig.alreadyCalled == false) {
            timerAlertConfig.blinkScreen()
            timerAlertConfig.alreadyCalled = true
        }
        
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
    func updateProgressBar() {
        let timeSpent = Double(speechTime) - timeLeft
        progress = Float(timeSpent / Double(speechTime))
        
        let red = progress >= 0.5 ? 1 : progress * 2.0
        let green = progress <= 0.5 ? 1 : (1.0 - progress) * 2.0
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: 0.0, alpha: 1.0)
        
        progressBar.progressTintColor = color
        progressBar.progress = progress
    }
    
    @IBAction func timerStart(_ sender: Any) {
        if (timeLeft <= 0) {
            resetTimerInfo()
        }
        
        if (timer.isValid) {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
        enablePauseButton()
    }
    
    @IBAction func timerRestart(_ sender: Any) {
        resetTimerInfo()
        stopTimerCountdown()
    }
    
    @IBAction func timerPause(_ sender: Any) {
        stopTimerCountdown()
    }
    
    func resetTimerInfo() {
        timerAlertConfig.alreadyCalled = false
        timeLeft = Double(speechTime)
        
        updateLabel()
        updateProgressBar()
    }
    
    func stopTimerCountdown() {
        timer.invalidate()
        enableStartButton()
    }
}

class TimerAlertConfig {
    var pageView = UIView().self
    
    var secondsLeft: Double = 0.0
    var totalBlinks: Int = 0
    var duration: Double = 0.0
    var alreadyCalled: Bool = false
    
    public init(){
    }
    
    public init(pageView: UIView, secondsLeft: Double, totalBlinks: Int, duration: Double, alreadyCalled: Bool) {
        self.pageView = pageView
        self.secondsLeft = secondsLeft
        self.totalBlinks = totalBlinks
        self.duration = duration
        self.alreadyCalled = alreadyCalled
    }
    
    public func paintScreen(backgroundColor: UIColor){
        self.pageView.backgroundColor = backgroundColor
    }
    
    public func blinkScreen() {
        var doneBlinks = 0
        
        let redColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(white: 1, alpha: 1)
        let halfBlinkDuration = duration / Double(totalBlinks) / 2.0
        
        func doBlink(){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
                self.paintScreen(backgroundColor: redColor)
            }, completion: { (true) -> Void in
                UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
                    self.paintScreen(backgroundColor: whiteColor)
                }, completion: { (true) -> Void in
                    doneBlinks = doneBlinks + 1
                    if (doneBlinks < self.totalBlinks) {
                        doBlink()
                    }
                })
            })
        }
        
        doBlink()
    }
}
