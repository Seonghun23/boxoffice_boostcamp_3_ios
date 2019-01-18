//
//  MovieAPI.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

class MovieAPI: NetworkingErrorProtocol {
    // MARK:- URL List
    private let baseURL = "http://connect-boxoffice.run.goorm.io"
    private let url = (list:"/movies",
                       detail:"/movie",
                       comments:"/comments"
                       )
    private let parameters = (orderType: "?order_type=",
                              movieId: "?id=",
                              commentsMovieId:"?movie_id="
                              )
    
    // MARK:- Sort Type
    /**
     Static Movie List Sort Type Property.
     */
    static var sortType: SortType = .reservation
    
    // MARK:- Request Movie List
    /**
     Request Movie List from goorm server.
     
     This Method request Movie List with Asynchronous. After finish Networking, call Completion. If fail to Networking, you can check Error. When Networking is Success, Error is nil.
     
     ```
     let sort: SortType = .reservation
     
     requestMovieList(sort: sort, completion: { (movieList: MovieList?, error: Error?) in
        if let movieList = movieList {
            // Success fetch Movie List
        } else {
            // Fail fetch Movie List
        }
     })
     ```
     
     - parameters:
        - sort: Sort Type for Movie List.
        - completion: It's going to work after finish Networking. If fail to Networking, MovieList is nil.
     */
    
    
    
    /*
     requestMovieList 와 requestMovieDetail 는 사실상 같은 일을하는 메서드로
     MovieList 나 MovieDetail 둘중하나를 fetching하는 일을 나누신 것으로 보여집니다. 제너릭 기능을 사용하여 하나로 합쳐볼 수 있을 것 같습니다.
     */
    
    
    final func requestMovieList(sort: SortType, completion: @escaping (MovieList?, Error?)-> Void) {
        let urlString = baseURL + url.list + parameters.orderType + String(sort.rawValue)
        guard let url = URL(string: urlString) else {
            print("Movie List URL is Wrong.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // URLRequest는 default로 get method를 사용하는 것으로 알고있습니다.
        
        let sesstion = URLSession(configuration: .default) //오타가 있습니다 <session>
        let dataTask = sesstion.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, self.responseError(domain: urlString, code: response.statusCode))
                return
            }
            guard let data = data else {
                completion(nil, self.responseError(domain: urlString, code: 204))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MovieList.self, from: data)
                MovieAPI.sortType = result.sortType
                completion(result, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    // MARK:- Request Movie Detail Information
    /**
     Request Movie Detail Information from goorm server.
     
     This Method request Movie Detail Information with Asynchronous. After finish Networking, call Completion. If fail to Networking, you can check Error. When Networking is Success, Error is nil.
     
     ```
     let movieId: String = "Movie Id"
     
     requestMovieDetail(movieId: movieId, completion: { (movieDetail: MovieDetail?, error: Error?) in
        if let movieDetail = movieDetail {
            // Success fetch Movie Detail Information
        } else {
            // Fail fetch Movie Detail Information
        }
     })
     ```
     
     - parameters:
        - movieId: Movie Id for fetch Detail Information.
        - completion: It's going to work after finish Networking. If fail to Networking, MovieDetail is nil.
     */
    final func requestMovieDetail(movieId: String, completion: @escaping(MovieDetail?, Error?) -> Void) {
        let urlString = baseURL + url.detail + parameters.movieId + movieId
        guard let url = URL(string: urlString) else {
            print("Movie Detail URL is Wrong")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let sesstion = URLSession(configuration: .default)
        let dataTask = sesstion.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, self.responseError(domain: urlString, code: response.statusCode))
                return
            }
            guard let data = data else {
                completion(nil, self.responseError(domain: urlString, code: 204))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(result, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    // MARK:- Request Movie Comments
    /**
     Request Movie Comment List from goorm server.
     
     This Method request Movie Comment List with Asynchronous. After finish download Movie List, call Completion. If fail to Networking, you can check Error. When Networking is Success, Error is nil.
     
     ```
     let movieId: String = "Movie Id"
     
     requestMovieComments(movieId: movieId, completion: { (comments: Comments?, error: Error?) in
        if let comments = comments {
            // Success fetch Comment List
        } else {
            // Fail fetch Comment List
        }
     })
     ```
    
     - parameters:
        - movieId: Movie Id for fetch Comment List.
        - completion: It's going to work after finish Networking. If fail to Networking, Comments is nil.
     */
    final func requestMovieComments(movieId: String, completion: @escaping (Comments?, Error?) -> Void) {
        let urlString = baseURL + url.comments + parameters.commentsMovieId + movieId
        guard let url = URL(string: urlString) else {
            print("Movie Comments URL is Wrong")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let sesstion = URLSession(configuration: .default)
        let dataTask = sesstion.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, self.responseError(domain: urlString, code: response.statusCode))
                return
            }
            guard let data = data else {
                completion(nil, self.responseError(domain: urlString, code: 204))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Comments.self, from: data)
                completion(result, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
}

// MARK:- Sort Type Enum
enum SortType: Int {
    case reservation = 0
    case curation = 1
    case date = 2
}
