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
        podcastGenre.text = podcast?.genres!.joined()
        podcastImage.getImage(with: podcast!.artworkUrl100!) { [weak self] (result) in
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
    
    
    @IBAction func favoritedButton(_ sender: UIBarButtonItem) {
        
        let favorite = Favorites(collectionName: podcast!.collectionName,
                                 artworkUrl600: podcast!.artworkUrl600,
                                 favoritedBy: "Christian Hurtado")
        
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
