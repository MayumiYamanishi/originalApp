//
//  SettingViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emaiTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        if let user = user {
            nameTextField.text = user.displayName
        }
    }
    
    @IBAction func tapChangeButton(_ sender: Any) {
        
        // 表示名の変更
        if let name = nameTextField.text {
            if name.isEmpty {
                SVProgressHUD.showError(withStatus: "Enter your name.")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "Failed to get your name.")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: The setting of [displayName = \(user.displayName!)] was successful.")
                    
                    SVProgressHUD.showSuccess(withStatus: "Your name has been set.")
                }
            }
        }
        
        self.view.endEditing(true)
    }
    
    // password reset
    @IBAction func tapOnPassworReset(_ sender: Any) {
        
        let email = emaiTextField.text ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                SVProgressHUD.show(withStatus: "Your new e-mail addresss has been set.")
            }
            SVProgressHUD.showError(withStatus: "Your new e-mail address can't have been set.")
        }
        
    }
    
    @IBAction func tapLogoutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    

}
