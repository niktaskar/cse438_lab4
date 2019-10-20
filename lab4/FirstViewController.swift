//
//  FirstViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/19/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    var searchResults:APIResults?
    var movies:[Movie] = []
    
//    var apiURL="https://api.themoviedb.org/3/movie/550?api_key=83e605740e47ab5b794527eb5027f719"
    
    var baseURL = "https://api.themoviedb.org/3/search/movie?api_key=83e605740e47ab5b794527eb5027f719"
    
    var api_key="83e605740e47ab5b794527eb5027f719"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        searchBar.delegate = self
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "theCell", for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBar.text)
        grabData(title: searchBar.text ?? "")
    }
    
    func grabData(title: String){
        var queryString = ""
        for char in title{
            if char == " "{
                queryString = "\(queryString)+"
            }else {
                queryString = "\(queryString)\(char)"
            }
        }
        
        let url = "\(baseURL)&query=\(queryString)"
        
    }
    
}

