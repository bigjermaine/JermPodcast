//
//  ViewController.swift
//  Pratice12345
//
//  Created by MacBook AIR on 18/09/2023.
//

import UIKit
import CoreGraphics
import Alamofire
class ViewController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    
    let cellId = "CELLiD"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title  = "Search"
    
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling  = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .black
        
        
        
        //Register a cell
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: cellId)
        
        
        
        searchBar(searchController.searchBar, textDidChange: "james")
    }
    
    
    var timer:Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            APiService.shared.fetchSerach(searchText: searchText) { [weak self] result in
                self?.podcasts = result
                self?.tableView.reloadData()
            }
        
        })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
    
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeController = EpisodesTableViewController()
        episodeController.podCast = podcasts[indexPath.row]
         navigationController?.pushViewController(episodeController, animated: true)
    }
}


