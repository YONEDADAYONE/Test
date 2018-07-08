//
//  musicViewController.swift
//  本番
//
//  Created by 米田大弥 on 2018/06/27.
//  Copyright © 2018年 hiroya. All rights reserved.
//

import UIKit
import UserNotifications//通知フレームワーク追加
import AVKit//AVKitフレームワークに追加
import AVFoundation//音鳴らしたい

class musicViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource  {

    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testPickerView: UIPickerView!
    @IBOutlet weak var StartButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var audioPlayer:AVAudioPlayer!
    var player: AVAudioPlayer?
    
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
    
    //ライトボタンタップされたら発動.
    @IBAction func setTimerNotification(_ sender: UIButton) {
        
        //すでに動いているタイマーは停止する。
        timer.invalidate()
        //カウントダウンする秒数を取得する。
        count = dataList[0][testPickerView.selectedRow(inComponent: 0)] * 60
            +  dataList[1][testPickerView.selectedRow(inComponent: 1)]
        
        //1秒周期でcountDownメソッドを呼び出すタイマーを開始する。
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(countDown), userInfo:nil, repeats:true)
        
        setNotificationAftrer(second: count)
        
    }
    
    //光タイマーから呼び出されるメソッド(関数)
    @objc func countDown(){
        
        //カウントを減らす。
        count -= 1
        
        //カウントダウン状況をラベルに表示
        if(count > 0) {
            testLabel.text = "残り\(count)秒です。"
        } else {
            testLabel.text = "カウントダウン終了"
            timer.invalidate()
            //光らせる
            ongaku()
            audioPlayer.numberOfLoops = -1
            //アラート表示
            let alert = UIAlertController(
                title: "アラームを止めますか?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                //ここに処理を書く
                self.audioPlayer.stop()
                self.testLabel.text = "少しお休みしませんか?"
            })
            
            //
            alert.addAction(defaultAction)
            
            //
            present(alert,animated: true,completion: nil)
        }
        
        
    }
    
    //    //バイブボタンがタップされたら
    //    @IBAction func VibesetTimerNotification(_ sender: UIButton) {
    //
    //        //すでに動いているタイマーは停止する。
    //        timer.invalidate()
    //        //カウントダウンする秒数を取得する。
    //        count = dataList[0][testPickerView.selectedRow(inComponent: 0)] * 60 * 60
    //            +  dataList[0][testPickerView.selectedRow(inComponent: 1)] * 60
    //            +  dataList[0][testPickerView.selectedRow(inComponent: 2)]
    //
    //        //1秒周期でcountDownメソッドを呼び出すタイマーを開始する。
    //        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(countDownV), userInfo:nil, repeats:true)
    //
    //        setNotificationAftrer(second: count)
    //    }
    
    //    //タイマーから呼び出されるメソッド(関数)
    //    @objc func countDownV(){
    //
    //        //カウントを減らす。
    //        count -= 1
    //
    //        //カウントダウン状況をラベルに表示
    //        if(count > 0) {
    //            testLabel.text = "残り\(count)秒です。"
    //        } else {
    //            testLabel.text = "カウントダウン終了"
    //            timer.invalidate()
    //            //震える
    //            Vibe()
    //        }
    //
    //    }
    
    //自作関数だよ! 一回保留
    func setNotificationAftrer(second:Int) {
        // Notification のインスタンスを作成
        let content = UNMutableNotificationContent()
        
        //通知のタイトル本文の設定
        content.title = "指定した時間になりました。"
        content.body = "起きましょう!"
        
        //音設定
        content.sound = UNNotificationSound(named: "birdland1.mp3")
        
//        //トリガー設定
//        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second), repeats: false)
//        
//        //リクエスト
//        let request = UNNotificationRequest.init(identifier: "ID_AfterSecOnceMusic", content: content, trigger: trigger)
//        
//        //通知のセット
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        //バックグラウンドだよ
        //for i in stride(from: 開始位置, to: 終了位置, by: 間隔)
        for i in stride(from: 1, to: 50, by: 5) {
            //トリガー設定
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(second + i), repeats: false)
            
            //リクエスト 復習
            let request = UNNotificationRequest.init(identifier: "ID_AfterSecOnce\(i)", content: content, trigger: trigger)
            
            //通知のセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            //[iOS8以降]Push通知の実装とテスト(swift)を参考
            func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
                switch application.applicationState {
                case .active:
                    timer.invalidate()
                    break
                case .inactive:
                    timer.invalidate()
                    break
                case .background:
                    timer.invalidate()
                    break
                }
            }
        }
    }
    
    //鳴らす
    func ongaku() {
        if (audioPlayer.isPlaying) {
            audioPlayer.play()
//            setTitle("Stop", for: UIControlState())
        }
        else{
            audioPlayer.play()
//            setTitle("Play", for: UIControlState())
        }
        
        
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
        
        //再生する　audio ファイルのパスを作成
        let audioPath = Bundle.main.path(forResource: "birdland1", ofType: "mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        //audio を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        //エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        //謎のFixつけた。要質問
        audioPlayer.delegate = self as? AVAudioPlayerDelegate
        audioPlayer.prepareToPlay()
        
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
        print(mStr)
        
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
