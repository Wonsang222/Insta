//
//  ProfileCell.swift
//  Insta
//
//  Created by 황원상 on 2022/11/12.
//

import UIKit

class ProfileCell:UICollectionViewCell{
    
    var viewModel:PostViewModel?{
        didSet{
            configure()
        }
    }
    
    private let postImageView:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "venom-7")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let viewModel = viewModel else {return}
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
    
}
