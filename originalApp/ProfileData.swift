//
//  ProfileData.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/11.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase

class ProfileData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var place: String?
    
    // 変数宣言
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.place = valueDictionary["place"] as? String
        
    }

}
