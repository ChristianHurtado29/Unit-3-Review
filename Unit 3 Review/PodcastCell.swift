//
//  PodcastCellTableViewCell.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/16/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastName: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var primaryGenreLabel: UILabel!
    
    func configureCell(for podcast: Podcast) {
        podcastName?.text = podcast.collectionName
        artistLabel?.text = podcast.artistName
        primaryGenreLabel?.text = podcast.primaryGenreName
        
        // configure image view
        guard let imageURL = podcast.artworkUrl100 else {
            podcastImage.image = UIImage(systemName: "mic.fill")
            return
        }
        
        podcastImage?.getImage(with: imageURL) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.sync {
                    self?.podcastImage.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.sync {
                    self?.podcastImage.image = image
                }
            }
        }
    }
}
