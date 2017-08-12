//
//  SearchTableViewController.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    //Properties
    private var recentSearchController: UISearchController!
    //Variables
    private var recentSearchArray: [String] = []
    private var querySearch: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure searchbar controller
        configureSearchBarController()
        //configure tableview to remove all empty cells
        tableView.tableFooterView =  UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // read the last 10 positive search queries from the cache
        guard let recentArray = CacheManager.getCachedList(type: .recentSearch, count: 10) as? [String] else {
            return
        }
        //reverse to show the latest data in the begining
        recentSearchArray = recentArray.reversed()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - helper methods
    private func configureSearchBarController() {
        // In closure of result search controller create instance of search controller
        recentSearchController = UISearchController(searchResultsController: nil)
        // The search result will be shows on same table view controller.
        recentSearchController.searchResultsUpdater = self
        // The searchbar will connect delegate to resultTableViewController
        recentSearchController.searchBar.delegate = self
        // Search controller will not replace navigation bar when searching
        recentSearchController.hidesNavigationBarDuringPresentation = false
        // Background will not become dark when searching
        recentSearchController.dimsBackgroundDuringPresentation = false
        // Search bar style is set to Prominent
        recentSearchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        // Search bar will fit in size available.
        recentSearchController.searchBar.sizeToFit()
        recentSearchController.searchBar.placeholder = "Search for movie"
        // Search bar is placed in title of Navigation controller.
        self.navigationItem.titleView = recentSearchController.searchBar
    }
    //method to save the query and go to result page
    func queryForMovie(text: String) {
        querySearch = text
        performSegue(withIdentifier: "ShowResultPage", sender: self)  // call the sague 'ShowResultPage'
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //chech if the search box is focused
        if recentSearchController.isActive {
            return recentSearchArray.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearchCell", for: indexPath)
        // Configure the cell...
        if recentSearchController.isActive {
            cell.textLabel?.text = recentSearchArray[indexPath.row]
        } else {
            cell.textLabel?.text = ""
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //query from the choosed in recent list and go to result page

        recentSearchController.searchBar.resignFirstResponder() // hide the keyboard before call the method
        queryForMovie(text:recentSearchArray[indexPath.row])
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowResultPage" {
            guard let dest = segue.destination as? ResultTableViewController else {
                return
            }
            dest.querySearch = querySearch

        }
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //update the table to show the recent searchs & in case we want to filter it will be from here
        tableView.reloadData()
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        queryForMovie(text: searchBar.text!)
    }
}
