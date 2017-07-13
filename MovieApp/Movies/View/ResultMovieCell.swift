//
//  ResultMovieCell.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit

class ResultMovieCell: UITableViewCell {

    @IBOutlet var moviePosterImage: UIImageView!
    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var movieReleaseLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
