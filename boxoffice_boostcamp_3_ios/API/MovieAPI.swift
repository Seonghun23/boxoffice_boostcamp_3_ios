//
//  MovieAPI.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

class MovieAPI {
    // MARK:- URL List
    private let baseURL = "http://connect-boxoffice.run.goorm.io"
    private let listURL = "/movies"
    private let orderTypeParameter = "?order_type="
    private let detailInfoURL = "/movie"
    private let movieIdParameter = "?id="
    private let commentsURL = "/comments"
    private let commentsMovieId = "?movie_id="
    
    // MARK:- Properties
    static var sortType: SortType = .reservation
    private let networkingError = NetworkingError()
    
    func requestMovieList(completion: @escaping (MovieList?, Error?)-> ()) {
        
    }
    
    enum SortType: Int {
        case reservation = 0
        case curation = 1
        case date = 2
    }
}
