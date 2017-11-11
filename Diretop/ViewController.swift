//
//  ViewController.swift
//  Diretop
//
//  Created by Henrique on 21/04/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var bottomConstraintValue: CGFloat = 0

    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var inputText: UITextField!
    
    var embeddedViewController: ListPageController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let childViewController = segue.destination as? ListPageController
        if (segue.identifier == "delegationsListEmbedSegue") {
            self.embeddedViewController = childViewController!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomConstraintValue = bottomConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        listContainer.addGestureRecognizer(tap)
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let tabBar = self.tabBarController?.tabBar
        let tabBarHeight = tabBar?.frame.size.height
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = self.bottomConstraintValue + keyboardFrame.size.height - tabBarHeight!
        })
    }
    @objc func keyboardHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = self.bottomConstraintValue
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let itenToInsert = inputText.text
        if (itenToInsert?.isEmpty == false){
            embeddedViewController.dataSource.addItenToDts(iten: itenToInsert!)
            embeddedViewController.updateDataSource()
            inputText.text = ""
        }
    }

}
