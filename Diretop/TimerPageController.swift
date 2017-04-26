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
    
    var speechTime = UserDefaults.standard.integer(forKey: "speechTime")
    var secondsLeftToAlarm = UserDefaults.standard.integer(forKey: "alarmTimeLeft")
    var alarmDuration = UserDefaults.standard.integer(forKey: "alarmDuration")
    
    var timeLeft: Double!
    var initialSpeechTime: Int!
    
    var timerAlert: TimerAlert!
    
    var timer = Timer()
    
    @IBOutlet weak var timerNavBar: UINavigationItem!
    var startButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    var rightButtonsArr = Array<UIBarButtonItem>()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetTimerInfo()
        
        startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(TimerPageController.timerStart(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(TimerPageController.timerPause(_:)))
        enableStartButton()
        
        let timerLabelTap = UITapGestureRecognizer(target: self, action: #selector(TimerPageController.playOrPause(_:)))
        timerLabel.addGestureRecognizer(timerLabelTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        speechTime = UserDefaults.standard.integer(forKey: "speechTime")
        secondsLeftToAlarm = UserDefaults.standard.integer(forKey: "alarmTimeLeft")
        alarmDuration = UserDefaults.standard.integer(forKey: "alarmDuration")
        
        if (timeLeft == Double(initialSpeechTime)) {
            resetTimerInfo()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(_ timer: Timer) {
        timeLeft = timeLeft - 0.1
        
        updateLabel()
        updateProgressBar()
        
        timerAlert.checkAlarm(timeLeft: timeLeft)
        
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
        let timeSpent = Double(initialSpeechTime) - timeLeft
        let progress = Float(timeSpent / Double(initialSpeechTime))
        
        let red = progress >= 0.5 ? 1 : progress * 2.0
        let green = progress <= 0.5 ? 1 : (1.0 - progress) * 2.0
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: 0.0, alpha: 1.0)
        
        progressBar.progressTintColor = color
        progressBar.progress = progress
    }
    
    func playOrPause(_ sender: Any) {
        if (timer.isValid) {
            timerPause(sender)
        } else {
            timerStart(sender)
        }
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
        timerAlert = TimerAlert(pageView: timerPageView, secondsLeft: secondsLeftToAlarm, duration: alarmDuration, alreadyCalled: false)
        
        timeLeft = Double(speechTime)
        initialSpeechTime = speechTime
        
        updateLabel()
        updateProgressBar()
    }
    
    func stopTimerCountdown() {
        timer.invalidate()
        enableStartButton()
    }
}

class TimerAlert {
    var pageView: UIView!
    
    var secondsLeft: Int!
    var duration: Int!
    var alreadyCalled: Bool!
    
    public init(pageView: UIView, secondsLeft: Int, duration: Int, alreadyCalled: Bool) {
        self.pageView = pageView
        self.secondsLeft = secondsLeft
        self.duration = duration
        self.alreadyCalled = alreadyCalled
    }
    
    public func checkAlarm(timeLeft: Double) {
        if (timeLeft <= Double(self.secondsLeft) && self.alreadyCalled == false) {
            self.blinkScreen()
            self.alreadyCalled = true
        }
    }
    
    private func paintScreen(backgroundColor: UIColor){
        pageView.backgroundColor = backgroundColor
    }
    
    private func blinkScreen() {
        var doneBlinks = 0
        
        let redColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(white: 1, alpha: 1)
        
        let fullBlinkDuration = 0.5
        let halfBlinkDuration = fullBlinkDuration / 2.0
        let totalBlinks = Int(floor(Double(Double(duration) / fullBlinkDuration)))
        
        func doBlink(){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
                self.paintScreen(backgroundColor: redColor)
            }, completion: { (true) -> Void in
                UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
                    self.paintScreen(backgroundColor: whiteColor)
                }, completion: { (true) -> Void in
                    doneBlinks = doneBlinks + 1
                    if (doneBlinks < totalBlinks) {
                        doBlink()
                    }
                })
            })
        }
        
        doBlink()
    }
}
