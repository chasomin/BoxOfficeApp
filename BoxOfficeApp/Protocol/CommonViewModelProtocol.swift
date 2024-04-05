//
//  CommonViewModelProtocol.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import Foundation

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
