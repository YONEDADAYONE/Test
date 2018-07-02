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
    
    
    var timer:Timer = Timer()
    var count:Int = 0
    
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
            
            // タイマーが0の時にボタンを押せなくする できない聞く
//            if self.timer.timeInterval == 0 {
//                sender.isEnabled = false
//            }
//
//            if self.dataList[0] == [Int(0)] {
//                print("あ")
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
        
        //カウントを減らす。
        count -= 1
        
        //カウントダウン状況をラベルに表示
        if(count > 0) {
            testLabel.text = "残り\(count)秒です。"//ここをいじるはず分ラベルと秒ラベルで操作?
        } else {
            testLabel.text = "カウントダウン終了"
            timer.invalidate()
            //光らせる
            Hikari()
        }
        
    }
    
    //自作関数だよ! 一回保留
    func setNotificationAftrer(second:Int) {
        // Notification のインスタンスを作成
        let content = UNMutableNotificationContent()
        
        //通知のタイトル本文の設定
        content.title = "お知らせします"
        content.body = "指定した時刻になりました"
        
//        //音設定
//        content.sound = UNNotificationSound.default()
        
        
        //トリガー設定
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second), repeats: false)
        
        //リクエスト
        let request = UNNotificationRequest.init(identifier: "ID_AfterSecOnce", content: content, trigger: trigger)
        
        //通知のセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    //光らせる
    func Hikari() {
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
    

    //バックグラウンドだよ
    

    
//    //震える　ずっと震えさせる方法考える
//    func Vibe() {
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//    }
   
    @IBAction func CancelButton(_ sender: UIButton) {
        //timerが動いてるなら.
        if timer.isValid == true {
            
            //timerを破棄する.
            timer.invalidate()
            testLabel.text = "少しお休みしませんか?"
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            device?.torchMode = AVCaptureDevice.TorchMode.off //Off
            device?.unlockForConfiguration()//上のとセット
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.init(red: 234/255, green: 255/255, blue: 255/255, alpha: 1) //背景
        
//        //「時間」のラベルを追加
//        let hStr = UILabel()
//        hStr.text = "時間"
//        hStr.sizeToFit()//ぴったりのサイズにするプロパティ
//        hStr.frame = CGRectMake(testPickerView.bounds.width/4 - hStr.bounds.width/2,
//                                testPickerView.bounds.height/2 - (hStr.bounds.height/2),
//                                hStr.bounds.width, hStr.bounds.height)
//        testPickerView.addSubview(hStr)
        
        //「分」のラベルを追加
        let mStr = UILabel()
        mStr.text = "minute"
        mStr.sizeToFit()
        mStr.frame = CGRectMake(testPickerView.bounds.width/2.41 - mStr.bounds.width/2,
                                testPickerView.bounds.height/2 - (mStr.bounds.height/2),
                                mStr.bounds.width, mStr.bounds.height)
        testPickerView.addSubview(mStr)
        
        
        //「秒」のラベルを追加
        let sStr = UILabel()
        sStr.text = "second"
        sStr.sizeToFit()
        sStr.frame = CGRectMake(testPickerView.bounds.width/1.48 - sStr.bounds.width/2,
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
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
