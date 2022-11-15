//
//  UserCellViewModel.swift
//  Insta
//
//  Created by 황원상 on 2022/11/13.
//

import UIKit


struct UserCellViewModel{
    private let user:User
    init(user:User){
        self.user = user
    }
    
    var profileImageUrl:URL?{
        return URL(string: user.profileImageURL)
    }
    
    var username: String{
        return user.username
    }
    
    var fullname:String{
        return user.fullname
    }
}
