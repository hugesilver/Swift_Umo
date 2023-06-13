//
//  LoginViewController.swift
//  umo
//
//  Created by 김태은 on 2023/05/16.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func onTouchLogin(_ sender: Any) {
        let _emailText: String? = email.text
        let _passwordText: String? = password.text
        
        if(_emailText == nil ||
           _passwordText == nil) {
            return
        }
        
        Auth.auth().signIn(withEmail: _emailText!, password: _passwordText!)
        { authResult, error in
            if let error = error {
                print("로그인 실패: \(error.localizedDescription)")
                let _alertController = UIAlertController(title: "로그인 실패", message: "로그인 중 문제가 생겼습니다.", preferredStyle: .alert)
                let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                _alertController.addAction(_okAction)
                self.present(_alertController, animated: true, completion: nil)
            } else {
                if let uid = authResult?.user.uid {
                    UserDefaults.standard.set(uid, forKey: "uid")
                }
                Firestore.firestore()
                    .collection("user")
                    .document(authResult!.user.uid)
                    .getDocument{(documentSnapshot, error) in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        if let email = documentSnapshot!.data()!["email"] as? String {
                            UserDefaults.standard.set(email, forKey: "email")
                        }
                        if let nickname = documentSnapshot!.data()!["nickname"] as? String {
                            UserDefaults.standard.set(nickname, forKey: "nickname")
                        }
                }
                guard let mainVC = self.storyboard?.instantiateViewController(identifier: "MainViewContoller") else {return}
                mainVC.modalPresentationStyle = .fullScreen
                mainVC.navigationItem.hidesBackButton = true
                self.present(mainVC, animated: false, completion: nil)
            }
        }
        
        
    }
}
