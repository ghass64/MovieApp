//
//  MovieObj.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieObj: NSObject,NSCoding{
    
    var moviePoster : String
    var movieName : String
    var releaseDate : String
    var movieOverview : String
    
    override init() {
        self.moviePoster = ""
        self.movieName = ""
        self.releaseDate = ""
        self.movieOverview = ""
    }
    
    func initMovieWith(dict:JSON) -> MovieObj {
        let Obj : MovieObj = MovieObj()
        if dict["poster_path"].string != nil {
            let posterPath = dict["poster_path"].string!
            Obj.moviePoster = String(format:"http://image.tmdb.org/t/p/w185%@",posterPath)
        }
        
        Obj.movieName = dict["title"].string!
        Obj.releaseDate = dict["release_date"].string!
        Obj.movieOverview = dict["overview"].string!
        
        return Obj
    }
    
    // MARK: - NSCoding
    
    internal required init?(coder aDecoder: NSCoder) {
        self.moviePoster = aDecoder.decodeObject(forKey: "moviePoster") as! String
        self.movieName = aDecoder.decodeObject(forKey: "movieName") as! String
        self.releaseDate = aDecoder.decodeObject(forKey: "releaseDate") as! String
        self.movieOverview = aDecoder.decodeObject(forKey: "movieOverview") as! String
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.moviePoster, forKey: "moviePoster")
        encoder.encode(self.movieName, forKey: "movieName")
        encoder.encode(self.releaseDate, forKey: "releaseDate")
        encoder.encode(self.movieOverview, forKey: "movieOverview")
        
        
    }
    
}
