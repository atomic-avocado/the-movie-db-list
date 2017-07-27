//
//  MoviesViewController.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import RxSwift

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MoviesViewModel()
    var disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl = {
        var control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.upcoming_title()
        configTableView()
        bind()
    }
    
    func refresh() {
        viewModel.requestUpcomingMovies()
    }
    
    func configTableView() {
        tableView.register(R.nib.movieTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.movieCell.identifier)
        tableView.backgroundColor = .grafity
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControl)
    }
    
    func bind() {
        viewModel.getMovies()
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.movieCell.identifier,
                                         cellType: MovieTableViewCell.self))
            { (row, element, cell) in
                cell.populate(with: element)
            }
            .addDisposableTo(disposeBag)
        
        viewModel.getEmptyStatus().subscribe(onNext: { [weak self] (isEmpty) in
            if isEmpty {
                let label = UILabel()
                label.textColor = .white
                label.textAlignment = .center
                label.text = R.string.localizable.empty_movies()
                self?.tableView.backgroundView = label
            } else {
                self?.tableView.backgroundView = nil
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.didFinishRefreshing().subscribe(onNext: { [weak self] (finished) in
            if finished {
                self?.refreshControl.endRefreshing()
            }
        }).addDisposableTo(disposeBag)
        
        tableView.rx.willDisplayCell.asObservable().subscribe(onNext: { [weak self] (cell: UITableViewCell, indexPath: IndexPath) in
            if indexPath.row == self?.viewModel.getInfiniteScrollTrigger() {
                self?.viewModel.getNextPage()
            }
        }).addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            print(indexPath.row)
        }).addDisposableTo(disposeBag)
        
        viewModel.getErrorObservable().subscribe(onNext: { [weak self] (error) in
            guard let _ = error else { return }
            self?.showErrorAlert()
        }).addDisposableTo(disposeBag)
        
    }
    
}
