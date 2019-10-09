//
//  PostViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        self.detailTextView.delegate = self
        self.placeTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        titleTextField.resignFirstResponder()
        detailTextView.resignFirstResponder()
        placeTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapPost(_ sender: Any) {
        
        let name = Auth.auth().currentUser?.displayName
        let date = datePicker.date
        let pickerDate = date.timeIntervalSinceReferenceDate
        
        let postRef = Database.database().reference().child(Const.PostPath)
        let postDic = ["title": titleTextField.text!, "detail": detailTextView.text!, "place": placeTextField.text!, "name": name!, "date": String(pickerDate)]
        postRef.childByAutoId().setValue(postDic)
        
        SVProgressHUD.showSuccess(withStatus: "Posted.")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
