//
//  Comment.swift
//  Insta
//
//  Created by 황원상 on 2022/11/15.
//

import Firebase

struct Comment{
    let uid:String
    let username:String
    let profileImageUrl:String
    let timestamp:Timestamp
    let commentText:String
    
    init(dictionary:[String:Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["commentText"] as? String ?? ""
    }
}
