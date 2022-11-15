//
//  CustomTextField.swift
//  Insta
//
//  Created by 황원상 on 2022/10/05.
//

import UIKit

class CustomTextField:UITextField{
    
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        

        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        autocorrectionType = .no
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 0.7)])
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

