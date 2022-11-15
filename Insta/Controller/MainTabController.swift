//
//  MainTabController.swift
//  Insta
//
//  Created by 황원상 on 2022/08/29.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController:UITabBarController{
    
    
    //MARK: - Lifecycle
    
     var user:User?{
        didSet{
            guard let user = user else {return}
            configureViewcontroller(with: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserIsLoggedIn()
        fetchUser()
    }
    
    //MARK: - API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
      
        }
    }

    func checkUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureViewcontroller(with user:User){
        
        view.backgroundColor = .white
        self.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationContoroller(unselectedImage: UIImage(imageLiteralResourceName: "home_unselected"), selectedImage: UIImage(imageLiteralResourceName: "home_selected"), rootviewController: FeedController(collectionViewLayout: layout))
        let search = templateNavigationContoroller(unselectedImage: UIImage(imageLiteralResourceName: "search_unselected") , selectedImage: UIImage(imageLiteralResourceName: "search_unselected"), rootviewController: SearchController())
        let imageSelector = templateNavigationContoroller(unselectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), selectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), rootviewController: ImageSelectorController())
        let notifications = templateNavigationContoroller(unselectedImage: UIImage(imageLiteralResourceName: "like_unselected"), selectedImage: UIImage(imageLiteralResourceName: "like_selected"), rootviewController: NotificationCenterController())
        let profileLayout = ProfileController(user: user)
        let profile  = templateNavigationContoroller(unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), rootviewController: profileLayout)
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationContoroller(unselectedImage:UIImage, selectedImage:UIImage, rootviewController:UIViewController)->UINavigationController{
        let nav = UINavigationController(rootViewController: rootviewController)
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.image = unselectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickingMedia(_ picker:YPImagePicker){
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: true){
                guard let selectedImage = items.singlePhoto?.image else {return}
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
}

extension MainTabController:AuthenticationDelegate{
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true)
    }
    
    
}

extension MainTabController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2{
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
}

extension MainTabController:UploadPostControllerDelegate{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else {return}
        guard let feed = feedNav.viewControllers.first as? FeedController else {return}
        feed.handleRefresh()
    }
}
