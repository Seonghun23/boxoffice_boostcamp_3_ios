//
//  MovieListTableViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListTableViewController: MovieViewController, Fetchable {
   
    
    // MARK:- Outlet
    @IBOutlet weak var MovieListTableView: UITableView!
    
    // MARK:- Properties
    private let cellIdentifier = "MovieListTableViewCell"
    //private let movieAPI = MovieAPI()
    private var movies = [MovieInfo]()
    private var thumbImages = [Int: UIImage?]()
   // weak var alertViewDelegate: AlertViewDelegate?
    /*
     private var thumbImages = [Int:UIImage?]() -> 성훈님 코드
     
     가이드 문서에 보면 (raywenderlich) 아래와 같은 방식을 추천하고 있습니다. [someType: someType]과 같은 컨벤션을 지키는것이 필요하다고 생각합니다.
     Preferred:
 
 class TestDatabase: Database {
 var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
 }*/
   
    
    // MARK:- Initialize
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTableView()
        //sortType = MovieAPI.shared.sortType
        fetchMovieList(sort: sortType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       /*
        if sortType != MovieAPI.shared.sortType {
            fetchMovieList(sort: MovieAPI.shared.sortType)
        } else {
            sortType = MovieAPI.shared.sortType
        }
 */
 }
    
    private func initializeTableView() {
        MovieListTableView.delegate = self
        MovieListTableView.dataSource = self
        MovieListTableView.refreshControl = refreshControl
    }
    
    // MARK:- Refresh Method
    @objc override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        
        fetchMovieList(sort: MovieAPI.shared.sortType)
    }

    // MARK:- Fetch Movie List
    func fetchMovieList(sort: SortType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let request = MovieAPI.shared.makeRequest(url: .list, param: .orderType, "", .reservation) else {
            return
        }
        // request.httpMethod = "GET" // URLRequest는 default로 get method를 사용하는 것으로 알고있습니다.
        MovieAPI.shared.requestMovieData(request: request, with: MovieList.self) { (movieList, error) in
            guard let movieList = movieList else {
                self.showFailToNetworkingAlertController(error: error)
                return
            }
            self.movies = movieList.movies
            DispatchQueue.global().async {
                self.fetchMovieListThumbImage(movies: movieList.movies)
            }
            DispatchQueue.main.async {
                self.sortType = movieList.sortType
                self.MovieListTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK:- Fetch Movie List Thumb Image
    private func fetchMovieListThumbImage(movies: [MovieInfo]) {
        for i in movies.indices {
            fetchThumbImage(url: movies[i].thumb) { (thumb) in
                if thumb == nil { print("Fail to fetch \(i) Index Thumb Image") }
                
                DispatchQueue.main.async {
                    self.thumbImages[i] = thumb
                    let index = IndexPath(row: i, section: 0)
                    self.MovieListTableView.reloadRows(at: [index], with: .automatic)
                    
                    if movies.count == self.thumbImages.count {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    
    // MARK:- Touch Up Sort Button
    @IBAction func touchUpSortButton(_ sender: UIBarButtonItem) {
        showSortAlertController()
        //alertViewDelegate?.shouldUpdateList(with: sortType)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let VC = segue.destination as? MovieDetailViewController,
            let cell = sender as? MovieListTableViewCell,
            let index = MovieListTableView?.indexPath(for: cell)
            else {
                print("Fail To Prepare for TableView Segue")
                return
        }
        VC.movieId = movies[index.row].id
    }
}

// MARK:- TableView DataSource
extension MovieListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieListTableViewCell else {
            return .init()
            //fatalError("Fail to Create MovieList TableView Cell")
            //성향에 따라 다르겠으나 fatalError는 앱이 종료되게 하므로 최대한 그런 상황이 생기지 않게 return .init() 과 같은 방식으로 구성하면 안전하다고 리뷰어님들께 배운 기억이 있습니다.
        }
        cell.movieInfo = movies[indexPath.row]
        if let image = thumbImages[indexPath.row] {
            cell.thumbImageView.image = image
        }
        return cell
    }
}

// MARK:- TableView Delegate
extension MovieListTableViewController: UITableViewDelegate {
}
