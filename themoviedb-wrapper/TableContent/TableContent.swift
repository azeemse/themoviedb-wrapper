//
//  TableContent.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit

class TableContent: NSObject {
    var searchQuery:String  = ""
    
    var pageNumber:Int      = 1
    var totalPages:Int      = 0
    var totalResults:Int    = 0
    
    var content             = NSMutableArray.init()
    
    init(query:String, andContent content:NSMutableArray) {
        self.searchQuery    = query
        self.content        = content
    }
}
