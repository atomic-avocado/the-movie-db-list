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
    
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 36, height: 20))
//    var searchBar = UISearchBar()
    
    var timer: Timer? = nil
    var viewModel = MoviesViewModel()
    var disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl = {
        var control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    var tapGesture: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLayout()
        configTableView()
        bind()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        dismissKeyboard()
//    }
//    
    override var prefersStatusBarHidden: Bool {
        return false
        
    }
    
    func applyLayout() {
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = leftNavBarButton
        view.backgroundColor = .grafity
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    func hideKeyboardWhenTappedAround() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture?.cancelsTouchesInView = true
        guard let tap = tapGesture else { return }
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
        guard let tap = tapGesture else { return }
        view.removeGestureRecognizer(tap)
    }
    
    func refresh() {
        viewModel.requestUpcomingMovies()
    }
    
    func searchMovies(timer: Timer) {
        viewModel.searchMovies()
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
        
        
        viewModel.getErrorObservable().subscribe(onNext: { [weak self] (error) in
            guard let _ = error else { return }
            self?.showErrorAlert()
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
        
        searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] (_) in
            self?.hideKeyboardWhenTappedAround()
        }).addDisposableTo(disposeBag)
        
        searchBar.rx.text.asObservable().skip(1).subscribe(onNext: { [weak self] (text) in
            guard let strongSelf = self, let name = text else { return }
            strongSelf.timer?.invalidate()
            strongSelf.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: strongSelf,
                selector: #selector(strongSelf.searchMovies),
                userInfo: ["text": name],
                repeats: false)
        }).addDisposableTo(disposeBag)
        
        searchBar.rx.text.asObservable().bind(to: viewModel.searchString).addDisposableTo(disposeBag)
    }
    
}

