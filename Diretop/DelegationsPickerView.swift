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
    
    @IBOutlet var speechListView: UIView!
    
    var delegationsDts = SimplePickerViewDataSource()
    @IBOutlet weak var delegationsPickerView: UIPickerView!
    @IBOutlet weak var listContainer: UIView!
    var embeddedViewController: ListPageController!
    
    @IBOutlet weak var showHideDelegationsButton: UIButton!
    @IBOutlet weak var delegationsStackView: UIStackView!
    @IBOutlet weak var hideDelegationsConstraint: NSLayoutConstraint!
    
    var constraintShow: NSLayoutConstraint!
    var constraintHide: NSLayoutConstraint!
    
    //FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegationsPickerView.dataSource = delegationsDts
        delegationsPickerView.delegate = delegationsDts
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideDelegations))
        tap.cancelsTouchesInView = false
        listContainer.addGestureRecognizer(tap)
        
        createBorder()
        createConstraints()
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
    
    func createBorder(){
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor(white: 0.7, alpha: 1).cgColor
        
        let buttonMeasures = showHideDelegationsButton.frame.size
        
        let borderSize = CGFloat(1.0)
        
        let borderX = CGFloat(0.0)
        let borderY = buttonMeasures.height - borderSize
        let borderWidth = buttonMeasures.width
        let borderHeight = borderSize
        
        let borderFrame = CGRect(x: borderX, y: borderY, width: borderWidth, height: borderHeight)
        bottomBorder.frame = borderFrame
        
        showHideDelegationsButton.layer.addSublayer(bottomBorder)
    }
    
    func createConstraints(){
        let constItem = hideDelegationsConstraint.firstItem
        let constAtt = hideDelegationsConstraint.firstAttribute
        let constRelBy = hideDelegationsConstraint.relation
        let constSecItem = hideDelegationsConstraint.secondItem
        let constMult = hideDelegationsConstraint.multiplier
        let constCons = hideDelegationsConstraint.constant
        
        let constShowAtt = NSLayoutAttribute.bottom
        let constHideAtt = NSLayoutAttribute.top
        
        constraintShow = NSLayoutConstraint(item: constItem, attribute: constAtt, relatedBy: constRelBy, toItem: constSecItem, attribute: constShowAtt, multiplier: constMult, constant: constCons)
        constraintHide = NSLayoutConstraint(item: constItem, attribute: constAtt, relatedBy: constRelBy, toItem: constSecItem, attribute: constHideAtt, multiplier: constMult, constant: constCons)
    
        speechListView.removeConstraint(hideDelegationsConstraint)
        speechListView.addConstraint(constraintHide)
        
        delegationsStackView.isHidden = true
    }
    
    func updateDataSource() {
        delegationsPickerView.dataSource = delegationsDts
        delegationsPickerView.reloadAllComponents()
    }
    
    @IBAction func showHideDelegations(_ sender: Any) {
        if (delegationsStackView.isHidden) {
            showDelegations()
        } else {
            hideDelegations()
        }
    }
    
    func showDelegations(){
        speechListView.removeConstraint(constraintHide)
        speechListView.addConstraint(constraintShow)
        
        delegationsStackView.isHidden = false
    }
    
    func hideDelegations(){
        speechListView.removeConstraint(constraintShow)
        speechListView.addConstraint(constraintHide)
        
        delegationsStackView.isHidden = true
    }
    
    

    @IBAction func addButton(_ sender: Any) {
        let index = delegationsPickerView.selectedRow(inComponent: 0)
        let itenToInsert = delegationsPickerView.delegate?.pickerView!(delegationsPickerView, titleForRow: index, forComponent: 0)!
        
        if (verifyDelegationToSpeecherList(delegation: itenToInsert!)){
            embeddedViewController.dataSource.addItenToDts(iten: itenToInsert!)
            embeddedViewController.updateDataSource()
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
