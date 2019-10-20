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
    var imageCache:[UIImage] = []
    
//    var apiURL="https://api.themoviedb.org/3/movie/550?api_key=83e605740e47ab5b794527eb5027f719"
    
    var baseURL = "https://api.themoviedb.org/3/search/movie?api_key=83e605740e47ab5b794527eb5027f719"
    
    var api_key="83e605740e47ab5b794527eb5027f719"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        searchBar.delegate = self
        
        grabData(title: "National Treasure")
        cacheImages()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "theCell", for: indexPath) as! MyCollectionViewCell
        cell.myLabel.text = movies[indexPath.row].title
        
        cell.myImageView.image = imageCache[indexPath.row]

        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        grabData(title: searchBar.text ?? "")
    }
    
    func createQueryString(input: String) -> String {
        var queryString = ""
        for char in input{
            if char == " "{
                queryString = "\(queryString)+"
            }else {
                queryString = "\(queryString)\(char)"
            }
        }
        return queryString
    }
    
    func grabData(title: String){
        var queryString = createQueryString(input: title)
        let url = "\(baseURL)&query=\(queryString)"
        
        let finalURL = URL(string: url)
        
        let data = try! Data(contentsOf: finalURL!)
        var searchResults = try! JSONDecoder().decode(APIResults.self, from: data)
//        print(searchResults)
        var fullMovieList = searchResults.results
        var len = 0
        if fullMovieList.count > 20{
            len = 20
        } else {
            len = fullMovieList.count
        }
        
        for i in 0 ..< len{
            movies.append(fullMovieList[i])
        }
        print(movies)
        for movie in movies{
            print(movie.title)
        }
        
    }
    
    func cacheImages(){
        for item in movies{
            let url = URL(string: item.poster_path!)
            let data = try? Data.init(contentsOf: url!)
            let image = UIImage(data: data!)
            if !imageCache.contains(image!){
                imageCache.append(image!)
            }
        }
    }
    
}

