//
//  DetailedPodcastVC.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/17/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import UIKit

class DetailedPodcastVC: UIViewController {
    
    var podcast: Podcast?
    
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var podcastArtist: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!
    
    @IBOutlet weak var podcastGenre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        podcastLabel.text = podcast?.collectionName
        podcastArtist.text = podcast?.artistName
        podcastGenre.text = podcast?.genres?.joined()
        
        guard let imageURL = podcast?.artworkUrl100 else {
            podcastImage.image = UIImage(systemName: "mic.fill")
            return
        }
        podcastImage.getImage(with: imageURL) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.sync {
                    self?.podcastImage.image = UIImage(systemName: "mic.fill")
                }
            case .success(let image):
                DispatchQueue.main.sync {
                    self?.podcastImage.image = image
                }
            }
        }
    }
    
    
    @IBAction func favoritedButton(_ sender: UIBarButtonItem) {
        
        let favorite = Podcast(artistName: nil, collectionName: podcast!.collectionName, trackName: podcast?.trackName, artworkUrl100: podcast?.artworkUrl100, artworkUrl600: podcast!.artworkUrl600, primaryGenreName: podcast?.primaryGenreName, genres: podcast?.genres, favoritedBy: podcast?.favoritedBy, trackId: podcast!.trackId)
        
        PodcastsSearchAPIClient.postFave(postFave: favorite) { [weak self, weak sender ] result in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to Favorite Podcast", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success!", message: "Podcast added to Favorites") { alert in
                    self?.dismiss(animated: true)
                }
                }
            }
        }
}
}
