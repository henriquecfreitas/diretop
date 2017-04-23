//
//  TimerConfigController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class TimerConfigController: UIViewController {
    //VARS
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        minutePickerDts.setData(dataToSet: minutesToPick)
        minutePicker.dataSource = minutePickerDts
        minutePicker.delegate = minutePickerDts
        
        secondPickerDts.setData(dataToSet: secondsToPick)
        secondPicker.dataSource = secondPickerDts
        secondPicker.delegate = secondPickerDts
        
        let minutes = (appDelegate.speechTime / 60)
        setDefaultValueToPickerView(pickerView: minutePicker, arrayToFind: minutesToPick, valueToSet: minutes)
        
        let seconds = (appDelegate.speechTime % 60)
        setDefaultValueToPickerView(pickerView: secondPicker, arrayToFind: secondsToPick, valueToSet: seconds)
        
    }
    
    func setDefaultValueToPickerView (pickerView: UIPickerView, arrayToFind: Array<String>, valueToSet: Int) {
        let rowKey = String(format: "%02d", valueToSet)
        var rowPos = arrayToFind.index(of: rowKey)
        if (rowPos == nil) {
            rowPos = 0
        }
        pickerView.selectRow(rowPos!, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTimerConfig(_ sender: Any) {
        let minutesSet = minutePicker.selectedRow(inComponent: 0)
        let secondsSet = secondPicker.selectedRow(inComponent: 0)
        
        let minutesValue = Int(minutesSet) * 60
        let secondsValue = Int(secondsSet)
        let timeSet = minutesValue + secondsValue
        
        appDelegate.speechTime = timeSet
    }
}
