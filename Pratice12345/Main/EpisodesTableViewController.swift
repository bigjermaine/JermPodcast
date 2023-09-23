//
//  EpisodesTableViewController.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import UIKit
import FeedKit
class EpisodesTableViewController: UITableViewController {

    var podCast:Podcast? {
        didSet{
            navigationItem.title = podCast?.trackName
        }
    }
  
    var episodes = [Episode
    ]()
    
    
    let cellId = "EpisodeCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupNavBar()
      
        fetchEpisodes()
     
        setupTableView()
      
       
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: cellId)
        
        setUpNavigationBarButtons()
    }
    
    
    fileprivate func setUpNavigationBarButtons() {
        
        let savedPodcasts = UserDefaults.standard.favorites()

        if let index = savedPodcasts.firstIndex(where: { $0.trackName == podCast?.trackName }) {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(image:UIImage(systemName: "heart.fill"),style: .plain, target: self, action:nil)]
        } else {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "favorite",style: .plain, target: self, action: #selector(handleFavorite))]
        }

        
      
    }

 
    
    
    @objc func handleFavorite() {
        guard let podcast = self.podCast else { return }
        var listPodcasts = UserDefaults.standard.favorites()
        listPodcasts.append(podcast)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject:listPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
            print("saving info to userdefaults")
        } catch {
            print(error.localizedDescription)
        }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image:UIImage(systemName: "heart.fill"),style: .plain, target: self, action:nil)]
        
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                mainTabbarController.viewControllers?[2].tabBarItem.badgeValue = "New"
            } else {
                print("Could not cast rootViewController to MainTabBarViewController")
            }
        } else {
            print("No key window found")
        }

     }

    
    @objc func handleFetch() {
       let  listPodcasts = UserDefaults.standard.favorites()
        print(listPodcasts.first?.trackName)
    }

    //MARK:
    func setupNavBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
     
    }
    
    //Mark:
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:  cellId)
     
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityindicatorView = UIActivityIndicatorView(style: .whiteLarge)
        
        activityindicatorView.color = .systemPink
        activityindicatorView.startAnimating()
        return activityindicatorView
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dowlaodAction = UITableViewRowAction(style: .normal, title: "dowload") { _, _ in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.dowloadEpisode(episode: episode)
        }
        
        return [dowlaodAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ?  200 : 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            if let mainTabbarController = window.rootViewController as? MainTabBarViewController {
                mainTabbarController.maximizedPlayerDetails(episode: episode,episodes:episodes)
            } else {
                print("Could not cast rootViewController to MainTabBarViewController")
            }
        } else {
            print("No key window found")
        }
     
    }
    
 
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeTableViewCell else {return UITableViewCell()}
        let episode = episodes[indexPath.row]
        cell.episode =   episode
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podCast?.feedUrl else {return}
        guard let url = URL(string: feedUrl.toSecureHttps()) else {return}
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser.parseAsync(result: { result in
                
                print("sucessfully")
                switch result {
                case .success(let feed):
                    
                    switch feed {
                    case let .atom(_):
                        break       // Atom Syndication Format Feed Model
                    case let .rss(feed):
                        
                        var imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
                        feed.items?.forEach({ feeditem in
                            print(feeditem.title ?? "")
                            var episode = Episode(feedItem: feeditem)
                            DispatchQueue.main.async {[weak self] in
                                if episode.imageUrl == nil {
                                    episode.imageUrl = imageUrl?.toSecureHttps()
                                }
                                episode.imageUrl = imageUrl
                                self?.episodes.append(episode)
                                self?.tableView.reloadData()
                            }
                            
                        })
                    case let .json(_):  break
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
        }
}
