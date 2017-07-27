//
//  GenericItem.swift
//  TMDBList
//
//  Created by Victor Robertson on 27/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import ObjectMapper

class GenericItem: Mappable {
    
    var id: Int?
    var iso6391: String?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        iso6391 <- map["iso_639_1"]
    }
}
