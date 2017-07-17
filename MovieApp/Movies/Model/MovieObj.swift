//
//  MovieObj.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol MovieDataDelegate: class {
    func queryDidSuccess(_ searchResultArr:[MovieObj],_ error:String)
    func queryDidFailed(_ searchResultArr:[MovieObj],_ error:String)
}

class MovieObj: NSObject,NSCoding{
    
    var moviePoster : String
    var movieName : String
    var releaseDate : String
    var movieOverview : String
    
    weak var delegate : MovieDataDelegate?
    
    override init() {
        self.moviePoster = ""
        self.movieName = ""
        self.releaseDate = ""
        self.movieOverview = ""
    }
    
    
    //parse data from JSON into MovieObj
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
    
    
    func SearchForMovieOnline(query:String) {
        var ResultMovieArray : [MovieObj] = []
        var errorMessage : String = ""
        
        //use encodeUrl to add percent encoding for the text
        let APIURLString = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=" + query.encodeUrl()
        
        Alamofire.request(APIURLString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value) //convert the data recieved into JSON
                
                let resultsJsonArr = json["results"].array!  //get the data needed as array from 'results'
                
                //check if the data returning results or not
                if resultsJsonArr.count > 0
                {
                    //convert the JSON data into 'MovieObj' objects and append them to array
                    for objDict in resultsJsonArr
                    {
                        var obj : MovieObj = MovieObj()
                        obj = self.initMovieWith(dict: objDict)
                        ResultMovieArray.append(obj)
                    }
                    
                    //completion(ResultMovieArray,true,errorMessage)
                    self.delegate?.queryDidSuccess(ResultMovieArray, errorMessage)
                }else
                {
                    errorMessage = "There is no result for this search"
                    //completion(ResultMovieArray,false,errorMessage)
                    self.delegate?.queryDidFailed(ResultMovieArray, errorMessage)
                }
                
                
            case .failure(let error):
                //at failure show a general error message alert
                print(error)
                errorMessage = "General error message"
                
                if let data = response.data {
                    let responseJSON = JSON(data: data)
                    let message: String = responseJSON["message"].stringValue
                    if !message.isEmpty {
                        errorMessage = message
                    }
                }
                
                print(errorMessage) //Contains General error message or specific.
                //completion(ResultMovieArray,false,errorMessage)
                self.delegate?.queryDidFailed(ResultMovieArray, errorMessage)

            }
        }
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
