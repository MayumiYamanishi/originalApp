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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func taoOnProdileEdit(_ sender: Any) {
        // プロフィールを表示するイベントに移動
        let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile")
        self.present(editProfileViewController!, animated: true, completion: nil)
    }
    
    @IBAction func tapOnWillJoinEvent(_ sender: Any) {
        // 参加イベントを表示するページに移動
        let joinEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "JoinEvent")
        self.present(joinEventViewController!, animated: true, completion: nil)
    }
    
    @IBAction func tapLogoutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    

}
