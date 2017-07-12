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

    //Properties
    
    //Variables
    var ResultMovieArray : [MovieObj] = []
    var querySearch : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        QueryForMovie(text: querySearch)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    func QueryForMovie(text:String)
    {
        
        ARSLineProgress.show()
        let APIURLString = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=" + text
        
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
                    //add this query to cache file
                    
                }else
                {
                    self.ShowAlertWith(message: "There is no result for this search", title: "info", withResponse: true)
                }
                ARSLineProgress.hide()
                
                
            case .failure(let error):
                print(error)
                ARSLineProgress.hide()
                
                var errorMessage = "General error message"
                
                if let data = response.data {
                    let responseJSON = JSON(data: data)
                    let message: String = responseJSON["message"].stringValue
                    if !message.isEmpty {
                        errorMessage = message
                    }
                }
                
                print(errorMessage) //Contains General error message or specific.
                self.ShowAlertWith(message: errorMessage, title: "Sorry",withResponse: false)
            }
        }
        
    }

    //alert method
    func ShowAlertWith(message: String , title:String ,withResponse:Bool) {
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMovieCell", for: indexPath) as! ResultMovieCell
        
        
        // Configure the cell...

        let Obj : MovieObj = ResultMovieArray[indexPath.row]
        cell.textLabel?.text = Obj.movieName
        
        return cell
    }


}
