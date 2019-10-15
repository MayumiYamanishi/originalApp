//
//  EditProfileViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/10.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate {
    
    var image: UIImage! // ここにImageSelectViewControllerで選択された画像が入ってくる
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    @IBAction func tapOnImgeButon(_ sender: Any) {
        
        let imageSelectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
        self.present(imageSelectViewController!, animated: true, completion: nil)
        
    }
    
    @IBAction func tapOnChangeButton(_ sender: Any) {
        
        nameChange()
        
        // user-idの取得
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let postRef = Database.database().reference().child(Const.ProfPath).child(uid)
        var postDic: [String: Any] = [:]
        
        // place change
        if let place = placeTextField.text {
            postDic["place"] = place
        }
        
        // image change
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.5) {
            let imageString = imageData.base64EncodedString(options: .lineLength64Characters)
            postDic["image"] = imageString
        }
        
        postRef.setValue(postDic)
        
        self.view.endEditing(true)
        
        SVProgressHUD.showSuccess(withStatus: "変更しました")
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func taoOnCancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // 名前の変更
    func nameChange() {
        if let name = nameTextField.text {
            if name.isEmpty {
                SVProgressHUD.showError(withStatus: "名前を入力してください。")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "名前が変更できませんでした。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: The setting of [displayName = \(user.displayName!)] was successful.")
                    SVProgressHUD.showSuccess(withStatus: "名前を変更しました。")
                }
            }
        }
    }


}

