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
    var timeLeft: Int!
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
        resetAlarmInfo()
        
        startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(TimerPageController.timerStart(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(TimerPageController.timerPause(_:)))
        enableStartButton()
        
        let timerLabelTap = UITapGestureRecognizer(target: self, action: #selector(TimerPageController.playOrPause(_:)))
        timerLabel.addGestureRecognizer(timerLabelTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timerLabel.isUserInteractionEnabled = UserDefaults.standard.bool(forKey: "touchOnTimerLabel")
        
        speechTime = UserDefaults.standard.integer(forKey: "speechTime")
        
        if (timeLeft == initialSpeechTime) {
            resetTimerInfo()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func update(_ timer: Timer) {
        timeLeft = timeLeft - 1
        
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
        let minutes = String(format: "%02d", (timeLeft / 60))
        let seconds = String(format: "%02d", (timeLeft % 60))
        timerLabel.text = minutes + ":" + seconds
    }
    
    func updateProgressBar() {
        let timeSpent = initialSpeechTime - timeLeft
        let progress = Float(Double(timeSpent) / Double(initialSpeechTime))
        
        let red = progress >= 0.5 ? 1 : progress * 2.0
        let green = progress <= 0.5 ? 1 : (1.0 - progress) * 2.0
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: 0.0, alpha: 1.0)
        
        progressBar.progressTintColor = color
        progressBar.progress = progress
    }
    
    @objc func playOrPause(_ sender: Any) {
        if (timer.isValid) {
            timerPause(sender)
        } else {
            timerStart(sender)
        }
    }
    
    @IBAction func timerStart(_ sender: Any) {
        if (timeLeft <= 0) {
            resetTimerInfo()
            resetAlarmInfo()
        }
        
        if (timer.isValid) {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
        enablePauseButton()
    }
    
    @IBAction func timerRestart(_ sender: Any) {
        resetTimerInfo()
        resetAlarmInfo()
        stopTimerCountdown()
    }
    
    @IBAction func timerPause(_ sender: Any) {
        stopTimerCountdown()
    }
    
    func resetTimerInfo() {
        timeLeft = speechTime
        initialSpeechTime = speechTime
        
        updateLabel()
        updateProgressBar()
    }
    
    func resetAlarmInfo() {
        timerAlert = TimerAlert(pageView: self.timerPageView)
    }
    
    func stopTimerCountdown() {
        timer.invalidate()
        enableStartButton()
    }
}

class TimerAlert {
    var pageView: UIView!
    
    public init(pageView: UIView) {
        self.pageView = pageView
    }
    
    public func checkAlarm(timeLeft: Int) {
        let alarmIsActive = UserDefaults.standard.bool(forKey: "alarmIsActive")
        let alarmTimeLeft = UserDefaults.standard.integer(forKey: "alarmTimeLeft")
        
        let shouldTrigger = alarmIsActive
        let reachedTimeToTrigger = (timeLeft == alarmTimeLeft)
        
        if (shouldTrigger && reachedTimeToTrigger) {
            self.blinkScreen(doneBlinks: 0)
        }
    }
    
    private func paintScreen(backgroundColor: UIColor){
        pageView.backgroundColor = backgroundColor
    }
    
    private func blinkScreen(doneBlinks: Int) {
        let alarmDuration = UserDefaults.standard.integer(forKey: "alarmDuration")
        let alarmVibration = UserDefaults.standard.bool(forKey: "alarmVibration")
        
        let redColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(white: 1, alpha: 1)
        let fullBlinkDuration = 0.5
        
        let halfBlinkDuration = fullBlinkDuration / 2.0
        let totalBlinks = Int(floor(Double(Double(alarmDuration) / fullBlinkDuration)))
        
        if (alarmVibration) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
            self.paintScreen(backgroundColor: redColor)
        }, completion: { (true) -> Void in
            UIView.animate(withDuration: halfBlinkDuration, animations: { () -> Void in
                self.paintScreen(backgroundColor: whiteColor)
            }, completion: { (true) -> Void in
                if (doneBlinks < totalBlinks) {
                    self.blinkScreen(doneBlinks: doneBlinks + 1)
                }
            })
        })
    }
}
