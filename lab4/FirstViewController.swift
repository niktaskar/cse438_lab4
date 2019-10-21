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
//        cell.activityIndicator
        cell.activityIndicator.hidesWhenStopped = true
        cell.activityIndicator.style = UIActivityIndicatorView.Style.gray
        cell.addSubview(cell.activityIndicator)
        cell.activityIndicator.startAnimating()
        
//        collectionView.reloadItems(at: [indexPath.row])
        cell.myLabel.text = movies[indexPath.row].title
        let path = movies[indexPath.row].poster_path
        
        if (path == "") {
            cell.myImageView.image = UIImage(contentsOfFile: "noImage.jpg")
        } else if (indexPath.row < imageCache.count){
            print(indexPath.row)
            cell.myImageView.image = imageCache[indexPath.row]
        }
        cell.activityIndicator.stopAnimating()
        return cell
    }
    
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
//        print(movies[0])
//        cacheImages()
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
        imageCache = []
//        var prevImage:UIImage = UIImage()
        for item in movies{
//            if item.poster_path != nil{
//            print(item.poster_path)
            let path = item.poster_path ?? ""
            if path != ""{
                let url = URL(string: "http://image.tmdb.org/t/p/w185\(path)")
                let data = try? Data.init(contentsOf: url!)
                if data != nil{
                    let image = UIImage(data: data!)
//                    prevImage = image!
                    if !imageCache.contains(image!){
                        imageCache.append(image!)
                    }
                } else {
//                    imageCache.append(prevImage)
                    print("No Image")
                }
                
            }
//                if !imageCache.contains(image!){
            
//                }
//            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieCell: MyCollectionViewCell = (sender as? MyCollectionViewCell)!
        if let collectionView: UICollectionView = movieCell.superview as? UICollectionView {
            if let destination = segue.destination as? DetailViewController{
//                destination.myTitle = movies[collectionView.tag+1].title
                destination.myTitle = movieCell.myLabel.text ?? ""
                var theMovie: Movie?
                for movie in movies{
                    if movie.title == movieCell.myLabel.text {
                        theMovie = movie
                        break;
                    }
                }
                
                destination.myRelease = "Released: \(theMovie!.release_date)"
//                    ?? "Released: Not Yet Released"
                destination.myRating = "Rating: \(theMovie!.vote_average)"
//                    ?? "Rating: N/A"
                destination.myScore = "Votes: \(theMovie!.vote_count!)"
//                    ?? "Votes: N/A"
                
                let url = URL(string: "http://image.tmdb.org/t/p/w500\(theMovie!.poster_path ?? "")")
                let data = try? Data.init(contentsOf: url!)
                if(data != nil){
                    destination.bigImage = UIImage(data: data!)
                }
            }
        }
    }
    
}

