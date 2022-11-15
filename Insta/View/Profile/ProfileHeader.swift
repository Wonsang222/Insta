//
//  ProfileHeader.swift
//  Insta
//
//  Created by 황원상 on 2022/11/12.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject{
    func header(_ profileHeader:ProfileHeader, didTapButtonFor user:User)
}

class ProfileHeader:UICollectionReusableView{
    
    var viewModel:ProfileHeaderViewModel?{
        didSet{
            configure()
        }
    }
    
    weak var delegate:ProfileHeaderDelegate?
    
    private let profileImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followerLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = nil
        return label
    }()
    
    private lazy var followingLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let gridButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    private let listButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private let bookmarkButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left:leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top:profileImageView.bottomAnchor, left:leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top:nameLabel.bottomAnchor, left:leftAnchor, right:rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left:profileImageView.rightAnchor, right:rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottomDivider)

        buttonStack.anchor(left:leftAnchor, bottom:bottomAnchor, right:rightAnchor, height:50)
        
        topDivider.anchor(top:buttonStack.topAnchor, left:leftAnchor, right:rightAnchor, height:0.5)
        
        bottomDivider.anchor(top:buttonStack.bottomAnchor, left:leftAnchor, right:rightAnchor, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditProfileFollowTapped(){
        guard let viewModel = viewModel else {return}
        delegate?.header(self, didTapButtonFor: viewModel.user)
    }
    

    
    func configure(){
        guard let viewModel = viewModel else {return}
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileButton.setTitle(viewModel.followedButtonText, for: .normal)
        editProfileButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postLabel.attributedText = viewModel.numberOfPosts
        followerLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
}

