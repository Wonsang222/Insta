//
//  CommentInputAccesoryView.swift
//  Insta
//
//  Created by 황원상 on 2022/11/14.
//

import UIKit

protocol CommentInputAccesoryViewDelegate:AnyObject{
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment:String)
}

class CommentInputAccesoryView: UIView{
    
    weak var delegate:CommentInputAccesoryViewDelegate?
    
    private let commentTextView:InputTextView = {
            let tv = InputTextView()
        tv.placeholderText = "Enter Comment"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldcenter = false
        return tv
    }()
    
    private let postButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(postButton)
        postButton.anchor(top:topAnchor, right:rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top:topAnchor, left:leftAnchor, bottom:safeAreaLayoutGuide.bottomAnchor, right:postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top:topAnchor, left: leftAnchor, right:rightAnchor, height: 0.5)
        
        autoresizingMask = .flexibleHeight
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePostTapped(){
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    func clearCommentTextView(){
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
