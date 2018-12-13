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
    
    // MARK:- Coding Keys
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
    
    // MARK:- Return User Rating, Reservation Grade And Rate String for Table View
    var tableViewRateString: String {
        return "평점 : " + String(format: "%.2f", userRating) + " 예매순위 : " + String(format: "%d", reservationGrade) + " 예매율 : " + String(format: "%.1f", reservationRate)
    }
    
    // MARK:- Return Date String for Table View
    var tableViewDateString: String {
        return "개봉일 : " + date
    }
    
    // MARK:- Return User Rating, Reservation Grade And Rate String for Collection View
    var collectionViewRateString: String {
        return String(format: "%d", reservationGrade) + "위(" + String(format: "%.2f", userRating) + ") / " + String(format: "%.1f", reservationRate) + "%"
    }
    
    // MARK:- Return Grade Type
    var gradeType: Grade {
        return Grade(rawValue: String(grade)) ?? .all
    }
    
    // MARK:- Coding Keys
    enum CodingKeys: String, CodingKey {
        case title, grade, date, thumb, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
