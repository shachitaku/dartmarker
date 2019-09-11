//
//  ViewController.swift
//  dartmarker
//
//  Created by Takumi Kimura on 2018/08/06.
//  Copyright © 2018年 com.takumi0kimura. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate {

    private var magnifyView: MagnifyView?
    @IBOutlet weak var myView: UIView!
   
    @IBOutlet var captionTableView: UITableView!
    var captionArray = [NCMBObject]()
 
    override func viewWillAppear(_ animated: Bool) {
                          loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()

        self.myView = UIView()
        self.myView?.backgroundColor = UIColor(white: 0x2E2E2E, alpha: 1.0)
        
        self.view.backgroundColor = UIColor.black
        // ->背景色をkuro色に変更する
        
        //↓テーブル用
        //データ・ソースメソッドをこのファイル内で処理しますよ
        captionTableView.delegate = self
        captionTableView.dataSource = self
        
        //メモ一覧の不要な線を消す。
        // captionTableView.tableFooterView = UIView()
        
 /*       //カスタムセルの登録
      let nib = UINib(nibName: "ResultsTableViewCell", bundle: Bundle.main)
        captionTableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    */
    //ここからテーブル用
    
    
    }

    // 1. TableViewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captionArray.count
        
    }
    
    // 2. TableViewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
     cell.textLabel?.text = captionArray[indexPath.row].object(forKey: "Distance") as? String
        
        // Cellを返す
        return cell
        }
    
    
    func loadData() {
        let query = NCMBQuery(className: "distance")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("error")
            } else {
                self.captionArray = result as! [NCMBObject]
                self.captionTableView.reloadData()
            }
        })
        let trialnum = String(captionArray.count)
        trials.text = trialnum
    }


    
    //ここまでテーブル用
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var label: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                let point = touches.first?.location(in: self.view)
                if magnifyView == nil
                {
                    magnifyView = MagnifyView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                    magnifyView?.viewToMagnify = self.view
                    magnifyView?.setTouchPoint(pt: point!)
                    self.view.addSubview(magnifyView!)
                }
                          loadData()
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let allTouches = event?.allTouches {
            for touch in allTouches {
                let location = touch.location(in: self.view) //一番親のビュー
                Swift.print(location)
                //タップした所の座標をアウトプットする
                
                //let rect = CGRect(x: 0, y: 146, width: 375, height: 375)

                let circleLayer = CAShapeLayer.init()
                let circleFrame = CGRect.init(x: 53, y: 195, width: 280, height: 280)
                circleLayer.frame = circleFrame
                
                // 当たり範囲をターゲットの的と同じにする
                let isContainsPoint = circleFrame.contains(location)
                // タップされた座標が当たり範囲に入ってるか確かめる
                
                
                if isContainsPoint == true {
                // タップされた座標が当たり範囲の中だった場合のみ距離を出す
                let distance = sqrt(pow(location.x - 188,2) + pow(location.y - 336,2))
                Swift.print(distance)
                //ダーツの中心の座標は(188.0, 336.0)
                //距離を中心座標とタップした点座標から求める
                let distanceint = Int(distance)
                label.text = String(distanceint)
                //距離をlabelに表示させる
                    
                let distancetext = String(distanceint)
                
                    let object = NCMBObject(className: "distance")
                    object?.setObject(distancetext, forKey: "Distance")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            //エラーが発生したら
                            print("error")
                        }else {
                            //保存に成功した場合
                            print("success")
                        }
                    
                })
  
                }
               
                let trialnum = String(captionArray.count)
                trials.text = trialnum
                
        if magnifyView != nil
        {
            magnifyView?.removeFromSuperview()
            magnifyView = nil
        }
    }
            
        }
                          loadData()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view)
        magnifyView?.setTouchPoint(pt: point!)
        magnifyView?.setNeedsDisplay()
    }
    
    

    @IBOutlet var trials: UILabel!
    
    @IBAction func addImage(sender: UITapGestureRecognizer) {
        
        // UIImageView(画像)作成
        let circle = UIImageView(image: UIImage(named: "circle"))  /* named:"画像名" */
        
        // UIImageViewの中心座標をタップされた位置に設定
        circle.center = sender.location(in: self.view)
        
        // UIImageView(画像)を追加
        self.view.addSubview(circle)
        
        
        
    }


}
