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
    
    var baseURL = "https://api.themoviedb.org/3/search/movie?api_key=83e605740e47ab5b794527eb5027f719"
    
    var api_key="83e605740e47ab5b794527eb5027f719"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        searchBar.delegate = self
        
//        grabData(title: "National Treasure")
//        cacheImages()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateData(title: searchBar.text ?? "")
        cacheImages()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "theCell", for: indexPath) as! MyCollectionViewCell
//        collectionView.reloadItems(at: [indexPath.row])
        cell.myLabel.text = movies[indexPath.row].title
        if(indexPath.row < imageCache.count){
            cell.myImageView.image = imageCache[indexPath.row]
        }
        
        return cell
    }
    
//    func removeCells(count: Int){
//
//    }
    
    func grabData(title: String){
        let queryString = createQueryString(input: title)
        let url = "\(baseURL)&query=\(queryString)"
        
        let finalURL = URL(string: url)
        
        let data = try! Data(contentsOf: finalURL!)
        searchResults = try! JSONDecoder().decode(APIResults.self, from: data)
        
        var fullMovieList = searchResults!.results
        var len = 0
        if fullMovieList.count > 20{
            len = 20
        } else {
            len = fullMovieList.count
        }
        
        movies = []
        for i in 0 ..< len{
            movies.append(fullMovieList[i])
        }
//        for movie in movies{
//            print(movie.title)
//        }
        
//        collectionView.performBatchUpdates({
//            let updateIndexPaths = Array(0...movies.count-1).map({IndexPath(item: $0, section:
//                0)})
//            collectionView.insertItems(at: updateIndexPaths)
//        }, completion: nil)
        
    }
    
    func updateData(title: String){
        let prevCount = movies.count
//        print(prevCount)
        grabData(title: title)
        let newCount = movies.count
//        print(newCount)
        collectionView.performBatchUpdates({
            if(prevCount > 0){
                let deleteIndexPaths = Array(0...prevCount-1).map({IndexPath(item: $0, section:
                    0)})
                collectionView.deleteItems(at: deleteIndexPaths)
            }
            let updateIndexPaths = Array(0...newCount-1).map({IndexPath(item: $0, section:
                0)})
            collectionView.insertItems(at: updateIndexPaths)
        }, completion: nil)
    }
    
    func cacheImages(){
        var prevImage:UIImage = UIImage()
        for item in movies{
//            if item.poster_path != nil{
            let url = URL(string: "http://image.tmdb.org/t/p/w185\(item.poster_path ?? "")")
            let data = try? Data.init(contentsOf: url!)
            if data != nil{
                let image = UIImage(data: data!)
                prevImage = image!
                if !imageCache.contains(image!){
                    imageCache.append(image!)
                }
            } else {
                imageCache.append(prevImage)
            }
//                if !imageCache.contains(image!){
            
//                }
//            }
        }
    }
    
}

