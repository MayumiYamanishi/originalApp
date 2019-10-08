//
//  LoginViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func tapLogin(_ sender: Any) {
        

        
    }
    
    @IBAction func tapCreateAccount(_ sender: Any) {
        
        if let address = mailTextField.text, let passwd = passwdTextField.text, let displayName = nameTextField.text {
            
            //アドレスとパスワードと表示名のいずれかが入力されていないときの処理
            if address.isEmpty {
                print("DEBUG_PRINT: Please enter your email address.")
            }
            else if passwd.isEmpty {
                print("DEBUG_PRINT: Please enter your password.")
            }
            else if displayName.isEmpty {
                print("DEBUG_PRINT: Please enter your name.")
            }
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: passwd) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
            }
            
            // 表示名を設定する
            let user = Auth.auth().currentUser // ここにnilが入っているので、下から先が読まれない
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        // プロフィールの更新でエラーが発生
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
