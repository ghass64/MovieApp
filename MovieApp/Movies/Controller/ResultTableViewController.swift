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
    fileprivate var resultMovieArray: [MovieObj] = []
    private var movie: MovieObj = MovieObj()
    var querySearch: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //add the query text to the title of controller
        self.title = querySearch

        //connect the delegate of movieobj to recieve messages from
        movie.delegate = self

        //Configure the tableview
        configureTableView()

        //call this method to query the text from the webservice
        queryForMovie(text: querySearch)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper methods
    private func configureTableView() {
        //set the height of the cell to be dynamic
        tableView.estimatedRowHeight = 158.0
        tableView.rowHeight = UITableViewAutomaticDimension

        //add pull to refresh mechanism to the tableview
        addPullToRefresh()

    }

    private func addPullToRefresh() {
        //using UIRefreshControl to tableview and connect it with method to update
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:#selector(self.handleRefresh), for: .valueChanged)
    }

    //method to call after pull to referesh to update the list
    func handleRefresh() {
        self.queryForMovie(text: self.querySearch)
    }

    //Method to insert the query to suggestions or update it
    fileprivate func updateRecentSearchCache() {
        // get the cached array and insert new query
        guard var arr = CacheManager.getCachedList(type: .recentSearch, count: -1) as? [String] else {
            return
        }
        arr.append(querySearch)

        //insert the query to cache and check if its success or not
        if CacheManager.cacheList(list: CacheManager.uniqueElementsFrom(array: arr), type: .recentSearch) {
            print("Caching success")
        } else {
            print("Error: Cannot cache the file check the above error description")
        }

    }

    //Method to call the webservice and get the data from server by using Alamofire library
    private func queryForMovie(text: String) {
        //show progress view
        ARSLineProgress.show()
        movie.searchForMovieOnline(query: text)
    }

    //alert method
    fileprivate func showAlertWith(message: String, title: String, withResponse: Bool) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (_: UIAlertAction) -> Void in
            if withResponse {
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
        return resultMovieArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //the height of the cell should be dynamic depends on the overview text in MovieObj
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "ResultMovieCell", for: indexPath) as? ResultMovieCell else {
            return ResultMovieCell()
        }
        // Configure the cell...
        let Obj: MovieObj = resultMovieArray[indexPath.row]
        cell.setMovieInCell(movie: Obj)
        return cell
    }
}

extension ResultTableViewController:MovieDataDelegate {
    func queryDidSuccess(_ searchResultArr: [MovieObj], _ error: String) {

        self.resultMovieArray = searchResultArr

        //reload the table to show the data and end refereshing
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()

        //add this query to cache file
        self.updateRecentSearchCache()

        //hide the progress view
        ARSLineProgress.hide()
    }
    func queryDidFailed(_ searchResultArr: [MovieObj], _ error: String) {
        //show alert and then go back if pressed ok
        self.showAlertWith(message: error, title: "info", withResponse: true)

        //hide the progress view
        ARSLineProgress.hide()

    }
}
