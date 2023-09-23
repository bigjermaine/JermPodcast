//
//  UserDefaults.swift
//  Pratice12345
//
//  Created by MacBook AIR on 23/09/2023.
//

import Foundation


extension UserDefaults {
    
    static let favoritePodcastKey = "favoritePodcastKey"
    static let dowloadedEpisodeKey = "dowloadedEpisodeKey"
    
    
    func dowloadEpisode(episode:Episode) {
        var downLoadedEpisodes = dowloadEpisoded()
        downLoadedEpisodes.append(episode)
        
        do {
            let data = try JSONEncoder().encode( downLoadedEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.dowloadedEpisodeKey)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func dowloadEpisoded() -> [Episode] {
        guard let data = UserDefaults.standard.data(forKey:UserDefaults.dowloadedEpisodeKey) else { return
         []
        }
        do {
            let result =   try JSONDecoder().decode([Episode].self, from: data)
            
        return result
        }catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    func favorites() -> [Podcast] {
        do {
            guard let data = UserDefaults.standard.data(forKey:UserDefaults.favoritePodcastKey) else { return
             []
            }
            guard let podcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast] else {return []}
                return  podcast
         } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
}
