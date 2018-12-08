//
//  CommentList.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

// MARK:- Comment List Data Model
struct Comments: Decodable {
    let commentList: [Comment]
}

// MARK:- Comment Data Model for Comment List
struct Comment: Decodable {
    let timestamp: Double
    let contents: String
    let writer: String
    let movieId: String
    let rating: Double
    
    var dateAndTime: String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
}
