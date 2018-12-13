//
//  MovieList.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

// MARK:- Movie List Data Model
struct MovieList: Decodable {
    let orderType: Int
    let movies: [MovieInfo]
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

// MARK:- Movie Information Data Model for Movie List
struct MovieInfo: Decodable {
    let title: String
    let reservationGrade: Int
    let grade: Int
    let date: String
    let reservationRate: Double
    let userRating: Double
    let thumb: String
    let id: String
    
    var tableViewRateString: String {
        return "평점 : " + String(format: "%.2f", userRating) + " 예매순위 : " + String(format: "%d", reservationGrade) + " 예매율 : " + String(format: "%.1f", reservationRate)
    }
    var tableViewDateString: String {
        return "개봉일 : " + date
    }
    var collectionViewRateString: String {
        return String(format: "%d", reservationGrade) + "위(" + String(format: "%.2f", userRating) + ") / " + String(format: "%.1f", reservationRate) + "%"
    }
    var gradeType: Grade {
        return Grade(rawValue: String(grade)) ?? .all
    }
    
    enum CodingKeys: String, CodingKey {
        case title, grade, date, thumb, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
