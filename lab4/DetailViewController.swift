//
//  DetailViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/20/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
class DetailViewController: UIViewController {
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var myTitle: String = ""
    var myRating: String = ""
    var myScore: String = ""
    var myRelease: String = ""
    var bigImage: UIImage? = nil
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBOutlet weak var savePosterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = myTitle
        releaseLabel.text = myRelease
        scoreLabel.text = myScore
        ratingLabel.text = myRating
        movieImage.image = bigImage
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        let dbPath = Bundle.main.path(forResource: "favoritesData", ofType: "db")
        
        let contactDB = FMDatabase(path: dbPath)
        
        if !(contactDB.open()){
            print("Unable to open DB")
            return
        } else {
            do {
                let results = try contactDB.executeUpdate("INSERT INTO movies (title) values(?)", withArgumentsIn: [titleLabel.text ?? ""])
                
                if(results != nil ){
                    print("inserted")
                }
            } catch let error as NSError{
                print("Error \(error)")
            }
        }
        contactDB.close()
    }
    
    func getURL() -> String{
        let title = titleLabel.text!
        var queryString = ""
        for char in title{
            if char == " "{
                queryString = "\(queryString)+"
            }else {
                queryString = "\(queryString)\(char)"
            }
        }
        var url = "https://www.themoviedb.org/search?query=\(queryString)&language=en-US"
        
        return url
    }
    
    @IBAction func getMoreInfo(_ sender: Any) {
        let theUrl = getURL()
        let svc = SFSafariViewController(url: URL(string: theUrl)!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        var image = movieImage
        UIImageWriteToSavedPhotosAlbum(movieImage.image!, nil, nil, nil)

    }
}
