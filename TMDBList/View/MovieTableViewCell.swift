//
//  MovieTableViewCell.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        ratingLabel.numberOfLines = 1
        ratingLabel.textColor = .white
        descriptionLabel.numberOfLines = 6
        descriptionLabel.textColor = .white
        posterImageView.contentMode = .scaleAspectFit
        backgroundColor = .grafity
        selectionStyle = .none
    }
    
    func populate(with movie: Movie) {
        posterImageView.kf.setImage(with: movie.getPosterURL(), placeholder: R.image.poster_placeholder())
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        if let average = movie.voteAverage {
            ratingLabel.text = "\(average)/10"
        } else {
            ratingLabel.text = "?/10"
        }
    }
    
}
