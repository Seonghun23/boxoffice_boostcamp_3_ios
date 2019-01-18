//
//  MovieAPI.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation
/*
 네트워크 레이어를 조금 더 여러군데에 활용할 수 있게끔 구현해 보았습니다.
 네트워크 부분을 싱글턴 패턴으로 변경하였습니다.
 */
class MovieAPI: ErrorProcessing {
    // MARK:- URL List
    
    static let shared = MovieAPI() //싱글턴 패턴을 이용해 보았습니다.
    private let baseURL = "http://connect-boxoffice.run.goorm.io"
    enum Url {
        case list
        case detail
        case comments
    }
    enum Parameters {
        case orderType
        case movieId
        case commentsMovieId
    }
   
    private init() {} // 외부에서 객체화 안되게끔 처리합니다.
    // MARK:- Sort Type
    /**
     Static Movie List Sort Type Property.
     */
    var sortType: SortType = .reservation
    
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
    
    func makeRequest(url: Url, param: Parameters, _ movieId: String = "", _ sortType: SortType = .reservation) -> URLRequest? {
        
        var urlString = baseURL
        switch url {
        case .list:
            urlString.append("/movies")
        case .detail:
            urlString.append("/movie")
        case .comments:
            urlString.append("/comments")
        }
        switch param {
        case .orderType:
            urlString.append("?order_type=\(sortType.rawValue)")
        case .movieId:
            urlString.append("?id=\(movieId)")
        case .commentsMovieId:
            urlString.append("?movie_id=\(movieId)")
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    final func requestMovieData<T: Decodable>(request: URLRequest, with decodeType: T.Type, completion: @escaping (T?, Error?)-> Void) {
        
        
        let session = URLSession(configuration: .default) //오타가 있습니다 <session>
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, self.responseError(domain: request.url?.absoluteString ?? "", code: response.statusCode))
                return
            }
            guard let data = data else {
                completion(nil, self.responseError(domain: request.url?.absoluteString ?? "", code: 204))
                return
            }
            do {
                let result = try JSONDecoder().decode(decodeType, from: data)
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

