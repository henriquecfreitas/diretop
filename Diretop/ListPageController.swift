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
    var dataSource = SimpleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listTableView.tableFooterView = UIView()
        updateDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDataSource() {
        listTableView.dataSource = dataSource
        listTableView.reloadData()
    }
    
    @IBAction func addItenToDts(_ sender: Any) {
        dataSource.addItenToDts(iten: "a")
        updateDataSource()
    }
}
