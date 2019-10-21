//
//  DetailViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/20/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import Foundation
import UIKit

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
}
