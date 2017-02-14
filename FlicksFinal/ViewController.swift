//
//  ViewController.swift
//  FlicksFinal
//
//  Created by Youssef Elabd on 2/6/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import SwiftyJSON
import Alamofire

class ViewController: UIViewController,UICollectionViewDataSource,UISearchBarDelegate  {
    
    var movies : [Movie] = []
    var filteredMovies : [Movie] = []
    var endpoint : String = "now_playing"

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        //        UIApplication.shared.statusBarStyle = .lightContent
        movieCollectionView.dataSource = self
//        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieCollectionView.insertSubview(refreshControl, at: 0)
        
        getData()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getData(){
        
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        
        let baseURL = "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        Alamofire.request(baseURL,method: .get,encoding: URLEncoding.default).validate().responseJSON{response in
            if response.result.isSuccess{
                guard let info = response.result.value else {
                    print("Error")
                    return
                }
                
                let json = JSON(info)
                
                let loadedMovies = json["results"].arrayValue
                
                for result in loadedMovies{
                    let indvMovie = Movie(json : result)
                    self.movies.append(indvMovie)
                    self.filteredMovies = self.movies
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movieCollectionView.reloadData()
                    
                    
                }
                
            }
        }
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
        
    }
    

    func collectionView(_ movieCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredMovies.count
    }

    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
//        
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let baseURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        Alamofire.request(baseURL,method: .get,encoding: URLEncoding.default).validate().responseJSON{response in
            if response.result.isSuccess{
                guard let info = response.result.value else {
                    print("Error")
                    return
                }
                
                let json = JSON(info)
                
                let loadedMovies = json["results"].arrayValue
                self.movies.removeAll()
                
                for result in loadedMovies{
                    let indvMovie = Movie(json : result)
                    self.movies.append(indvMovie)
                    self.filteredMovies = self.movies
                    self.movieCollectionView.reloadData()
                    refreshControl.endRefreshing()
                    
                }
                
            }
        }
        
    }

    func collectionView(_ movieCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieCell
        
        let movie = self.filteredMovies[indexPath.row]
        //        let title = movie["title"] as! String
        //        let overview = movie["overview"] as! String
        let posterPath = movie.posterPath
        let baseURL = "https://image.tmdb.org/t/p/w342"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        cell.posterView.setImageWith(imageURL as! URL)
        
        cell.posterView.layer.cornerRadius = 25.0
        
        cell.posterView.clipsToBounds = true
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        
        let destination = segue.destination as! MovieViewController
        
        let row = self.movieCollectionView.indexPath(for: cell)?.row
        
        let movie = self.filteredMovies[row!]
        
//        let title = movie?["title"] as! String
//        let overview = movie?["overview"] as! String
//        let posterPath = movie?["poster_path"] as! String
//        let rating = movie?["vote_average"] as! Double
        
//        let movieInfoArray = [title,overview,posterPath,rating] as [Any]
        destination.movieInfo = movie
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.filteredMovies = searchText.isEmpty ? self.movies : movies.filter({(dataString: Movie) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let movieTitle = dataString.title
            return movieTitle.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        self.movieCollectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
