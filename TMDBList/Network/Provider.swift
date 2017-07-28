//
//  Provider.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class Provider<Target>: RxMoyaProvider<Target> where Target: TargetType {
    
    private let defaultEnclosure: (Target) -> Endpoint<Target> = { (target) -> Endpoint<Target> in
        let endpoint: Endpoint<Target> = Endpoint<Target>(url: "\(target.baseURL)\(target.path)",
            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: URLEncoding(),
            httpHeaderFields: [
                "Accept": "*/*",
                ])
        
        return endpoint
    }
    
    init() {
        super.init(endpointClosure: defaultEnclosure,
                   requestClosure: MoyaProvider.defaultRequestMapping,
                   stubClosure: MoyaProvider.neverStub,
                   manager: RxMoyaProvider<Target>.defaultAlamofireManager(),
                   plugins: [NetworkLoggerPlugin(verbose: true, output: Helper.reversedPrint, responseDataFormatter: Helper.JSONResponseDataFormatter)],
                   trackInflights: false)
    }
    
}

extension ObservableType where E == Moya.Response {
    func processResponse() -> Observable<Moya.Response> {
        return flatMapLatest { response -> Observable<Moya.Response> in
            if response.statusCode >= 200 && response.statusCode <= 299 {
                return Observable.just(response)
            } else {
                return Observable.error(NSError(domain: "Error", code: response.statusCode, userInfo: nil))
            }
        }
    }
}
