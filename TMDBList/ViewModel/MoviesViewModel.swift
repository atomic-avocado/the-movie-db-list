//
//  MoviesViewModel.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import RxSwift

class MoviesViewModel {
    
    var disposeBag = DisposeBag()
    let error = Variable<NSError?>(nil)
    let finishedRefreshing = BehaviorSubject(value: false)
    
    private var currentPage = 1
    private var totalPages = 1
    private var totalMovies = 0
    let movies = Variable<[Movie]>([])
    
    init() {
        requestUpcomingMovies()
    }
    
    func requestUpcomingMovies() {
        APIClient.getUpcoming().subscribe(onNext: { [weak self] (result) in
            if let movies = result.results {
                self?.movies.value = movies
            }
            if let current = result.page { self?.currentPage = current }
            if let pages = result.totalPages { self?.totalPages = pages }
            if let total = result.totalResults { self?.totalMovies = total }
        }, onError: { [weak self] (error) in
            self?.error.value = error as NSError
        }, onCompleted: { [weak self] (_) in
            self?.finishedRefreshing.onNext(true)
        }).addDisposableTo(disposeBag)
    }
    
    func getNextPage() {
        if currentPage < totalPages {
            APIClient.getUpcoming(page: currentPage + 1).subscribe(onNext: { [weak self] (result) in
                if let movies = result.results { self?.movies.value.append(contentsOf: movies) }
                if let current = result.page { self?.currentPage = current }
            }, onError: { [weak self] (error) in
                self?.error.value = error as NSError
            }).addDisposableTo(disposeBag)
        }
    }
    
    func getInfiniteScrollTrigger() -> Int {
        if movies.value.count > 6 {
            return movies.value.count - 5
        } else {
            return movies.value.count
        }
    }
    
    func getMovies() -> Observable<[Movie]>  {
        return self.movies.asObservable()
    }
    
    func didFinishRefreshing() -> Observable<Bool> {
        return self.finishedRefreshing.asObservable()
    }
    
    func getErrorObservable() -> Observable<NSError?> {
        return self.error.asObservable()
    }
    
    func getEmptyStatus() -> Observable<Bool> {
        return self.movies.asObservable().map({ (movies) -> Bool in
            return movies.isEmpty
        })
    }
    
}
