//
//  MovieInformationViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, ImageAssetsNameProtocol {
    // MARK:- Outlet
    @IBOutlet weak var MovieDetailTableView: UITableView!
    
    // MARK:- Properties
    private let cellIdentifier = ["OverviewCell", "SynopsisCell", "StaffCell", "CommentCell"]
    private let movieAPI = MovieAPI()
    private var refreshControl = UIRefreshControl()
    private var movieDetail: MovieDetail?
    private var comments = [Comment]()
    public var movieId = ""
    
    // MARK:- Initialize
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTableView()
        fetchMovieDetail()
        fetchMovieCommentList()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.topItem?.title = "영화목록"
    }
    
    private func initializeTableView() {
        MovieDetailTableView.delegate = self
        MovieDetailTableView.dataSource = self
        MovieDetailTableView.allowsSelection = false
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        MovieDetailTableView.refreshControl = refreshControl
        MovieDetailTableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK:- Refresh Method
    @objc private func refresh(_ sender: UIRefreshControl) {
        fetchMovieDetail()
        fetchMovieCommentList()
    }
    
    // MARK:- Fetch Movie Detail Information
    private func fetchMovieDetail() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        movieAPI.requestMovieDetail(movieId: movieId) { (movieDetail, error) in
            guard let movieDetail = movieDetail else {
                self.showFailToNetworkingAlertController(error: error)
                return
            }
            self.movieDetail = movieDetail
            DispatchQueue.main.async {
                self.MovieDetailTableView.reloadData()
                self.endNetworking()
            }
        }
    }
    
    // MARK:- Fetdch Movie Comment List
    private func fetchMovieCommentList() {
        movieAPI.requestMovieComments(movieId: movieId) { (comments, error) in
            guard let comments = comments else {
                self.showFailToNetworkingAlertController(error: error)
                return
            }
            self.comments = comments.comments
            DispatchQueue.main.async {
                self.MovieDetailTableView.reloadData()
                self.endNetworking()
            }
        }
    }
    
    private func endNetworking() {
        guard movieDetail != nil, !comments.isEmpty else { return }
        self.refreshControl.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            self.refreshControl.endRefreshing()
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK:- TableView DataSource
extension MovieDetailViewController: UITableViewDataSource {
    // MARK:- TableView Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK:- TableView Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0..<3:
            return 1
        case 3:
            return comments.count
        default:
            return 0
        }
    }
    
    // MARK:- TableView Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return movieOverviewTableViewCell(tableView: tableView, indexPath: indexPath)
        case 1:
            return movieSynopsisTableViewCell(tableView: tableView, indexPath: indexPath)
        case 2:
            return movieStaffTableViewCell(tableView: tableView, indexPath: indexPath)
        case 3:
            return movieCommentTableViewCell(tableView: tableView, indexPath: indexPath)
        default:
            fatalError("Request Wrong Section Cell")
        }
    }
    
    private func movieOverviewTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[0], for: indexPath) as? MovieOverviewTableViewCell else {
            fatalError("Fail to Create Movie Overview Cell")
        }
        cell.movieInfo = movieDetail
        cell.delegate = self
        
        return cell
    }
    
    private func movieSynopsisTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[1], for: indexPath) as? MovieSynopsisTableViewCell else {
            fatalError("Fail to Create Movie Synopsis Cell")
        }
        cell.movieInfo = movieDetail

        return cell
    }
    
    private func movieStaffTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[2], for: indexPath) as? MovieStaffTableViewCell else {
            fatalError("Fail to Create Movie Staff Cell")
        }
        cell.movieInfo = movieDetail
        
        return cell
    }
    
    private func movieCommentTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[3], for: indexPath) as? MovieCommentTableViewCell else {
            fatalError("Fail to Create Movie Comment Cell")
        }
        cell.comment = comments[indexPath.row]
        
        return cell
    }
}

// MARK:- TableView Delegate
extension MovieDetailViewController: UITableViewDelegate {
    // MARK:- TableView Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsHeaderCell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 50.0
        default:
            return 0.0
        }
    }
    
    // MARK:- TableView Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0..<3:
            return 10.0
        default:
            return 0.0
        }
    }
}

// MARK:- Show Large Thumb Image
extension MovieDetailViewController: HandleShowLargeThumbImageProtocol {
    func showLargeThumbImage(_ image: UIImage) {
        guard let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoviePosterViewController") as? MovieThumbImageViewController else {
            print("Fail to Create Movie Thumb ViewController")
            return
        }
        VC.thumbImage = image
        present(VC, animated: true, completion: nil)
    }
}
