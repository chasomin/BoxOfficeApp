//
//  Movie.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
}
