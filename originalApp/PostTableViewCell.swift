//
//  PostTableViewCell.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/09.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPostData(_ postData: PostData) {
        self.titleLabel.text = "\(postData.title!)"
        self.detailLabel.text = "\(postData.detail!)"
        self.placeLabel.text = "\(postData.place!)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = "\(postData.date!)"
    }
    
}
