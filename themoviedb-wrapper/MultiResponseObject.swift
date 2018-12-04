//
//  MultiResponseObject.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class MultiResponseObject: NSObject, Codable {
    
    let page:Int?
    let total_results:Int?
    let total_pages:Int?
    let results:[Multi]?
    
}
