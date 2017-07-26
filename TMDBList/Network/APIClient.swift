//
//  APIClient.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import ObjectMapper
import Moya_ObjectMapper

let DefaultProvider = Provider<Target>()

class APIClient {
    static func getUpcoming(page: Int? = 1) -> Observable<RequestResult> {
        return DefaultProvider.request(.getUpcoming(page: page))
            .processResponse()
            .mapObject(RequestResult.self)
    }
}
