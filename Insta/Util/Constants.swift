//
//  Constants.swift
//  Insta
//
//  Created by 황원상 on 2022/11/12.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


let COLLECTION_USERS = Firestore.firestore().collection("users")

let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

let COLLECTION_POSTS = Firestore.firestore().collection("posts")

let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
