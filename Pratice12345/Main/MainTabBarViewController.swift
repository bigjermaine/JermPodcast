//
//  MainTabBarViewController.swift
//  Pratice12345
//
//  Created by MacBook AIR on 19/09/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        let Vc1 =  HomeViewController()
        let Vc2 =  ViewController()
        let Vc3 =  FavoriteViewController(collectionViewLayout:layout)
        
        Vc1.navigationItem.largeTitleDisplayMode = .always
        
        Vc2.navigationItem.largeTitleDisplayMode = .always
        Vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: Vc1)
        let nav2 = UINavigationController(rootViewController: Vc2)
        let nav3 = UINavigationController(rootViewController: Vc3)
      
        nav1.tabBarItem = UITabBarItem(title: "Dowloads", image: UIImage(systemName: "headphones"), tag: 1)
        
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        nav3.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "figure.fall.circle.fill"), tag: 3)
    
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()

        nav2.navigationBar.backgroundColor = .clear
        nav2.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav2.navigationBar.shadowImage = UIImage()

     
        nav3.navigationBar.backgroundColor = .clear
        nav3.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav3.navigationBar.shadowImage = UIImage()

     
    
    
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().tintColor  = .purple
        UITabBar.appearance().unselectedItemTintColor = .gray
        setViewControllers([nav2,nav3,nav1], animated: false)
        
        setUpPlayerDetailView()
       // perform(#selector(maximizedPlayerDetails),with: nil,afterDelay: 0)
    }
    
    
    let playerDetialsView = MediaPlayerView.initFromNib()
    
    var maximizedTopAnchorConstraints:NSLayoutConstraint!
    
    var minimumTopAnchorConstraints:NSLayoutConstraint!
    
    
    var bottomoAnchorConstraints:NSLayoutConstraint!
    
    
    @objc func minimizedPlayerDetails() {
        maximizedTopAnchorConstraints.isActive = false
        bottomoAnchorConstraints.constant = view.frame.height
        minimumTopAnchorConstraints.isActive = true
     
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0) {[weak self] in
            self?.view.layoutIfNeeded()
            self?.tabBar.isHidden = false
            self?.playerDetialsView.maxStackView.alpha = 0
            self?.playerDetialsView.miniStackView.alpha = 1
        
        }
    }
    
    
    func maximizedPlayerDetails(episode:Episode?,episodes:[Episode] = []) {
        minimumTopAnchorConstraints.isActive = false
        maximizedTopAnchorConstraints.isActive = true
        maximizedTopAnchorConstraints.constant = 0
        bottomoAnchorConstraints.constant = 0
           if episode != nil {
               playerDetialsView.episode = episode
           }
        playerDetialsView.playlists = episodes
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0) {[weak self] in
          
            self?.view.layoutIfNeeded()
            self?.tabBar.isHidden = true
            self?.playerDetialsView.maxStackView.alpha = 1
            self?.playerDetialsView.miniStackView.alpha = 0
        
         
        }
    }
   
    
    fileprivate func setUpPlayerDetailView() {
        
    
        
        playerDetialsView.translatesAutoresizingMaskIntoConstraints = false
    
        view.insertSubview(playerDetialsView, belowSubview: tabBar)
        
        minimumTopAnchorConstraints =  playerDetialsView.topAnchor.constraint(equalTo:tabBar.topAnchor,constant: -64)
        
     
        maximizedTopAnchorConstraints =  playerDetialsView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        
        maximizedTopAnchorConstraints.isActive = true
        
        playerDetialsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        playerDetialsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomoAnchorConstraints = playerDetialsView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: view.frame.height)
        
        bottomoAnchorConstraints.isActive = true
       
        
    }
    
    
    
    

}
