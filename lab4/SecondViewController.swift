//
//  SecondViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/19/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource {
    
    var favorites: [Movie] = []
//    var favorites: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel!.text = favorites[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let title = favorites[indexPath.row].title
            deleteDB(title: title)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func loadData(){
        let dbPath = Bundle.main.path(forResource: "favoritesData", ofType: "db")
        
        let contactDB = FMDatabase(path: dbPath)
        
        if !(contactDB.open()){
            print("Unable to open DB")
            return
        } else {
            do {
                let results = try contactDB.executeQuery("SELECT * FROM movies", values: nil)
                while(results.next()){
                    let id = results.int(forColumn: "id")
                    let poster_path = results.string(forColumn: "poster_path")
                    let title = results.string(forColumn: "title")
                    let release_date = results.string(forColumn: "release_date")
                    let vote_average = results.double(forColumn: "vote_average")
                    let overview = results.string(forColumn: "overview")
                    let vote_count = results.int(forColumn: "vote_count")
                    
                    let jsonString = """
                                {
                                    "id": \(id),
                                    "poster_path": "\(poster_path ?? "")",
                                    "title": "\(title ?? "")",
                                    "release_date": "\(release_date ?? "")",
                                    "vote_average": \(vote_average),
                                    "overview": "\(overview ?? "")",
                                    "vote_count": \(vote_count)
                                }
                                """.data(using: .utf8)!
                    
                    let movie = try JSONDecoder().decode(Movie.self, from: jsonString)
//                    print(movie)
                    favorites.append(movie)

                }
            } catch let error as NSError{
                print("Error \(error)")
            }
        }
        contactDB.close()
    }
    
    func deleteDB(title: String){
        print(title)
        let dbPath = Bundle.main.path(forResource: "favoritesData", ofType: "db")
        
        let contactDB = FMDatabase(path: dbPath)
        
        if !(contactDB.open()){
            print("Unable to open DB")
            return
        } else {
            do {
                let results = try contactDB.executeUpdate("DELETE FROM movies WHERE title=?", withArgumentsIn: ["\(title)"])
                
                if(results != nil ){
                    print("deleted")
                }
            } catch let error as NSError{
                print("Error \(error)")
            }
        }
        contactDB.close()
    }

}


