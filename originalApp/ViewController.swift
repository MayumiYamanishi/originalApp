//
//  ViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTab()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    func setupTab() {
        // 画像のファイル名を指定してESTabBarControllerを作成
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor.rgba(red: 30, green: 144, blue: 255, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tabBarController.selectionIndicatorHeight = 3
        
        // 作成したESTabBarControllerを親のViewControllerに追加
        addChild(tabBarController) // 子のtabBarControllerを親のViewControllerに追加
        let tabBarView = tabBarController.view! // tabBarViewを生成
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        // translatesAutoresizingMaskIntoConstraints = false: 制約を自分で適用
        //                                              true: 自動で制約を適用
        view.addSubview(tabBarView) //subviewとしてviewに追加
        let safeArea = view.safeAreaLayoutGuide // The layout guide representing the portion of your view that is unobscured by bars and other content.
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        tabBarController.didMove(toParent: self) // Tells you when the scene is presented by a view.
        
        // タブをタップしたときに表示するViewControllerを作成
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        tabBarController.setAction({
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post")
            self.present(postViewController!, animated: true, completion: nil)
        }, at: 1)
        
    }


}

