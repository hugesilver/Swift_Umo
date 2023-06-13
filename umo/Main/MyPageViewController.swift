//
//  MyPageViewController.swift
//  umo
//
//  Created by 김태은 on 2023/06/12.
//

import UIKit
import Firebase

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _nicknameText.isEnabled = false
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            _nicknameText.text = nickname
        }
        if let email = UserDefaults.standard.string(forKey: "email") {
            _emailText.text = email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _nicknameText.isEnabled = false
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            _nicknameText.text = nickname
        }
        if let email = UserDefaults.standard.string(forKey: "email") {
            _emailText.text = email
        }
    }

    @IBOutlet weak var _nicknameText: UITextField!
    @IBOutlet weak var _emailText: UITextField!
    
    @IBAction func onTouchUpInsideChangeButton(_ sender: Any) {
        _nicknameText.isEnabled = true
    }
    @IBAction func onTouchUpInsideSaveButton(_ sender: Any) {
        if let uid = UserDefaults.standard.string(forKey: "uid"){
            Firestore.firestore().collection("user").document("\(uid)").updateData(["nickname" : _nicknameText.text])
            
            let _alertController = UIAlertController(title: "변경 성공", message: "사용자의 정보 변경이 완료되었습니다.", preferredStyle: .alert)
            let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            _alertController.addAction(_okAction)
            self.present(_alertController, animated: true, completion: nil)
        }
    }
}
