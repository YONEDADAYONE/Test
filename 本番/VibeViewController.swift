//
//  VibeViewController.swift
//  本番
//
//  Created by 米田大弥 on 2018/06/27.
//  Copyright © 2018年 hiroya. All rights reserved.
//

import UIKit
import UserNotifications//通知フレームワーク追加
import AVKit//AVKitフレームワークに追加
import AudioToolbox

class VibeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testPickerView: UIPickerView!
    @IBOutlet weak var StartButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    
    
    //時分秒のデータ
    let dataList = [ [Int](0...59), [Int](0...59)]
    
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
    

    
        //バイブボタンがタップされたら
        @IBAction func VibesetTimerNotification(_ sender: UIButton) {
    
            //すでに動いているタイマーは停止する。
            timer.invalidate()
            //カウントダウンする秒数を取得する。
            count = dataList[0][testPickerView.selectedRow(inComponent: 0)] * 60
                +  dataList[1][testPickerView.selectedRow(inComponent: 1)]
    
            //1秒周期でcountDownメソッドを呼び出すタイマーを開始する。
            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(countDownV), userInfo:nil, repeats:true)
    
            setNotificationAftrer(second: count)
            
        }
    
        //タイマーから呼び出されるメソッド(関数)
        @objc func countDownV(){
    
            //カウントを減らす。
            count -= 1
 
            print(count)
            
            //カウントダウン状況をラベルに表示
            if(count > 0) {
                testLabel.text = "残り\(count)秒です。"
            } else if (count == 0) {
                testLabel.text = "カウントダウン終了"
                
                //震える
                Vibe()
            
                //アラート表示
                let alert = UIAlertController(
                    title: "アラームを止めますか?", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    //ここに処理を書く
                    
                    self.timer.invalidate()
                    self.testLabel.text = "少しお休みしませんか?"
                })
                
                //
                alert.addAction(defaultAction)
                
                //
                present(alert,animated: true,completion: nil)
            
            }
    
        }
    
    //自作関数だよ! 一回保留
    func setNotificationAftrer(second:Int) {
        // Notification のインスタンスを作成
        let content = UNMutableNotificationContent()
        
        //通知のタイトル本文の設定
        content.title = "通知のタイトルだよ"
        content.body = "おはよう"
        
        //音設定
        content.sound = UNNotificationSound.default()
        
        //トリガー設定
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second), repeats: false)
        
        //リクエスト
        let request = UNNotificationRequest.init(identifier: "ID_AfterSecOnce", content: content, trigger: trigger)
        
        //通知のセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
//        for (int i = 0; i <= 6; i++) {
//            NSDate *fireDate = [basedFireDate dateByAddingMinutes:i * 15];
//            [self makeNotification:fireDate a
//        }
        
    }
    
    
    
    //バックグラウンドだよ
    
    
    
        //震える　ずっと震えさせる方法考える ポケットリファレンスの90%を参照
        func Vibe() {
            self.timer.invalidate()

            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.buruburu),
                userInfo: nil,
                repeats: true)
            
    }
    
    @objc func buruburu() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    

    
    @IBAction func CancelButton(_ sender: UIButton) {
        if timer.isValid == true {
            //timerを破棄する.
            timer.invalidate()
            testLabel.text = "少しお休みしませんか?"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //背景を設定
        self.view.backgroundColor = UIColor.init(red: 234/255, green: 255/255, blue: 255/255, alpha: 1)
        
//        //「時間」のラベルを追加
//        let hStr = UILabel()
//        hStr.text = "hour"
//        hStr.sizeToFit()//ぴったりのサイズにするプロパティ
//        hStr.frame = CGRectMake(testPickerView.bounds.width/4 - hStr.bounds.width/2,
//                                testPickerView.bounds.height/2 - (hStr.bounds.height/2),
//                                hStr.bounds.width, hStr.bounds.height)
//        testPickerView.addSubview(hStr)
        
        //「分」のラベルを追加
        let mStr = UILabel()
        mStr.text = "minute"
        mStr.sizeToFit()
        mStr.frame = CGRectMake(testPickerView.bounds.width/2.45 - mStr.bounds.width/2,
                                testPickerView.bounds.height/2 - (mStr.bounds.height/2),
                                mStr.bounds.width, mStr.bounds.height)
        testPickerView.addSubview(mStr)
        print(mStr)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
