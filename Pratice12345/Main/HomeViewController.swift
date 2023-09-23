//
//  SerachViewController.swift
//  Pratice12345
//
//  Created by MacBook AIR on 19/09/2023.
//

import UIKit

class HomeViewController: UITableViewController {
    let cellId = "EpisodeCell"
    var episodes = UserDefaults.standard.dowloadEpisoded()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodes =  UserDefaults.standard.dowloadEpisoded().reversed()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityindicatorView = UIActivityIndicatorView(style: .whiteLarge)
        
        activityindicatorView.color = .systemPink
        activityindicatorView.startAnimating()
        return activityindicatorView
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
    
    
}
