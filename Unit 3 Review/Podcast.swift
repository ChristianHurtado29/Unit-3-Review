//
//  Podcast.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/17/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import Foundation

struct PodcastSearch: Decodable {
    let results: [Podcast]
}

struct Podcast: Decodable {
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl100: String
    let primaryGenreName: String
    let genres: [String]
}
