//
//  APIHanlder.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import UIKit
import Foundation


let BASE_URL            = "https://api.themoviedb.org/3/"
let BASE_IMAGE_URL_185  = "http://image.tmdb.org/t/p/w185"
let BASE_IMAGE_URL_500  = "http://image.tmdb.org/t/p/w500"


enum Language : String {
    case English    = "en-us"
    case Arabic     = "ar"
}

enum SearchType : String {
    case Companies      = "company"
    case Collections    = "collection"
    case Keywords       = "keyword"
    case Movies         = "movie"
    case Multi          = "multi"
    case People         = "person"
    case TVShows        = "tv"
    case KnownFor       = "knownFor"
}



class APIHanlder: NSObject {
    static let shared                   = APIHanlder()
    private let timeout:TimeInterval    = 60
    
    var apiKey                      = ""
    var baseURL                     = BASE_URL
    var baseImageURL                = BASE_IMAGE_URL_185
    
    var adultContent                = false
    var preferredLanguage:Language  = .English
    
    
    
    func createURLForSearchType(type:SearchType, withQuery query:String, andPage page:Int) -> String? {
        if self.apiKey.count <= 0 {
            UIAlertController.showAlertView(title: "Error", message: "Please set the API Key first", buttons: ["Ok"], completionHandler: nil)
            return nil
        }else{
            return String.init(format: "%@search/%@?api_key=%@&query=%@&page=%d&language=%@&include_adult=%@", self.baseURL,type.rawValue,self.apiKey, query, page,self.preferredLanguage.rawValue,(self.adultContent ? "true" : "false"))
        }
    }
    
    func getURLRequestFor(url:String) -> URLRequest {        
        let dataURL         = URL.init(string: url)!
        var request         = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: self.timeout)
        request.httpMethod  = "GET"
        return request
    }
    
    func searchForQuery(type:SearchType, searchText text:String, pageNumber page:Int, queryIndex index:Int, completionHandler: @escaping ((_ isSuccessful:Bool, _ responseObject:Any?, _ queryIndex:Int?)->Void)) {
        if let url = self.createURLForSearchType(type: type, withQuery: text, andPage: page) {
            
            let urlRequest  = self.getURLRequestFor(url: url)
            
            let session     = URLSession.shared
            let sessionTask = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
                guard error == nil else {
                    UIAlertController.showAlertView(title: "Error", message: (error?.localizedDescription)!, buttons: ["Ok"], completionHandler: nil)
                    completionHandler(false,nil,nil)
                    return
                }
                
                guard let data = data else {
                    UIAlertController.showAlertView(title: "Error", message: "There is no data available", buttons: ["Ok"], completionHandler: nil)
                    completionHandler(false,nil,nil)
                    return
                }
                
                do {
                    //                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    //                    print(jsonResponse) //Response result
                    
                    var decodedObject:Any!
                    switch type {
                    case .Movies:
                        decodedObject = try JSONDecoder().decode(MovieResponseObject.self, from: data)
                    case .TVShows:
                        decodedObject = try JSONDecoder().decode(TvShowResponseObject.self, from: data)
                    case .People:
                        decodedObject = try JSONDecoder().decode(PeopleResponseObject.self, from: data)
                    case .Multi:
                        decodedObject = try JSONDecoder().decode(MultiResponseObject.self, from: data)
                        
                    default:
                        print("Default")
                    }
                    
                    completionHandler(true,decodedObject,index)
                    
                } catch let error {
                    print(error)
                    UIAlertController.showAlertView(title: "Error", message: error.localizedDescription, buttons: ["Ok"], completionHandler: nil)
                    completionHandler(false,nil,nil)
                }
            }
            sessionTask.resume()
        }
    }
}
