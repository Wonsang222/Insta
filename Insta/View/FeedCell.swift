//
//  FeedCell.swift
//  Insta
//
//  Created by 황원상 on 2022/10/05.
//

import UIKit

protocol FeedCellDelegate:AnyObject{
    func cell(_ cell:FeedCell, wantsToShowCommentsForPost:Post)
    func cell(_ cell:FeedCell, didLike post:Post)
    func cell(_ cell:FeedCell, wantsToShowProfileFor uid:String)
}

class FeedCell:UICollectionViewCell{
    
    
    //MARK: - Properties
    
    weak var delegate:FeedCellDelegate?
    
    var viewModel: PostViewModel?{
        didSet{
            configure()
        }
    }
    
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var usernameButton:UIButton = {
       let button = UIButton()
        button.setTitle("venom", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    private let postImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
     lazy var likeButton:UIButton = {
       let button = UIButton()
        let a = #imageLiteral(resourceName: "like_unselected")
        button.setImage(a, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton:UIButton = {
       let button = UIButton()
        let a = #imageLiteral(resourceName: "comment")
        button.setImage(a, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton:UIButton = {
       let button = UIButton()
        let a = #imageLiteral(resourceName: "send2")
        button.setImage(a, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel:UILabel = {
       let label = UILabel()
        label.text = "1 like"
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel:UILabel = {
       let label = UILabel()
        label.text = "test caption"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let postTimeLabel:UILabel = {
       let label = UILabel()
        label.text = "2days ago"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: -  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top:topAnchor, left:leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top:profileImageView.bottomAnchor, left:leftAnchor, right:rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top:likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top:likesLabel.bottomAnchor, left:leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top:captionLabel.bottomAnchor, left:leftAnchor, paddingTop: 8, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let viewModel = viewModel else {return}
        self.captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl)
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        likesLabel.text = viewModel.likesLabelText
    }
    
    //MARK: - Actions
    
    @objc func didTapLike(){
        guard let viewModel = viewModel else {return}
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    @objc func didTapUsername(){
        guard let viewModel = viewModel else {return}
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    
    @objc func didTapComments(){
        guard let viewModel = viewModel else {return}
        delegate?.cell(self, wantsToShowCommentsForPost: viewModel.post)
    }
    
    func configureActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
         stackView.axis = .horizontal
         stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top:postImageView.bottomAnchor, width: 120, height: 50 )
    }
    
  
    
}
