//
//  MovieDetailViewModel.swift
//  TMDBList
//
//  Created by Victor Robertson on 27/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewModel {
    
    var disposeBag = DisposeBag()
    let error = Variable<NSError?>(nil)
    
    var movie = Variable<Movie?>(nil)
    
    
    init(id: Int) {
        getMovieDetails(id: id)
    }

    func getMovieDetails(id: Int) {
        APIClient.getMovieDetail(id: id).subscribe(onNext: { [weak self] (details) in
            self?.movie.value = details
        }, onError: { [weak self] (error) in
            self?.error.value = error as NSError
        }).addDisposableTo(disposeBag)
    }
    
    func getMovieObservable() -> Observable<Movie?> {
        return self.movie.asObservable()
    }
    
}
