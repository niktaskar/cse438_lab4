//
//  FirstViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/19/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import UIKit
import SQLite3
class FirstViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    var searchResults:APIResults?
    var movies:[Movie] = []
    var imageCache:[UIImage] = []
    var backgroundColor = UIColor.white
    var textColor = UIColor.gray
    
    @IBOutlet weak var darkModeButton: UIBarButtonItem!
    
    var baseURL = "https://api.themoviedb.org/3/search/movie?api_key=83e605740e47ab5b794527eb5027f719"
    
    var api_key="83e605740e47ab5b794527eb5027f719"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        searchBar.delegate = self
        
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
//        self.collectionView.addSubview(self.activityIndicator)
//        self.activityIndicator.isHidden = true
        self.activityIndicator.backgroundColor = UIColor.clear
        collectionView.backgroundColor = backgroundColor

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" && searchBar.text != nil{

//            self.collectionView.addSubview(self.activityIndicator)
//            print("Test")
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
//                print("Here")
                self.updateData(title: searchBar.text ?? "")
                self.cacheImages()
                DispatchQueue.main.async{
//                    print("DOGW")
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
//                print("Try")
            }
//            print("ME")
//            self.activityIndicator.isHidden = false
        }
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
                cell.myLabel.textColor = self.textColor
                cell.myLabel.text = self.movies[indexPath.row].title
                let path = self.movies[indexPath.row].poster_path
                
                if (path == "") {
                    cell.myImageView.image = UIImage(contentsOfFile: "noImage.jpg")
                } else if (indexPath.row < self.imageCache.count){
                    cell.myImageView.image = self.imageCache[indexPath.row]
                }
        return cell
    }
    
    func grabData(title: String){
        movies = []
        let queryString = createQueryString(input: title)
        let url = "\(baseURL)&query=\(queryString)"
        
        let finalURL = URL(string: url)
        
        let data = try! Data(contentsOf: finalURL!)
        do{
            searchResults = try! JSONDecoder().decode(APIResults.self, from: data)
        } catch let error as NSError {
            print(error)
        }
        if searchResults != nil{
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
        } else {
            movies = []
        }
    }
    
    func updateData(title: String){
        let prevCount = movies.count
        grabData(title: title)
        collectionView.reloadData()
    }
    
    func cacheImages(){
        imageCache = []
        for item in movies{

            let path = item.poster_path ?? ""
            if path != ""{
                let url = URL(string: "http://image.tmdb.org/t/p/w185\(path)")
                let data = try? Data.init(contentsOf: url!)
                if data != nil{
                    let image = UIImage(data: data!)
                    if !imageCache.contains(image!){
                        imageCache.append(image!)
                    }
                } else {
                    print("No Image")
                }
                
            }

        }
    }
    
    @IBAction func darkModeToggle(_ sender: Any) {
        if backgroundColor == UIColor.white{
            backgroundColor = UIColor.black
        } else{
            backgroundColor = UIColor.white
        }
        collectionView.backgroundColor = backgroundColor
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
                destination.myRating = "Rating: \(theMovie!.vote_average)"
                destination.myScore = "Votes: \(theMovie!.vote_count!)"
                
                let url = URL(string: "http://image.tmdb.org/t/p/w500\(theMovie!.poster_path ?? "")")
                let data = try? Data.init(contentsOf: url!)
                if(data != nil){
                    destination.bigImage = UIImage(data: data!)
                }
                
            }
        }
    }
    
}

