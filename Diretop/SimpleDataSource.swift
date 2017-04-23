//
//  SimpleDataSource.swift
//  Diretop
//
//  Created by Henrique on 22/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class SimpleDataSource: NSObject, UITableViewDataSource {
    var data = Array<String>()
    
/*    public init(dataSource: Array<String>) {
        data = dataSource
    }*/
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index = indexPath.item
        cell.textLabel?.text = data[index]
        return cell
    }
    
    public func addItenToDts(iten: String){
        data.append(iten)
    }
}
