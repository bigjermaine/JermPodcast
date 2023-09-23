//
//  Episode.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import Foundation
import FeedKit
struct Episode:Codable {
    let title:String
    let pubDate:Date
    var imageUrl:String?
    let description:String
    let author:String
    let streamUrl:String
    
    init(feedItem:RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate =  feedItem.pubDate ?? Date()
        self.description =  feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
