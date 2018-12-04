//
//  KnownFor.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class KnownFor: NSObject, Codable {

    //Common
    let poster_path:String?
    let id:Int64?
    let overview:String?
    let genre_ids:[Int]?
    let media_type:String?
    let original_language:String?
    let backdrop_path:String?
    let popularity:Double?
    let vote_count:Int?
    let vote_average:Double?
    let adult:Bool?
    let name:String?
    
    // Movie
    let release_date:String?
    let original_title:String?
    let title:String?
    let video:Bool?
    
    // TV
    let first_air_date:String?
    let origin_country:[String]?
    let original_name:String?
    
}
