//
//  LoginViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func taoOnTOS(_ sender: Any) {
        
        let tosViewController = self.storyboard?.instantiateViewController(withIdentifier: "TOS")
        self.present(tosViewController!, animated: true, completion: nil)
        
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        if let address = mailTextField.text, let passwd = passwdTextField.text {
            if address.isEmpty || passwd.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: passwd) { user, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                SVProgressHUD.dismiss()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapCreateAccount(_ sender: Any) {
        
        if let address = mailTextField.text, let passwd = passwdTextField.text, let name = nameTextField.text {
            
            //アドレスとパスワードと表示名のいずれかが入力されていないときの処理
            if address.isEmpty {
                print("DEBUG_PRINT: Please enter your email address.")
                SVProgressHUD.showError(withStatus: "メールアドレスを入力してください")
                return
            }
            else if passwd.isEmpty {
                print("DEBUG_PRINT: Please enter your password.")
                SVProgressHUD.showError(withStatus: "パスワードを入力してください")
                return
            }
            else if name.isEmpty {
                print("DEBUG_PRINT: Please enter your name.")
                SVProgressHUD.showError(withStatus: "名前を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: passwd) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
            
            // 表示名を設定する
            let user = Auth.auth().currentUser // ここにnilが入っているので、下から先が読まれない
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        // プロフィールの更新でエラーが発生
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    SVProgressHUD.dismiss()
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
