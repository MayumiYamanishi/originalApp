//
//  ReportViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/30.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportViewController: UIViewController {

    @IBAction func tapOnReportButton(_ sender: Any) {
        
        SVProgressHUD.showInfo(withStatus: "送信しました")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
