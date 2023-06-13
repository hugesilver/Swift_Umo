//
//  UploadFeedViewController.swift
//  umo
//
//  Created by 김태은 on 2023/06/11.
//

import UIKit
import Foundation
import FirebaseStorage
import Firebase

class UploadFeedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTouchUpInsideUploadButton(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            let _alertController = UIAlertController(title: "업로드 실패", message: "사진을 선택해주세요.", preferredStyle: .alert)
            let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            _alertController.addAction(_okAction)
            self.present(_alertController, animated: true, completion: nil)
            
            return
        }
        
        if (descTextField == nil) {
            let _alertController = UIAlertController(title: "업로드 실패", message: "내용을 작성해주세요.", preferredStyle: .alert)
            let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            _alertController.addAction(_okAction)
            self.present(_alertController, animated: true, completion: nil)
            
            return
        }
        
        // 이미지 업로드
        uploadImage(selectedImage) { downloadURL in
            if let downloadURL = downloadURL{
                print(downloadURL)
            }
        }
    }
    
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onTouchUpInsideSelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false // 이미지 편집을 허용할 경우 true로 설정
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let formattedDateTime = dateFormatter.string(from: Date())
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("feeds/\(formattedDateTime)_\(uid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                let _alertController = UIAlertController(title: "오류", message: "업로드에 실패하였습니다.\n\(error.localizedDescription)", preferredStyle: .alert)
                let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                _alertController.addAction(_okAction)
                self.present(_alertController, animated: true, completion: nil)
                
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    let _alertController = UIAlertController(title: "오류", message: "업로드에 실패하였습니다.\n\(error.localizedDescription)", preferredStyle: .alert)
                    let _okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    _alertController.addAction(_okAction)
                    self.present(_alertController, animated: true, completion: nil)
                    
                    completion(nil)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                if let nickname = UserDefaults.standard.string(forKey: "nickname") {
                    Firestore.firestore()
                        .collection("feeds")
                        .document("\(formattedDateTime)_\(uid)")
                        .setData([
                            "uid": uid,
                            "nickname": nickname,
                            "image": downloadURL.absoluteString,
                            "desc": self.descTextField.text,
                            "sendTime": Date()
                        ])
                    let alertController = UIAlertController(title: "업로드 완료", message: "피드에 업로드를 완료하였습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action:UIAlertAction!) in
                        self?.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)

                }
                
                completion(downloadURL)
            }
        }
    }

}
