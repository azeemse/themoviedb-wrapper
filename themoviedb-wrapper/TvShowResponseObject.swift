//
//  TvShowResponseObject.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class TvShowResponseObject: NSObject, Codable {

    let currentPage:Int
    let totalResults:Int
    let totalPages:Int
    let arrayData:[TvShow]
    
}
