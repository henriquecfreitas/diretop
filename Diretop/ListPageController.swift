//
//  ListPageController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class ListPageController: UITableViewController {
    
    @IBOutlet var listTableView: UITableView!
    var dataSource: SimpleTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewIdentifier = self.restorationIdentifier!
        dataSource = SimpleTableViewDataSource(tableKey: viewIdentifier)
        
        listTableView.tableFooterView = UIView()
        updateDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "speecherListSegue2") {
            let speechListInputViewController = segue.destination as! SpeechListInputController
            speechListInputViewController.speechListPageController = self
        }
    }
    
    // Child Delegate
    func dataChanged(str: String) {
        // Do whatever you need with the data
    }
    
    func updateDataSource() {
        listTableView.dataSource = dataSource
        listTableView.reloadData()
    }
}
