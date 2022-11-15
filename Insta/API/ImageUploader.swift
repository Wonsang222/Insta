//
//  ImageUploader.swift
//  Insta
//
//  Created by 황원상 on 2022/10/10.
//

import FirebaseStorage

struct ImageUploader{
    static func uploadImage(image:UIImage, completion:@escaping (String)->Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData) { metadata, error in
            if let error = error{
                print("DEBUG:file to upload image\(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
