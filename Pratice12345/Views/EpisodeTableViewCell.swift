//
//  EpisodeTableViewCell.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import UIKit
import AVKit
class EpisodeTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var episodeImageview: UIImageView!
    
    @IBOutlet weak var episodeDateLabel: UILabel!
    
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    
    var episode:Episode! {
        didSet{
            episodeDescriptionLabel.text =  episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "MMM dd, yyyy"
            episodeDateLabel.text = dateFormatter.string(from: episode.pubDate)
            guard let url = URL(string:episode.imageUrl ?? "") else {return}
            episodeImageview.sd_setImage(with:url)
         
            
            
        }
    }
    
    
    
  
}
