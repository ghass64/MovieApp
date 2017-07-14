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

class ResultTableViewController: UITableViewController {
    
    //Variables
    var ResultMovieArray : [MovieObj] = []
    var querySearch : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the query text to the title of controller
        self.title = querySearch
        
        //Configure the tableview
        ConfigureTableView()
        
        //call this method to query the text from the webservice
        QueryForMovie(text: querySearch)
        
        
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
        
        //add pull to refresh mechanism to the tableview
        addPullToRefresh()
        
        
    }
    
    private func addPullToRefresh() {
        //using UIRefreshControl to tableview and connect it with method to update
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:#selector(self.handleRefresh) , for: .valueChanged)
    }
    
    //method to call after pull to referesh to update the list
    func handleRefresh()
    {
        self.QueryForMovie(text: self.querySearch)
    }
    
    
    //Method to insert the query to suggestions or update it
    private func UpdateRecentSearchCache()
    {
        // get the cached array and insert new query
        var arr = CacheManager.getCachedList(type: .RecentSearch, count: -1) as! [String]
        arr.append(querySearch)
        
        //insert the query to cache and check if its success or not
        if CacheManager.cacheList(list: CacheManager.uniqueElementsFrom(array: arr), type: .RecentSearch)
        {
            print("Caching success")
        }
        else
        {
            print("Error: Cannot cache the file check the above error description")
        }
        
    }
    
    
    //Method to call the webservice and get the data from server by using Alamofire library
    private func QueryForMovie(text:String)
    {
        
        //show progress view
        ARSLineProgress.show()
        
        //use encodeUrl to add percent encoding for the text
        let APIURLString = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=" + text.encodeUrl()
        
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
                        var obj :MovieObj = MovieObj()
                        obj = obj.initMovieWith(dict: objDict)
                        self.ResultMovieArray.append(obj)
                    }
                    
                    //reload the table to show the data and end refereshing
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    
                    //add this query to cache file
                    self.UpdateRecentSearchCache()
                    
                }else
                {
                    //show alert and then go back if pressed ok
                    self.ShowAlertWith(message: "There is no result for this search", title: "info", withResponse: true)
                }
                
                //hide the progress view
                ARSLineProgress.hide()
                
                
            case .failure(let error):
                //at failure show a general error message alert
                print(error)
                ARSLineProgress.hide()
                self.tableView.refreshControl?.endRefreshing()
                
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
        //the height of the cell should be dynamic depends on the overview text in MovieObj
        return UITableViewAutomaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMovieCell", for: indexPath) as! ResultMovieCell
        
        // Configure the cell...
        let Obj : MovieObj = ResultMovieArray[indexPath.row]
        cell.SetMovieInCell(movie: Obj)
        
        return cell
    }
}
