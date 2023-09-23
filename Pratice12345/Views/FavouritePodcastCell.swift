//
//  FavouritePodcastCell.swift
//  Pratice12345
//
//  Created by MacBook AIR on 23/09/2023.
//

import Foundation
import UIKit

class favoritePodcastCell:UICollectionViewCell {
    
    let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
    let nameLabel = UILabel()
    let artistNamelabel = UILabel()
    var podcast:Podcast! {
        didSet{
            nameLabel.text = podcast.trackName
            artistNamelabel .text = podcast.artistName
            guard let url = podcast.artworkUrl600?.toSecureHttps() else {return}
            imageView.sd_setImage(with: URL(string:  url))
        }
        
    }
    
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        nameLabel.text = "PodcastName"
        nameLabel.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        nameLabel.textColor = .black
        
        artistNamelabel.text = "Podcase Artist"
        artistNamelabel .font = UIFont.systemFont(ofSize: 14,weight: .bold)
        artistNamelabel.textColor = .black.withAlphaComponent(0.5)
        
        
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel,artistNamelabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
       
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
