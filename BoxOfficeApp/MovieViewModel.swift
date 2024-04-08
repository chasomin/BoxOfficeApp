//
//  MovieViewModel.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let tableViewItem: PublishSubject<String>
    }
    
    struct Output {
        let movie: PublishSubject<[DailyBoxOfficeList]>
        let selectItem: BehaviorRelay<[String]>
        let error: PublishSubject<Error>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[DailyBoxOfficeList]>()
        let selectItem: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        let movieError =  PublishSubject<Error>()
        
        input.searchButtonTap
            .withLatestFrom(input.searchText.orEmpty)
            .map {
                guard let date = Int($0) else { return Date().dateForInt() }
                return date
            }
            .map {
                String($0)
            }
            .flatMap{ value in
                BoxOfficeNetwork.fetchBoxOffice(date: value)
                    .catch { error in
                        movieError.onNext(error)
                        return Observable<Movie>.never()
                    }
            }
            .debug()
            .subscribe(onNext: { movie in
                let data = movie.boxOfficeResult.dailyBoxOfficeList
                movieList.onNext(data)
                print("==== Transform Next")
            }, onError: { error in
                print("==== Transform Error")
            }, onCompleted: {
                print("==== Transform Completed")
            }, onDisposed: {
                print("==== Transform Disposed")
            })
            .disposed(by: disposeBag)
        
        input.tableViewItem
            .bind(onNext: { value in
                var list = selectItem.value
                list.append(value)
                selectItem.accept(list)
            })
            .disposed(by: disposeBag)
        
        
        return Output.init(movie: movieList, selectItem: selectItem, error: movieError)
    }
    
}


extension Date {
    func dateForInt() -> Int {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        let result = format.string(from: self-86400)
        return Int(result) ?? 0
    }
}


