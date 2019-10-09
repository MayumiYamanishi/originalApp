//
//  PostData.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/09.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String?
    var title: String?
    var detail: String?
    var place: String?
    var date: Date?
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        let valueDictionary = snapshot.value as! [String: Any]
        self.title = valueDictionary["title"] as? String
        self.detail = valueDictionary["detail"] as? String
        self.place = valueDictionary["place"] as? String
        let time = valueDictionary["date"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }

}
