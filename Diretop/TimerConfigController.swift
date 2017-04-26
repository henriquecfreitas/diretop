//
//  TimerConfigController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class TimerConfigPageController: UITableViewController {
    //VARS
    @IBOutlet weak var speechTimeLabel: UILabel!
    @IBOutlet weak var alarmTimeLeftLabel: UILabel!
    @IBOutlet weak var alarmDurationLabel: UILabel!
    
    //FUNCS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let speechTime = intToTimeStamp(time: UserDefaults.standard.integer(forKey: "speechTime"))
        speechTimeLabel.text = speechTime
        
        let alarmTimeLeft = intToTimeStamp(time: UserDefaults.standard.integer(forKey: "alarmTimeLeft"))
        alarmTimeLeftLabel.text = alarmTimeLeft
        
        let alarmDuration = intToTimeStamp(time: UserDefaults.standard.integer(forKey: "alarmDuration"))
        alarmDurationLabel.text = alarmDuration
    }
    
    func intToTimeStamp(time: Int) -> String {
        let minutes = String(format: "%02d", (time / 60))
        let seconds = String(format: "%02d", (time % 60))
        return minutes + ":" + seconds
    }
}

class TimerConfigController: UIViewController {
    //VARS
    var setUpTime: Int = 0
    var viewIdentifier: String = ""
    
    @IBOutlet weak var minutePicker: UIPickerView!
    var minutePickerDts = SimplePickerViewDataSource()
    let minutesToPick = Array(0...59).map { String(format: "%02d", $0)}
    
    @IBOutlet weak var secondPicker: UIPickerView!
    var secondPickerDts = SimplePickerViewDataSource()
    let secondsToPick = Array(0...59).map { String(format: "%02d", $0)}
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewIdentifier = self.restorationIdentifier!
        setUpTime = UserDefaults.standard.integer(forKey: viewIdentifier)
        
        minutePickerDts.setData(dataToSet: minutesToPick)
        minutePickerDts.onRowSelected = saveTimerConfig
        minutePicker.dataSource = minutePickerDts
        minutePicker.delegate = minutePickerDts
        
        secondPickerDts.setData(dataToSet: secondsToPick)
        secondPickerDts.onRowSelected = saveTimerConfig
        secondPicker.dataSource = secondPickerDts
        secondPicker.delegate = secondPickerDts
        
        let minutes = (setUpTime / 60)
        setDefaultValueToPickerView(pickerView: minutePicker, arrayToFind: minutesToPick, valueToSet: minutes)
        
        let seconds = (setUpTime % 60)
        setDefaultValueToPickerView(pickerView: secondPicker, arrayToFind: secondsToPick, valueToSet: seconds)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaultValueToPickerView (pickerView: UIPickerView, arrayToFind: Array<String>, valueToSet: Int) {
        let rowKey = String(format: "%02d", valueToSet)
        var rowPos = arrayToFind.index(of: rowKey)
        if (rowPos == nil) {
            rowPos = 0
        }
        pickerView.selectRow(rowPos!, inComponent: 0, animated: false)
    }
    
    func saveTimerConfig() {
        let minutesSet = minutePicker.selectedRow(inComponent: 0)
        let secondsSet = secondPicker.selectedRow(inComponent: 0)
        
        let minutesValue = Int(minutesSet) * 60
        let secondsValue = Int(secondsSet)
        setUpTime = minutesValue + secondsValue
        
        UserDefaults.standard.set(setUpTime, forKey: viewIdentifier)
    }
}
