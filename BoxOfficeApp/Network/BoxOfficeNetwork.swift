//
//  BoxOfficeNetwork.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import Foundation
import RxSwift

enum APIError: String, Error {
    case invalidURL = "잘못된 URL"
    case unknownResponse = "알 수 없는 응답"
    case statusError = "상태코드 오류"
    case decodingError = "응답은 왔으나 디코딩 실패"
}

final class BoxOfficeNetwork {

    static func fetchBoxOffice(date: String) -> Observable<Movie> {
        return Observable<Movie>.create { observer in
            guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.key)&targetDt=\(date)") else {
                observer.onError(APIError.invalidURL)
                print(APIError.invalidURL.rawValue)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("DataTask Succeed")
                if let _ = error {
                    print(APIError.unknownResponse.rawValue)
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print(APIError.statusError.rawValue)
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted() //✅
                } else {
                    print(APIError.decodingError.rawValue)
                    observer.onError(APIError.decodingError)
                }
                
            }.resume()
            
            return Disposables.create()
        }.debug()
    }
    
    
    static func fetchBoxOfficeSingleResult(date: String) -> Single<Result<Movie, APIError>> {
        return Single<Result<Movie, APIError>>.create { single in
            guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.key)&targetDt=\(date)") else {
                single(.success(.failure(.invalidURL)))
                print(APIError.invalidURL.rawValue)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("DataTask Succeed")
                if let _ = error {
                    print(APIError.unknownResponse.rawValue)
                    single(.success(.failure(.unknownResponse)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print(APIError.statusError.rawValue)
                    single(.success(.failure(.statusError)))
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    single(.success(.success(appData)))
                } else {
                    print(APIError.decodingError.rawValue)
                    single(.success(.failure(.decodingError)))
                }
                
            }.resume()
            
            return Disposables.create()
        }
    }

}
