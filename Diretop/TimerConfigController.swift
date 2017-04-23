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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTimerConfig(_ sender: Any) {
        appDelegate.speechTime = 90
    }
}
