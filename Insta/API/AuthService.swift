//
//  AuthService.swift
//  Insta
//
//  Created by 황원상 on 2022/10/10.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct AuthCredentials{
    let email:String
    let password :String
    let fullname : String
    let username : String
    let profileImage :UIImage
}


struct AuthService{
    static func logUserIn(withEmail email:String, password:String, completion:@escaping(AuthDataResult?, Error?) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func registerUser(withCredential credentials:AuthCredentials, completion: @escaping(Error?) -> Void){
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print(print("DEBUG:filed to register user\(error.localizedDescription)"))
                    return
                }
                guard let uid = result?.user.uid else {return}
                
                let data:[String:Any] = ["email":credentials.email,
                                         "fullname":credentials.fullname,
                                         "profileImageURL":imageUrl,
                                         "uid":uid,
                                         "username":credentials.username]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
}
