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
    
    static func postFave (postFave: Favorites,
                          completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        
        let faveEndpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: faveEndpointURL) else {
            return
        }
        
        do {
        let data = try JSONEncoder().encode(postFave)
            
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = data
        
            request.httpMethod = "POST"
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                        switch result {
                        case .failure(let appError):
                            completion(.failure(.networkClientError(appError)))
                        case .success:
                            completion(.success(true))
                        }
                    }
                } catch {
                    completion(.failure(.encodingError(error)))
                }
            }
    }
