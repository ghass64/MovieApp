//
//  ResultTableViewController.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ARSLineProgress
import SDWebImage

class ResultTableViewController: UITableViewController {

    //Properties
    
    //Variables
    var ResultMovieArray : [MovieObj] = []
    var querySearch : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = querySearch
        ConfigureTableView()
        QueryForMovie(text: querySearch)
        addPullToRefresh()
    }
    
    //update the layout of the tableview to show under the navigation bar
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rect = self.navigationController?.navigationBar.frame
        let y = -1 * (rect?.origin.y)!
        tableView.contentInset = UIEdgeInsetsMake(y+85.0, 0, 0, 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // MARK: - Helper methods
    
    private func ConfigureTableView()
    {
        //set the height of the cell to be dynamic
        tableView.estimatedRowHeight = 158.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    private func addPullToRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        addPullToRefreshWithAnimator(animator: animator)
    }
    
    
    private func addPullToRefreshWithAnimator(animator: CustomPullToRefreshAnimator) {
        tableView.fty.pullToRefresh.add(animator: animator) {
            self.QueryForMovie(text: self.querySearch)
        }
    }
    
    private func UpdateRecentSearchCache()
    {
        // get the cached array and insert new query
        var arr = CacheManager.getCachedList(type: .RecentSearch, count: -1) as! [String]
        arr.append(querySearch)
        
        if CacheManager.cacheList(list: CacheManager.uniqueElementsFrom(array: arr), type: .RecentSearch)
        {
            print("Caching success")
        }
        else
        {
            print("Error: Cannot cache the file")
        }
        
    }
    
    private func QueryForMovie(text:String)
    {
        
        ARSLineProgress.show()
        let APIURLString = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=" + text.encodeUrl()
        
        Alamofire.request(APIURLString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                print("Validation Successful : \(json)")
                let resultsJsonArr = json["results"].array
                
                if (resultsJsonArr?.count)! > 0
                {
                    for objDict in resultsJsonArr!
                    {
                        var obj :MovieObj = MovieObj()
                        obj = obj.initMovieWith(dict: objDict)
                        self.ResultMovieArray.append(obj)
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.fty.pullToRefresh.end()
                    
                    //add this query to cache file
                    self.UpdateRecentSearchCache()
                    
                }else
                {
                    self.ShowAlertWith(message: "There is no result for this search", title: "info", withResponse: true)
                }
                ARSLineProgress.hide()
                
                
            case .failure(let error):
                print(error)
                ARSLineProgress.hide()
                self.tableView.fty.pullToRefresh.end()

                var errorMessage = "General error message"
                
                if let data = response.data {
                    let responseJSON = JSON(data: data)
                    let message: String = responseJSON["message"].stringValue
                    if !message.isEmpty {
                        errorMessage = message
                    }
                }
                
                print(errorMessage) //Contains General error message or specific.
                self.ShowAlertWith(message: errorMessage, title: "Sorry",withResponse: true)
            }
        }
        
    }

    //alert method
    private func ShowAlertWith(message: String , title:String ,withResponse:Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if withResponse{
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(okAction)
        self.navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }

    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultMovieArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMovieCell", for: indexPath) as! ResultMovieCell
        
        
        // Configure the cell...

        let Obj : MovieObj = ResultMovieArray[indexPath.row]
        cell.movieNameLabel?.text = Obj.movieName
        cell.movieReleaseLabel.text = Obj.releaseDate
        cell.movieOverviewLabel.text = Obj.movieOverview
        cell.moviePosterImage.sd_setImage(with: URL(string: Obj.moviePoster))
        
        return cell
    }


}
