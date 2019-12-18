//
//  ViewController.swift
//  Unit 3 Review
//
//  Created by Christian Hurtado on 12/16/19.
//  Copyright © 2019 Christian Hurtado. All rights reserved.
//

import UIKit

class PodcastVC: UIViewController {

    var searchQuery = ""{
        didSet{
            loadData(for: searchQuery)
        }
    }
    
    var podcasts = [Podcast](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData(for: "swift")
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailedPodcastVC = segue.destination as? DetailedPodcastVC,
        let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not segue properly")
        }
        let podcast = podcasts[indexPath.row]
        detailedPodcastVC.podcast = podcast
    }
    
    func loadData(for search: String) {
        PodcastsSearchAPIClient.getPodcasts(for: search) { [weak self] (result) in
               switch result {
               case .failure(let appError):
                   print("Error \(appError)")
               case .success(let podcast):
                self?.podcasts = podcast.sorted {$0.collectionName <  $1.collectionName}
               }
           }
       }
}

extension PodcastVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        let selPodcast = podcasts[indexPath.row]
        cell.configureCell(for: selPodcast)
        return cell
    }
}

extension PodcastVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchQuery = searchText
        guard !searchText.isEmpty else {
            loadData(for: "swift")
            return
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchQuery == "" {
            searchQuery = "swift"
        }
        loadData(for: "\(searchQuery)")
    }
}

extension PodcastVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
