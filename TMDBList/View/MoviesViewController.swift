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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        
        tableView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            if let strongSelf = self {
                let id = strongSelf.viewModel.getMovieId(atIndex: indexPath)
                let title = strongSelf.viewModel.getMovieTitle(atIndex: indexPath)
                let viewController = MovieDetailViewController(id: id, title: title)
                strongSelf.navigationController?.pushViewController(viewController, animated: true)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.getErrorObservable().subscribe(onNext: { [weak self] (error) in
            guard let _ = error else { return }
            self?.showErrorAlert()
        }).addDisposableTo(disposeBag)
        
    }
    
}
