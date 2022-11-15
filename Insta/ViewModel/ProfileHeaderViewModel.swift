//
//  ProfileHeaderViewModel.swift
//  Insta
//
//  Created by 황원상 on 2022/11/12.
//

import UIKit

struct ProfileHeaderViewModel{
    let user:User
    
    var fullname:String {
        return user.fullname
    }
    
    var followedButtonText: String{
        if user.isCurrentUser{
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var profileImageUrl:URL? {
        return URL(string: user.profileImageURL)
    }
    
    var followButtonBackgroundColor:UIColor{
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor:UIColor{
        return user.isCurrentUser ? .black : .white
    }

    var numberOfFollowers:NSAttributedString{
        return attributedStatText(value: user.stats.followers, label: "followers")
    }
    
    var numberOfFollowing:NSAttributedString{
        return attributedStatText(value: user.stats.following, label: "following")
    }
    
    var numberOfPosts: NSAttributedString{
        return attributedStatText(value: user.stats.posts, label: "posts")
    }
    
    init(user:User){
        self.user = user
    }
    
    
    func attributedStatText(value:Int, label:String) -> NSAttributedString{
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray]))
        
        return attributedText
    }
}
