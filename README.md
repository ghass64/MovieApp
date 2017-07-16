# MovieApp
This app is written in swift 3.1 allows users to query movies by name fetching from the webservice http://api.themoviedb.org
it uses these libraries :
1.Alamorfire
2.SwiftyJSON
3.SDWebImage
4.ARSLineProgress


It contains a : 
1. SearchTableViewController which has the search bar and a table to show the last 10 positive search terms showing on focus into search bar
2. ResultTableViewController which has the result table that shows the result that came from the webservice response and contains the MovieCell
3. MovieObj object which is the model that contains the movie data and the method to query the data from the webservice
4. MovieCell a view that shows the poster image , movie name , release data , overview
5. CacheManager a class that used to insert and update and clear the cache it uses NSKeyedArchiver to archive the data
6. Storyboards used here as Interface Builder and autolayout are used to create the UI.
7.MovieAppUITest : it uses ui test to test the search and the pick from the suggestions in the table

Methods:
1.configureSearchBarController() : initialize and configure searchbar controller
2.QueryForMovie(text:String) : method to save the query and go to result page and to query the text from the webservice
3.ConfigureTableView() : Configure the tableview so the cells will be dynamic in height
4.addPullToRefresh() : add pull to refresh mechanism to the tableview
5.handleRefresh() : method to call after pull to referesh to update the list
6.UpdateRecentSearchCache() : Method to insert the query to suggestions or update it through the CacheManager
