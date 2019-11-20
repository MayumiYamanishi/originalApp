//
//  BlockListData.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/11/15.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase

class BlockListData: NSObject {
    
    var uid: String?
    
    init(snapshot: DataSnapshot, myId: String) {
        
        let valueDictionary = snapshot.value as! [String: Any]
        self.uid = valueDictionary["uid"] as? String
        
    }

}
