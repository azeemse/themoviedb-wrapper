//
//  TvShow.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class TvShow: NSObject, Codable {

    //Common
    let poster_path:String?
    let id:Int64?
    let overview:String?
    let genre_ids:[Int]?
    let media_type:String?
    let original_language:String?
    let backdrop_path:String?
    let popularity:Int?
    let vote_count:Int?
    let vote_average:Int?
    let adult:Bool?
    let name:String?
    
    // TV
    let first_air_date:String?
    let origin_country:[String]?
    let original_name:String?
    
}
