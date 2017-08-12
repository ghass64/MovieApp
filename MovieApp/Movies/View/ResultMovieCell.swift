//
//  ResultMovieCell.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit
import SDWebImage

class ResultMovieCell: UITableViewCell {

    @IBOutlet var moviePosterImage: UIImageView!
    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var movieReleaseLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Helper Method
    func setMovieInCell(movie: MovieObj) {
        self.movieNameLabel?.text = movie.movieName
        self.movieReleaseLabel.text = movie.releaseDate
        self.movieOverviewLabel.text = movie.movieOverview
        self.moviePosterImage.sd_setImage(with: URL(string: movie.moviePoster), placeholderImage:
            UIImage(named:"General_placeHolder_img"))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
