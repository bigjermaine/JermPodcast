//
//  FavoriteViewController.swift
//  Pratice12345
//
//  Created by MacBook AIR on 19/09/2023.
//

import UIKit

class FavoriteViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
  
    
    var podcasts = UserDefaults.standard.favorites()
    
    fileprivate let cellId = "CellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpCollectionView() 
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.favorites()
        collectionView.reloadData()
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                mainTabbarController.viewControllers?[0].tabBarItem.badgeValue = nil
            } else {
                print("Could not cast rootViewController to MainTabBarViewController")
            }
            
            
        }
    }
        
    
    
    func setUpCollectionView() {
        view.backgroundColor = .purple
        collectionView.backgroundColor = .white
        collectionView.register(favoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        let location = gesture.location(in: collectionView)

        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }

        let alertController = UIAlertController(title: "Remove Podcast", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove the podcast from your local data source (self.podcasts)
            self.podcasts.remove(at: selectedIndexPath.item)

            // Update the UI to reflect the removal
            self.collectionView.deleteItems(at: [selectedIndexPath])

            // Remove the podcast from UserDefaults
            let podcastToRemove = self.podcasts[selectedIndexPath.row]
            print(podcastToRemove)
//            var listPodcasts = UserDefaults.standard.favorites()
//
//            if let index = listPodcasts.firstIndex(where: { $0.trackName == podcastToRemove.trackName }) {
//                listPodcasts.remove(at: index)
//            }
//
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: listPodcasts, requiringSecureCoding: false)
//                UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
//                print("Podcast removed and info saved to UserDefaults")
//            } catch {
//                print(error.localizedDescription)
//            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodeController = EpisodesTableViewController()
        episodeController.podCast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodeController, animated: true)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! favoritePodcastCell
        cell.podcast =  podcasts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width =  (view.frame.width - 3 * 10)/2
       return CGSize(width:width, height:width + 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
