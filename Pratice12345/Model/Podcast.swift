//
//  Podcast.swift
//  Pratice12345
//
//  Created by MacBook AIR on 19/09/2023.
//

import Foundation


class Podcast:NSObject,NSCoding,Codable {
    func encode(with coder: NSCoder) {
        print("converting podcast to data")
        coder.encode(trackName ?? "",forKey:"trackName")
        coder.encode(artistName ?? "" ,forKey: "artistName")
        coder.encode(artworkUrl600 ?? "",forKey: "artworkUrl600")
        coder.encode(feedUrl ?? "", forKey: "feedUrl")
    }
    
    required init?(coder: NSCoder) {
        print("converting data to podcast")
        self.trackName = coder.decodeObject(forKey:"trackName") as? String
        self.artistName = coder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl600  = coder.decodeObject(forKey:"artworkUrl600") as? String
        self.feedUrl = coder.decodeObject(forKey:"feedUrl") as? String
    }
    
    var trackName:String?
    var artistName:String?
    var artworkUrl600:String?
    var trackCount:Int?
    var feedUrl:String?
    
    
}
