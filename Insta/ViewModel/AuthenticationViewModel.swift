//
//  AuthenticationViewModel.swift
//  Insta
//
//  Created by 황원상 on 2022/10/05.
//

import UIKit

protocol formViewModel{
    func updateForm()
}

protocol AuthenticationViewModel{
    var formIsValid:Bool {get}
    var buttonBackgroundColor:UIColor {get}
    var buttonTitleColor:UIColor {get}
}


struct LoginViewModel:AuthenticationViewModel{
    var email:String?
    var password:String?
    
    var formIsValid:Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor:UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor:UIColor  {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}

struct registrationViewModel:AuthenticationViewModel{
    var email:String?
    var password:String?
    var fullName:String?
    var userName:String?
    
    var formIsValid:Bool{
        return email?.isEmpty == false && password?.isEmpty == false
        && fullName?.isEmpty == false && userName?.isEmpty == false
    }
    
    var buttonBackgroundColor:UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor:UIColor  {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    
}
