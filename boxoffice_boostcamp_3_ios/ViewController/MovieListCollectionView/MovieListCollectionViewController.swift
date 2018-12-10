//
//  MovieListCollectionViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UIViewController, ImageUtilityProtocol {
    // MARK:- Outlet
    @IBOutlet weak var MovieListCollectionView: UICollectionView!
    
    // MARK:- Properties
    private let cellIdentifier = "MovieListCollectionViewCell"
    private let movieAPI = MovieAPI()
    private var refreshControl = UIRefreshControl()
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

        initializeColletionView()
        sortType = MovieAPI.sortType
        fetchMovieList(sort: MovieAPI.sortType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if sortType != MovieAPI.sortType {
            fetchMovieList(sort: MovieAPI.sortType)
        }
    }
    
    private func initializeColletionView() {
        MovieListCollectionView.delegate = self
        MovieListCollectionView.dataSource = self
        MovieListCollectionView.collectionViewLayout = collectionViewLayout()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
    @objc private func refresh(_ sender: UIRefreshControl) {
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
                self.sortType = SortType.init(rawValue: movieList.orderType) ?? .reservation
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
    
    // MARK:- Alert Fail to Networking
    private func showFailToNetworkingAlertController(error: Error?) {
        guard let error = error else {
            print("Fail To Networing with No Error Message")
            return
        }
        print(error.localizedDescription)
        
        let alertController = UIAlertController(title: nil, message: "영화목록을 가져오는데 실패했습니다.\n인터넷 연결을 확인해 주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.present(alertController, animated: true, completion: nil)
        }
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
