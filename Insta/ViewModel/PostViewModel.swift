//
//  PostViewModel.swift
//  Insta
//
//  Created by íŠėė on 2022/11/14.
//

import Foundation

struct PostViewModel{
    var post:Post
    
    init(post: Post) {
        self.post = post
    }
    
    var imageUrl:URL?{
        return URL(string: post.imageUrl)
    }
    
    var caption:String {
        return post.caption
    }
    
    var likes:Int{
        return post.likes
    }
    
    var userProfileImageUrl:URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username:String {
        return post.ownerUsername
    }
    
    var likesLabelText:String{
        if post.likes != 1{
            return "\(post.likes) likes"
        }else{
            return "\(post.likes) like"
        }
    }
    
}
