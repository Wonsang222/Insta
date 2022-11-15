//
//  NotificationCenterController.swift
//  Insta
//
//  Created by 황원상 on 2022/08/30.
//

import UIKit

private let reuseIdentifier = "Cell"

class NotificationCenterController:UITableViewController{
        
    let refresher = UIRefreshControl()
    
    private var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    func fetchNotifications(){
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            self.checkIfUserFollowed()
        }
    }
    
    func configureTableView(){
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    @objc func handleRefresh(){
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    func checkIfUserFollowed(){
        notifications.forEach { notification in
            guard notification.type == .follow else {return}
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFoollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}){
                    self.notifications[index].userIsFollowed = isFoollowed
                }
            }
        }
    }
    
}

extension NotificationCenterController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}


extension NotificationCenterController:NotificationCellDelegate{
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
        
    }
    
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
        
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        PostService.fetchPost(withPostId: postId) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
                
        }
    }
}

extension NotificationCenterController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let uid = notifications[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
