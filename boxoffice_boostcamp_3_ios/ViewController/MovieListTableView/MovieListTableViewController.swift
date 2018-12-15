//
//  MovieListTableViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListTableViewController: MovieViewController, ImageAssetsNameProtocol {
    // MARK:- Outlet
    @IBOutlet weak var MovieListTableView: UITableView!
    
    // MARK:- Properties
    private let cellIdentifier = "MovieListTableViewCell"
    private let movieAPI = MovieAPI()
    private var movies = [MovieInfo]()
    private var thumbImages = [Int:UIImage?]()
    private var sortType = MovieAPI.sortType {
        didSet {
            switch sortType {
            case .reservation:
                navigationItem.title = "예매율순"
            case .curation:
                navigationItem.title = "큐레이션"
            case .date:
                navigationItem.title = "개봉일순"
            }
        }
    }
    
    // MARK:- Initialize
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTableView()
        sortType = MovieAPI.sortType
        fetchMovieList(sort: MovieAPI.sortType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if sortType != MovieAPI.sortType {
            fetchMovieList(sort: MovieAPI.sortType)
        } else {
            sortType = MovieAPI.sortType
        }
    }
    
    private func initializeTableView() {
        MovieListTableView.delegate = self
        MovieListTableView.dataSource = self
        MovieListTableView.refreshControl = refreshControl
    }
    
    // MARK:- Refresh Method
    @objc override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        
        fetchMovieList(sort: MovieAPI.sortType)
    }

    // MARK:- Fetch Movie List
    private func fetchMovieList(sort: SortType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        movieAPI.requestMovieList(sort: sort) { (movieList, error) in
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
    }
    
    // MARK:- Show Sort Action Sheet
    private func showSortAlertController() {
        let alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationAction = UIAlertAction(title: "예매율", style: .default) { _ in
            self.requestSortedMovieList(sort: .reservation)
        }
        let curationAction = UIAlertAction(title: "큐레이션", style: .default) { _ in
            self.requestSortedMovieList(sort: .curation)
        }
        let dateAction = UIAlertAction(title: "개봉일", style: .default) { _ in
            self.requestSortedMovieList(sort: .date)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reservationAction)
        alertController.addAction(curationAction)
        alertController.addAction(dateAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func requestSortedMovieList(sort: SortType) {
        if sort != sortType {
            fetchMovieList(sort: sort)
        }
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
            fatalError("Fail to Create MovieList TableView Cell")
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
