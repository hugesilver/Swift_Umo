//
//  RegisterViewController.swift
//  umo
//
//  Created by 김태은 on 2023/05/09.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    @IBAction func onTouchRegister(_ sender: UIButton) {
        let _nicknameText: String? = nickname.text
        let _emailText: String? = email.text
        let _passwordText: String? = password.text
        let _passwordConfirmText: String? = passwordConfirm.text
        
        if(_nicknameText == nil ||
            _emailText == nil ||
           _passwordText == nil ||
           _passwordConfirmText == nil ||
           (_passwordText != _passwordConfirmText)){
            return
        }
            
        Auth.auth().createUser(withEmail: _emailText!, password: _passwordText!)
        { authResult, error in
            if let error = error {
                // 계정 생성에 실패한 경우
                print("Error creating user: \(error.localizedDescription)")
                let _alertController = UIAlertController(title: "회원가입 실패", message: "회원가입 중 문제가 생겼습니다.\n\(error.localizedDescription)", preferredStyle: .alert)
                let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                _alertController.addAction(_okAction)
                self.present(_alertController, animated: true, completion: nil)
            } else {
                if let uid = authResult?.user.uid {
                    if let email = authResult?.user.email{
                        Firestore.firestore().collection("user").document("\(uid)").setData(["uid": "\(uid)", "nickname": _nicknameText, "email": "\(email)"])
                    }
                }
                let _alertController = UIAlertController(title: "회원가입 완료", message: "회원가입을 완료하였습니다.\n로그인을 해주세요.", preferredStyle: .alert)
                let _okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action:UIAlertAction!) in
                    self?.navigationController?.popViewController(animated: true)
                }
                _alertController.addAction(_okAction)
                self.present(_alertController, animated: true, completion: nil)
            }
        }
    }
}
