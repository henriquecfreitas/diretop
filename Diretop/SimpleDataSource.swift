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
    
    public func removeItenFromDts(index: Int){
        data.remove(at: index)
    }
    
    public func setData(dataToSet: Array<String>){
        data = dataToSet
    }
}

class SimpleTableViewDataSource: SimpleDataSource, UITableViewDataSource {
    var tableKey: String!
    
    init(tableKey: String) {
        super.init()
        self.tableKey = tableKey
        self.setData(dataToSet: getPersistedData())
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index = indexPath.item
        cell.textLabel?.text = data[index]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let index = indexPath.item
            self.removeItenFromDts(index: index)
            tableView.reloadData()
        }
    }
    
    override func addItenToDts(iten: String) {
        super.addItenToDts(iten: iten)
        persistData()
    }
    
    override func removeItenFromDts(index: Int) {
        super.removeItenFromDts(index: index)
        persistData()
    }
    
    public func persistData() {
        UserDefaults.standard.set(data, forKey: tableKey)
    }
    
    public func getPersistedData() -> Array<String> {
        let data = UserDefaults.standard.array(forKey: tableKey) as! Array<String>
        return data
    }
}

class SimplePickerViewDataSource: SimpleDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    func onRowSelected() {}
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onRowSelected()
    }
}
