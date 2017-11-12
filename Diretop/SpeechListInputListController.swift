//
//  SpeechListInputListController.swift
//  Diretop
//
//  Created by Henrique Campos de Freitas on 11/11/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Foundation
import UIKit

class SpeechListInputController: UITableViewController {
    //VARS
    var delegationsDts = SimpleTableViewDataSource(tableKey: "delegationsList", canDelete: false)
    @IBOutlet weak var speechListInputTableView: UITableView!
    
    var speechListPageController: ListPageController!
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        speechListInputTableView.dataSource = delegationsDts
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = self.tableView.cellForRow(at: indexPath)
        let itenToInsert = selectedRow?.textLabel?.text
        
        if (verifyDelegationToSpeecherList(delegation: itenToInsert!)){
            speechListPageController.dataSource.addItenToDts(iten: itenToInsert!)
            speechListPageController.updateDataSource()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func verifyDelegationToSpeecherList(delegation: String) -> Bool{
        if (delegation.isEmpty) {
            return false
        } else {
            let speechList = UserDefaults.standard.array(forKey: "speechList") as! Array<String>;
            let ret = (speechList.index(of: delegation) == nil);
            return ret
        }
    }
    
}
