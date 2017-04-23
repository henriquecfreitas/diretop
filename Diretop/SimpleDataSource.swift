//
//  SimpleDataSource.swift
//  Diretop
//
//  Created by Henrique on 22/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class SimpleDataSource: NSObject {
    var data = Array<String>()
    
    public func addItenToDts(iten: String){
        data.append(iten)
    }
    
    public func setData(dataToSet: Array<String>){
        data = dataToSet
    }
}

class SimpleTableViewDataSource: SimpleDataSource, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index = indexPath.item
        cell.textLabel?.text = data[index]
        return cell
    }
}

class SimplePickerViewDataSource: SimpleDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}