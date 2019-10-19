//
//  SecondViewController.swift
//  lab4
//
//  Created by Nikash Taskar on 10/19/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource {
    
//    var favorites: [Movie]
    var favorites: [String]
        = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        let path = Bundle.main.path(forResource: "Favorite", ofType: "plist")
        
        let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        
        let array = dict.object(forKey: "Favorites") as! Array<String>
        
        for fave in array{
            favorites.append(fave)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel!.text = favorites[indexPath.row]
        return cell
    }


}

