//
//  CommonViewControllerProtocol.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import Foundation
import RxSwift

protocol CommonViewController {
    var disposeBag: DisposeBag { get }
    associatedtype ViewModel: CommonViewModel
    var viewModel: ViewModel { get }
}
