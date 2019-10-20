//
//  Movie.swift
//  lab4
//
//  Created by Nikash Taskar on 10/19/19.
//  Copyright © 2019 Nikash Taskar. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    
    init(){
        self.id = 0
        self.poster_path = ""
        self.title = ""
        self.release_date = ""
        self.vote_average = 0.0
        self.overview = ""
        self.vote_count = 0
    }
    
    //    init(id: Int, poster_path: String, title: String, release_date: String, vote_average: Double, overview: String, vote_count: Int) {
    //        self.id = id
    //        self.poster_path = poster_path
    //        self.title = title
    //        self.release_date = release_date
    //        self.vote_average = vote_average
    //        self.overview = overview
    //        self.vote_count = vote_count
    //    }
}

//struct Movie: Codable {
//    let id: Int!
//    let poster_path: String?
//    let title: String
//    let release_date: String
//    let vote_average: Double
//    let overview: String
//    let vote_count:Int!
//}
