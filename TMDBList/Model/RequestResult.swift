//
//  RequestResult.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import ObjectMapper

class RequestResult: Mappable {
    
    var results: [Movie]?
    var totalPages: Int?
    var totalResults: Int?
    var page: Int?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        results <- map["results"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        page <- map["page"]
    }

}
