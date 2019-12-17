//
//  Podcast.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/17/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import Foundation

struct PodcastSearch: Codable {
    let results: [Podcast]
}

struct Podcast: Codable {
    let artistName: String?
    let collectionName: String
    let trackName: String?
    let artworkUrl100: String?
    let artworkUrl600: String
    let primaryGenreName: String?
    let genres: [String]?
    let favoritedBy: String?
    let trackId: Int
}
