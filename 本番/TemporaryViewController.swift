//
//  TemporaryViewController.swift
//  本番
//
//  Created by 米田大弥 on 2018/07/10.
//  Copyright © 2018年 hiroya. All rights reserved.
//

import UIKit

var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得



class TemporaryViewController: UIViewController {

    func vessele() {
       appDelegate.message = 0 //appDelegateの変数を操作
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
