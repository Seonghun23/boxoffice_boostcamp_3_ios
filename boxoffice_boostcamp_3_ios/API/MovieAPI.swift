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
    static var sortType: SortType = .reservation
    
    // MARK:- Request Movie List
    final func requestMovieList(sort: SortType, completion: @escaping (MovieList?, Error?)-> Void) {
        let urlString = baseURL + url.list + parameters.orderType + String(sort.rawValue)
        guard let url = URL(string: urlString) else {
            print("Movie List URL is Wrong.")
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
