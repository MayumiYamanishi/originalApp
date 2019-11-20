//
//  HomeViewController.swift
//  originalApp
//
//  Created by mayumi yamanishi on 2019/10/07.
//  Copyright © 2019 mayumi yamanishi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
//    var blockArray: [String] = []
    var observing = false // databaseのobserveEventの登録状態を表す

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell") // register: 登録, dequeue: キューからデータを取り出す
        
        // テーブル行の高さをAutoLayoutで自動調整
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定
        // 高さ概算値＝「縦横比1：1のUIImageViewの高さ（＝画面幅）」＋「いいねボタン、キャプションラベル、その他余白の高さの合計概算（=100pt）」
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
        // ディスクの永続性　アプリのデータはデバイスのローカルに書き込まれる
        Database.database().isPersistenceEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                
                // 要素追加（開始）
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する　①（開始）
                let postRef = Database.database().reference().child(Const.PostPath) // データベース呼び出し
                
                postRef.observe(.childAdded, with: { snapshot in
                    // PostDataクラスを生成して受け取ったデータを設定
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid) // postDataの中にでDBのデータが入っている
                        
//                         ブロックリストに値が入っているとき
//                        if self.blockArray.count > 0 {
//                        for blockUid in self.blockArray {   // ブロックリストを入れた配列をまわす
//                            if blockUid != postData.uid { // ブロックリストの排除条件
                                self.postArray.insert(postData, at: 0) // postArray(セルを入れる配列)の中にpostDataのデータを挿入
                                self.tableView.reloadData() // TableViewを再表示する
//                            }
//                        }
//                    }
                        
                        
                        // ブロックリストに値が入っていないとき
//                        if self.blockArray.count == 0 {
//                                    self.postArray.insert(postData, at: 0) // postArray(セルを入れる配列)の中にpostDataのデータを挿入
//                                    self.tableView.reloadData() // TableViewを再表示する
//                                }
                
                    }
                })
                // ①（終了）
                
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する　②（開始）
                postRef.observe(.childChanged, with: { snapshot in
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)  // PostDataクラスを生成して受け取ったデータを設定する
//                        for blockUid in self.blockArray {   // ブロックリストの排除条件
//                            if blockUid != postData.uid {   // ブロックリストの排除条件
                        var index: Int = 0  // 保持している配列からidが同じものを探す
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.firstIndex(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
//                            }
//                        }
                    }
                })
                // ②（終了）
                // 要素追加（終了）
                
                observing = true     // databaseのobserveEventが上記コードにより登録されたためtrueとする
            }
        } else {    // テーブルクリアするための条件
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                
                // オブザーバーを削除
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.removeAllObservers()
                
                // databaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])

        // セル内のボタンのアクションをソースコードで設定する
        cell.joinButton.addTarget(self, action: #selector(joinButton(_:forEvent:)), for: .touchUpInside)
        cell.reportButton.addTarget(self, action: #selector(reportButton(_:forEvent:)), for: .touchUpInside)
        cell.blockButton.addTarget(self, action: #selector(blockButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // 参加ボタンタップ時
    @objc func joinButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        SVProgressHUD.showInfo(withStatus: "Joined.")
        
    }
    
    // 通報ボタンタップ時
    @objc func reportButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        let reportViewController = self.storyboard?.instantiateViewController(withIdentifier: "report")
        self.present(reportViewController!, animated: true, completion: nil)
        
    }
    
    // ブロックボタンタップ時
    @objc func blockButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView) // タップした現在のポイントを取得
        let indexPath = tableView.indexPathForRow(at: point) // tableViewの何番目か=indexPath
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        
//        // ブロックリストDBにデータを書き込む
//        let blockRef = Database.database().reference().child(Const.BlockPath)
//
//        //blockArrayが空のとき、データ挿入
//        if self.blockArray.count == 0 {
//            let blockDic = ["uid": postData.uid]
//            blockRef.childByAutoId().setValue(blockDic) // DBに書き込み
//            blockArray.insert(String(postData.uid!), at: self.blockArray.count)
            postArray.remove(at: indexPath!.row)
            self.tableView.reloadData()
//        }
        
//        // ブロックリストに保存されているすべてのuidと、postData.uidが一致しなければ、下記一文を読む
//         if self.blockArray.count > 0 {
//            for blockUid in self.blockArray {   // ブロックリストを入れた配列をまわす
//                if blockUid != postData.uid { // ブロックリストの排除条件
//                    let blockDic = ["uid": postData.uid]
//                    blockRef.childByAutoId().setValue(blockDic)
//                    blockArray.insert(String(postData.uid!), at: self.blockArray.count)
//                    postArray.remove(at: indexPath!.row)
//                    self.tableView.reloadData()
//                }
//            }
//        }
        
    }
    
}
