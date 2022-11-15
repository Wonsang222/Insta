//
//  UploadPostController.swift
//  Insta
//
//  Created by 황원상 on 2022/11/14.
//

import UIKit

protocol UploadPostControllerDelegate:AnyObject{
    func controllerDidFinishUploadingPost(_ controller:UploadPostController)
}

class UploadPostController:UIViewController{
    
    var selectedImage:UIImage? {
        didSet{
            photoImageView.image = selectedImage
        }
    }
    
    var currentUser:User?
    
    weak var delegate:UploadPostControllerDelegate?
    
    private let photoImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var captionTextView:InputTextView = {
       let tv = InputTextView()
        tv.placeholderText = "Enter Caption"
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        tv.placeholderShouldcenter = false
        return tv
    }()
    
    private let characterCountLabel:UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func configureUI(){
        navigationItem.title = "Upload Post"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 12)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top:photoImageView.bottomAnchor, left: view.leftAnchor, right:view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
    
    @objc func didTapDone(){
        guard let image = selectedImage else {return}
        guard let caption = captionTextView.text else {return}
        guard let user = currentUser else {return}
        
        showLoader(true)
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            if let error = error{
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    func checkMaxLength(_ textView:UITextView){
        if textView.text.count > 100{
            textView.deleteBackward()
        }
    }
    
    
}

extension UploadPostController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
