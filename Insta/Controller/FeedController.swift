//
//  FeedController.swift
//  Insta
//
//  Created by 황원상 on 2022/08/29.
//

import UIKit
import Firebase

private let reuseIdentifier = "cell"

class FeedController:UICollectionViewController{
    
    
    //MARK: - Properties
    
    private var posts = [Post]()
    var post:Post?
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        navigationItem.title = "Feed"
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    //MARK: - Actions
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }catch{
            print("DEBUG:failed to sign out")
        }
    }
    
    func fetchPosts(){
        guard post == nil else {return}
//        PostService.fetchPosts { posts in
//
//        }
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func handleRefresh(){
        posts.removeAll()
        fetchPosts()
        
    }
}
//MARK: - UICollectionviewDatasource
extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post{
            cell.viewModel = PostViewModel(post: post)
        }else{
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 48 + 8
//
        height += 60
        height += 50
  
        return CGSize(width: width, height: height)
    }
}

extension FeedController:FeedCellDelegate{
    func cell(_ cell: FeedCell, wantsToShowCommentsForPost: Post) {
        guard let post = post else {return}
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else {return}
        guard let user = tab.user else {return}
        cell.viewModel?.post.didLike.toggle()
        if post.didLike{
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        }else{
            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
