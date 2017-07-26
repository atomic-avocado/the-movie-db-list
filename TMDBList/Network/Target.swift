//
//  Target.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import Moya
import RxSwift



enum Target {
    case getUpcoming(page: Int?)
}

extension Target: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3/")! }
    
    var path: String {
        switch self {
        case .getUpcoming:
            return "movie/upcoming"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUpcoming:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var parameters: [String: Any] = ["api_key":"1f54bd990f1cdfb230adb312546d765d"]
        switch self {
        case .getUpcoming(let page):
            if let page = page {
                parameters["page"] = page as Any
            }
        }
        return parameters
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var task: Task {
        return Task.request
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
