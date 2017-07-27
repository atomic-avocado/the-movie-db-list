//
//  Movie.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import ObjectMapper

let ImageBasePath = "https://image.tmdb.org/t/p/w185"

class Movie: Mappable {
    
    var id: Int?
    var voteAverage: Double?
    var genreIds: [Int]?
    var originalTitle: String?
    var backdropImagePath: String?
    var adult: Bool?
    var popularity: Double?
    var posterImagePath: String?
    var title: String?
    var overview: String?
    var originalLanguage: String?
    var voteCount: Double?
    var releaseDate: String?
    var video: Bool?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        voteAverage <- map["vote_average"]
        genreIds <- map["genre_ids"]
        originalTitle <- map["original_title"]
        backdropImagePath <- map["backdrop_path"]
        adult <- map["adult"]
        popularity <- map["popularity"]
        posterImagePath <- map["poster_path"]
        title <- map["title"]
        overview <- map["overview"]
        originalLanguage <- map["original_language"]
        voteCount <- map["vote_count"]
        releaseDate <- map["release_date"]
        video <- map["video"]
    }
    
    func getBackdropURL() -> URL? {
        guard let path = backdropImagePath else { return nil }
        return URL(string: "\(ImageBasePath)\(path)")
    }
    
    func getPosterURL() -> URL? {
        guard let path = posterImagePath else { return nil }
        return URL(string: "\(ImageBasePath)\(path)")
    }
    
}
