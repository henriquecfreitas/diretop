//
//  DelegationsPickerView.swift
//  Diretop
//
//  Created by Henrique on 28/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class DelegationsPickerView: UIViewController {
    //VARS
    var delegationsDts = SimplePickerViewDataSource()
    @IBOutlet weak var delegationsPickerView: UIPickerView!
    @IBOutlet weak var listContainer: UIView!
    var embeddedViewController: ListPageController!
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegationsPickerView.dataSource = delegationsDts
        delegationsPickerView.delegate = delegationsDts
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegationsList = UserDefaults.standard.array(forKey: "delegationsList") as! Array<String>
        delegationsDts.setData(dataToSet: delegationsList)
        updateDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let childViewController = segue.destination as? ListPageController
        if (segue.identifier == "speecherListSegue") {
            self.embeddedViewController = childViewController!
        }
    }
    
    func updateDataSource() {
        delegationsPickerView.dataSource = delegationsDts
        delegationsPickerView.reloadAllComponents()
    }

    @IBAction func addButton(_ sender: Any) {
        let index = delegationsPickerView.selectedRow(inComponent: 0)
        let itenToInsert = delegationsPickerView.delegate?.pickerView!(delegationsPickerView, titleForRow: index, forComponent: 0)!
        
        if (itenToInsert?.isEmpty == false){
            embeddedViewController.dataSource.addItenToDts(iten: itenToInsert!)
            embeddedViewController.updateDataSource()
        }
    }
    
}
