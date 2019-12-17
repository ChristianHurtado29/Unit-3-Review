//
//  PodcastsAPIClient.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/17/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import Foundation

struct PodcastsSearchAPIClient  {
    
    static func getPodcasts(for searchQuery: String,
                            completion: @escaping (Result<[Podcast], AppError>) -> ()) {
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ??
        "swift"
        
        let podcastEndpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        guard let url = URL(string: podcastEndpointURL) else {
            completion(.failure(.badURL(podcastEndpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let searchResults = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    
                    let podcasts = searchResults.results
                    
                    completion(.success(podcasts))
                } catch {
                }
            }
        }
    }
}
