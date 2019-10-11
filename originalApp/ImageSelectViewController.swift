//
//  ImageSelectViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/10.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapOnLibrary(_ sender: Any) {
        
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapOnCamera(_ sender: Any) {
        
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // 写真を撮影、選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if info[.originalImage] != nil {
            // 撮影、選択された画像を取得
            let image = info[.originalImage] as! UIImage
            
            // 画面に戻る
            let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfileViewController
            editProfileViewController.image = image
            
            dismiss(animated: true, completion: nil)
            
            self.present(editProfileViewController, animated: true, completion:  nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
