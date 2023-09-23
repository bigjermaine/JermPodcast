//
//  PodcastCell.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import Foundation
import UIKit
import SDWebImage

class PodcastCell:UITableViewCell {
    
    
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var trackName: UILabel!
    
    @IBOutlet weak var episodeCount: UILabel!
    
    @IBOutlet weak var artistName: UILabel!
    
    
    var podcast:Podcast! {
        
        didSet{
            trackName.text = podcast.trackName
            artistName.text = podcast.artistName
            episodeCount.text = "\(podcast.trackCount ?? 0)"
            guard let url = podcast.artworkUrl600?.toSecureHttps() else {return}
            podcastImageView.sd_setImage(with: URL(string:  url))
        }
        
        
    }
    
    
    
    
}
