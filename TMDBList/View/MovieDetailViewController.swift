//
//  MovieDetailViewController.swift
//  TMDBList
//
//  Created by Victor Robertson on 27/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import RxSwift
import UIImageColors

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModel
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    
    init(id: Int, title: String? = "") {
        viewModel = MovieDetailViewModel(id: id)
        super.init(nibName: R.nib.movieDetailViewController.name, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.cyan
        contentStackView.spacing = 16.0
        bind()
    }
    
    func populate(with movie: Movie) {
        backdropImageView.kf.setImage(with: movie.getBackdropURL(with: .width342),
                                      placeholder: R.image.backdrop())
        { [weak self] (image, _, _, _) in
            guard let img = image else { return }
            img.getColors() { colors in
                self?.view.backgroundColor = colors.background
                self?.addLabels(with: colors, movie: movie)
            }
        }
    }
    
    func addLabels(with colors: UIImageColors, movie: Movie) {
        if let title = movie.title {
            addAttributeLabel(description: title, colors: colors)
        }
        if let description = movie.overview {
            addAttributeLabel(description: description, colors: colors)
        }
    }
    
    
    func addAttributeLabel(_ title: String = "", description: String, colors: UIImageColors) {
        let label = UILabel()
        label.numberOfLines = 0
        let text = "\(title) \(description)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSForegroundColorAttributeName,
                                      value: colors.secondary,
                                      range: (text as NSString).range(of: title))
        attributedString.addAttribute(NSForegroundColorAttributeName,
                                      value: colors.primary,
                                      range: (text as NSString).range(of: description))
        
        label.attributedText = attributedString
        label.font = UIFont.boldSystemFont(ofSize: 16)
        contentStackView.addArrangedSubview(label)
    }
    
    func bind() {
        viewModel.getMovieObservable().subscribe(onNext: { [weak self] (movie) in
            guard let movie = movie else { return }
            self?.populate(with: movie)
        }).addDisposableTo(disposeBag)
    }

}
