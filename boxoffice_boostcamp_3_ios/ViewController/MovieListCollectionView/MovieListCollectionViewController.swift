//
//  MovieListCollectionViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: MovieViewController, Fetchable {
    // MARK:- Outlet
    @IBOutlet weak var MovieListCollectionView: UICollectionView!
    
    // MARK:- Properties
    private let cellIdentifier = "MovieListCollectionViewCell"
    //private let movieAPI = MovieAPI()
    private var movies = [MovieInfo]()
    private var thumbImages = [Int:UIImage?]()
    // MARK:- Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeColletionView()
        fetchMovieList(sort: sortType)
    }
    
    private func initializeColletionView() {
        MovieListCollectionView.delegate = self
        MovieListCollectionView.dataSource = self
        MovieListCollectionView.collectionViewLayout = collectionViewLayout()
        MovieListCollectionView.refreshControl = refreshControl
    }
    
    // MARK:- CollectionView Layout 
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        let cellWitdh: CGFloat = (UIScreen.main.bounds.width / 2.0) - 20
        let cellHeight: CGFloat = cellWitdh * (141/99) + 97.5
        flowLayout.itemSize = CGSize(width: cellWitdh, height: cellHeight)
        
        return flowLayout
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
                self.MovieListCollectionView.reloadData()
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
                    let index = IndexPath(item: i, section: 0)
                    self.MovieListCollectionView.reloadItems(at: [index])
                    
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let VC = segue.destination as? MovieDetailViewController,
            let cell = sender as? MovieListCollectionViewCell,
            let index = MovieListCollectionView?.indexPath(for: cell)
            else {
                print("Fail To Prepare for CollectionView Segue")
                return
        }
        
        VC.movieId = movies[index.item].id
    }
}

// MARK:- CollectionView DataSource
extension MovieListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
            fatalError("Fail to Create MovieList CollectionView Cell")
        }
        
        cell.movieInfo = movies[indexPath.item]
        if let image = thumbImages[indexPath.item] {
            cell.thumbImageView.image = image
        }
        
        return cell
    }
}

// MARK:- CollectionView Delegate
extension MovieListCollectionViewController: UICollectionViewDelegate {
}
