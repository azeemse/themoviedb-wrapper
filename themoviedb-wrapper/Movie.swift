//
//  Movie.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class Movie: NSObject, Codable {
    
    let poster_path:String?
    let adult:Bool?
    let overview:String?
    let release_date:String?
    let genre_ids:[Int]?
    let id:Int64?
    let original_title:String?
    let original_language:String?
    let title:String?
    let backdrop_path:String?
    let popularity:Double?
    let vote_count:Int?
    let video:Bool?
    let vote_average:Double?
}
