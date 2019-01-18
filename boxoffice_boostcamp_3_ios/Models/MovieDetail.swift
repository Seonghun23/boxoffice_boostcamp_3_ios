//
//  MovieDetailInfo.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

// MARK: - Movie Detail Infomation Data Model
struct MovieDetail: Decodable {
    let title: String?
    let duration: Int?
    let audience: Int?
    let actor: String?
    let director: String?
    let synopsis: String?
    let genre: String?
    let grade: Int?
    let image: String?
    let reservationGrade: Int?
    let reservationRate: Double?
    let userRating: Double?
    let date: String?
    let id: String?
    
    // MARK:- Return Release Date String
    var releaseDate: String {
        return date ?? "" + "개봉"
    }
    
    // MARK:- Return Genre and Duration String
    var genreAndDuration: String {
        return genre ?? "" + "/" + String(format: "%d", duration ?? 0) + "분"
    }
    
    // MARK:- Reservation Grade and Rate String
    var reservation: String {
        return String(format: "%d", reservationGrade ?? 0) + "위 " + String(format: "%.1f", reservationRate ?? 0) + "%"
    }
    
    // MARK:- Audience Number String
    var audienceNumber: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let nsNumber = NSNumber(value: audience ?? 0)
        guard let decimalNum = numberFormatter.string(from: nsNumber) else { return "0" }
        
        return decimalNum
    }
    
    // MARK:- Return Grade Type
    var gradeType: Grade {
        return Grade(rawValue: String(grade ?? 0)) ?? .all
    }
    
    // MARK:- Coding Keys
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
