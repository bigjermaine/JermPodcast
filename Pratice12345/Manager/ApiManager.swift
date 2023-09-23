//
//  ApiManager.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import Foundation
import Alamofire


class APiService {
    
    static let shared = APiService()
    
    let url =  "https://itunes.apple.com/search"
    
    
     func fetchSerach(searchText:String,completionHandler: @escaping([Podcast]) -> ()) {
         let parameter = ["term":searchText,"media":"podcast"]
        AF.request(url,parameters: parameter,encoding: URLEncoding.default).response { response in
            if let error = response.error {
                print(error)
                return
            }
            guard let response = response.data else {return}
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self,from: response)
                completionHandler(searchResult.results)
            }catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}


class SearchResult: NSObject, NSCoding, Decodable {
    let resultCount: Int
    let results: [Podcast]

    init(resultCount: Int, results: [Podcast]) {
        self.resultCount = resultCount
        self.results = results
    }

    // MARK: - NSCoding

    required convenience init?(coder aDecoder: NSCoder) {
        guard let resultCount = aDecoder.decodeObject(forKey: "resultCount") as? Int,
              let results = aDecoder.decodeObject(forKey: "results") as? [Podcast]
        else {
            return nil
        }

        self.init(resultCount: resultCount, results: results)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(resultCount, forKey: "resultCount")
        aCoder.encode(results, forKey: "results")
    }
}
