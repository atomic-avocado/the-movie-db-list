//
//  Movie.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import ObjectMapper

let ImageBasePath = "https://image.tmdb.org/t/p/"

enum ImageSizeOptions: String {
    case width92 = "w92"
    case width154 = "w154"
    case width185 = "w185"
    case width342 = "w342"
    case width500 = "w500"
    case width780 = "w780"
    case original = "original"
}


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
    
    //details
    var belongsToCollection: String?
    var budget: Int?
    var genres: [GenericItem]?
    var homePage: URL?
    var productionCompanies: [GenericItem]?
    var productionCountries: [GenericItem]?
    var revenue: Int?
    var runtime: Int?
    var languages: [GenericItem]?
    var status: String?
    var tagline: String?
    
    
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
        //details
        belongsToCollection <- map["belongs_to_collection"]
        budget <- map["budget"]
        genres <- map["genres"]
        homePage <- map["homepage"]
        productionCompanies <- map["production_companies"]
        productionCountries <- map["production_countries"]
        revenue <- map["revenue"]
        runtime <- map["runtime"]
        languages <- map["spoken_languages"]
        status <- map["status"]
        tagline <- map["tagline"]
    }
    
    func getBackdropURL(with size: ImageSizeOptions) -> URL? {
        guard let path = backdropImagePath else { return nil }
        return URL(string: "\(ImageBasePath)\(size.rawValue)\(path)")
    }
    
    func getPosterURL(with size: ImageSizeOptions) -> URL? {
        guard let path = posterImagePath else { return nil }
        return URL(string: "\(ImageBasePath)\(size.rawValue)\(path)")
    }
    
    func getGenres() -> String? {
        guard let array = genres else { return nil }
        var names: [String] = []
        for item in array {
            if let name = item.name {
                names.append(name)
            }
        }
        return names.joined(separator: ", ")
    }
    
    func getProducers() -> String? {
        guard let array = productionCompanies else { return nil }
        var names: [String] = []
        for item in array {
            if let name = item.name {
                names.append(name)
            }
        }
        return names.joined(separator: ", ")
    }
    
    func getLanguages() -> String? {
        guard let array = languages else { return nil }
        var names: [String] = []
        for item in array {
            if let name = item.name {
                names.append(name)
            }
        }
        return names.joined(separator: ", ")
    }
    
    
}
