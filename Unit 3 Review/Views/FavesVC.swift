//
//  FavesVC.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/17/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import UIKit

class FavesVC: UIViewController {
    
    var favorites = [Podcast](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData(for: favorites)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailedPodcastVC = segue.destination as? DetailedPodcastVC,
        let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not segue properly")
        }
        let faves = favorites[indexPath.row]
        detailedPodcastVC.podcast = faves
        detailedPodcastVC.podcast?.artistName = faves.favoritedBy
    }
    
    
    func loadData(for favorites: [Podcast]) {
        PodcastsSearchAPIClient.getFaves(for: favorites) {[weak self] (result) in
            switch result {
            case .failure(let appError):
                print("Error \(appError)")
            case .success(let podcast):
                self?.favorites = podcast.sorted {$0.collectionName < $1.collectionName}
            }
        }
    }
}
    extension FavesVC: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            favorites.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavesCell", for: indexPath) as! PodcastCell
            
            let selFave = favorites[indexPath.row]
            cell.configureCell(for: selFave)
            return cell
        }
}

extension FavesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
