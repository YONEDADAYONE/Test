//
//  ViewController.swift
//  本番
//
//  Created by 米田大弥 on 2018/06/23.
//  Copyright © 2018年 hiroya. All rights reserved.
//

import UIKit
import UserNotifications//通知フレームワーク追加
import AVKit//AVKitフレームワークに追加


class ViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testPickerView: UIPickerView!
    @IBOutlet weak var StartButton: UIButton!
    
    
    var timer:Timer = Timer()
    var count:Int = 0
    var gameStartTime:Date = Date()//変化する値を入れるので変数
    var gamePauseTime:Date = Date()//変化する値を入れるので変数
    //    let foregoundDate = Date()
    let backgroundDate = Int(Date().timeIntervalSince1970)
    let foregroundDate = Int(Date().timeIntervalSince1970)
    let start = NSDate()
    var beforeTime:Date = Date()
    let currentTime = NSDate()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    //時分秒のデータ
    var dataList = [ [Int](0...59), [Int](0...59)]
    
    //形を整えるメソッド
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        switch component {
        case 0:
            return 100
        case 1:
            return 50
        default:
            return 30
        }
    }
    //Swift3にアップデートしたらCGRectMakeが使えず、'CGRectMake' is unavailable in Swiftとエラーが出るようになった。を参照
    //CGRectMakeを使える様に関数を付け加える
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    //ライトボタンタップされたら発動.
    @IBAction func setTimerNotification(_ sender: UIButton) {
    
        appDelegate.message = 0
        
        let alert = UIAlertController(
            title: "アプリは起動状態のままでお願いします。", message: "よろしいですか?", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //すでに動いているタイマーは停止する。
            self.timer.invalidate()
            //カウントダウンする秒数を取得する。
            self.count = self.dataList[0][self.testPickerView.selectedRow(inComponent: 0)] * 60
                +  self.dataList[1][self.testPickerView.selectedRow(inComponent: 1)]
            
            
            //1秒周期でcountDownメソッドを呼び出すタイマーを開始する。
            self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(self.countDown), userInfo:nil, repeats:true)
            
            self.setNotificationAftrer(second: self.count)
            
            UIScreen.main.brightness = CGFloat(0.1);//0~1 (1=一番明るい)
            
            //            self.itiji()
            //           self.StartButton.setImage(UIImage(named: "Stop"), for: UIControlState())
            
            //            print(self.StartButton.image)
            //            if self.StartButton == UIImage(named: "Stop") {
            //                print("せいこう")
            //            }

        })
        
        
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    //光タイマーから呼び出されるメソッド(関数)
    @objc func countDown(){

        let message = appDelegate.message
        var mainasu: Int = Int(message!)
        var keisan = count + mainasu
        
        
        //カウントを減らす。
        count -= 1
        
        //カウントダウン状況をラベルに表示
        if(keisan > 0) {
            testLabel.text = "残り\(keisan)秒です。"//ここをいじるはず分ラベルと秒ラベルで操作?
//            print(count,message,keisan)
//        } else if (keisan < 0) {
//            appDelegate.message = 0
//            testLabel.text = "あああ"
//            timer.invalidate()
//            Hikari()
//}
        }else {
            testLabel.text = "カウントダウン終了"
            timer.invalidate()
            //光らせる
            Hikari()
        }
        
    }
    
    //    @objc func countDown(){
    //
    //                //カウントを減らす。
    //                count -= 1
    //
    //                //カウントダウン状況をラベルに表示
    //                if(count >= 60) {
    //                    let minuteCount = count / 60
    //                    testLabel.text = String(minuteCount)
    //                    testLabel.text = "残り\(minuteCount)分\(count)秒です。"
    //                } else if count < 60{
    //                    testLabel.text = String(count)
    //                    testLabel.text = "残り\(count)秒です。"
    //        } else
    //        {
    //                    testLabel.text = "カウントダウン終了"
    //                    timer.invalidate()
    //                    //光らせる
    //                Hikari()
    //                }
    //
    //            }
    
    //自作関数だよ! 一回保留
    func setNotificationAftrer(second:Int) {
        // Notification のインスタンスを作成
        let content = UNMutableNotificationContent()
        
        //通知のタイトル本文の設定
        content.title = "お知らせします"
        content.body = "指定した時刻になりました"
        
        //        //音設定
        content.sound = UNNotificationSound.init(named: "Silent3sec.mp3")
        
        //バックグラウンドだよ
        
        for i in 1...9 {
            //トリガー設定
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second + i), repeats: false)
            
            //リクエスト 復習
            let request = UNNotificationRequest.init(identifier: "ID_AfterSecOnce\(i)", content: content, trigger: trigger)
            
            //通知のセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    
    //光らせる
    func Hikari() {
        
        //アラート表示
        let alert = UIAlertController(
            title: "アラームを止めますか?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //ここに処理を書く
            self.timer.invalidate()
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            device?.torchMode = AVCaptureDevice.TorchMode.off
            self.testLabel.text = "少しお休みしませんか?"
        })
        
        //
        alert.addAction(defaultAction)
        
        //
        present(alert,animated: true,completion: nil)
        
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            try device?.lockForConfiguration()
        } catch {
            print(error)
        }
        device?.torchMode = AVCaptureDevice.TorchMode.on
        //        do {
        //            try device?.lockForConfiguration()
        //        } catch {
        //            print(error)
        //        }
    }
    
    
    @IBAction func CancelButton(_ sender: UIButton) {
        //timerが動いてるなら.
        // TODO: 動いてるけど、条件が正しくないかも
        //光を消すならしたのを
        if timer.isValid == true {
            //timerを破棄する.
            timer.invalidate()
            testLabel.text = "少しお休みしませんか?"
        }
        
    }
    
    //    //一時停止　再開　メソッド
    //    func itiji() {
    //
    //        if timer.isValid == true {
    ////        //一時停止
    //        self.gameStartTime = Date()
    //        self.gamePauseTime(false)//タイマーを削除
    //        self.StartButton.setImage(UIImage(named: "Stop"), for: UIControlState())
    //
    //        }else {
    //            //再開
    //            //timerを生成する.
    //            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(self.countDown), userInfo: nil, repeats: true)
    //
    //            self.StartButton.setImage(UIImage(named: "Start"), for: UIControlState())
    //        }
    //
    //    }
    
    //    // タイマーを止めたり動かしたりするメソッド
    //    func timerStopStart(setFlg: Bool){
    //        if setFlg || self.timer == nil {
    //            // 一時停止時間から、最初の時間を引いて、その分をタイマーセット時間から引く
    //            let defTime = self.gamePauseTime.timeIntervalSince1970 - self.gameStartTime.timeIntervalSince1970
    //            // タイマーを入れなおす
    //            self.gameClearTimer = Timer.scheduledTimer(timeInterval: 60 - defTime, target: self, selector: #selector(ViewController.clearFunc), userInfo: nil, repeats: false);
    //        } else {
    //            self.timer.invalidate();
    //        }
    //    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 234/255, green: 255/255, blue: 255/255, alpha: 1) //背景
        
        //「分」のラベルを追加
        let mStr = UILabel()
        mStr.text = "minute"
        mStr.sizeToFit()
        mStr.frame = CGRectMake(testPickerView.bounds.width/2.45 - mStr.bounds.width/2,
                                testPickerView.bounds.height/2 - (mStr.bounds.height/2),
                                mStr.bounds.width, mStr.bounds.height)
        testPickerView.addSubview(mStr)
        
        
        //「秒」のラベルを追加
        let sStr = UILabel()
        sStr.text = "second"
        sStr.sizeToFit()
        sStr.frame = CGRectMake(testPickerView.bounds.width/1.5 - sStr.bounds.width/2,
                                testPickerView.bounds.height/2 - (sStr.bounds.height/2),
                                sStr.bounds.width, sStr.bounds.height)
        testPickerView.addSubview(sStr)
        
        print(dataList[0].count)
        
        testPickerView.delegate = self
        testPickerView.dataSource = self
        
        testPickerView.selectRow(20, inComponent: 0, animated: false)//最初に表示する行を指定するプロパティ
        
    }
    
    
    //上で文句言われたからFix コンポーネントの個数を返すメソッド
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    //上で文句言われたからFix コンポーネントに含まれるデータ個数を返すメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(dataList[component].count)
        return dataList[component].count
        
    }
    
    //サイズを返すメソッド
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return testPickerView.bounds.width * 1/4
    }
    
    //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(dataList[component][row])
        pickerLabel.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 183/255, alpha: 1)
        
        return pickerLabel
    }
    //コロコロがとまったときに処理される。
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //        print(dataList[0][0])
        //        print(self.testPickerView.selectedRow(inComponent: 0))
        if self.testPickerView.selectedRow(inComponent: 0) == 0 && self.testPickerView.selectedRow(inComponent: 1) == 0 {
            StartButton.isEnabled = false
        } else {
            StartButton.isEnabled = true
        }
        //        if dataList[0] == [0] {
        //            print(dataList[0])
        //        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
