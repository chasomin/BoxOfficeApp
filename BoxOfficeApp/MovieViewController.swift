//
//  MovieViewController.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MovieViewController: UIViewController, CommonViewController {
    let viewModel = MovieViewModel()
    let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureView()
        bind()
    }
    
    private func bind() {
        let tableViewItem = PublishSubject<String>()
        
        let input = MovieViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text, tableViewItem: tableViewItem)
        let output = viewModel.transform(input: input)
        
        tableView.rx.modelSelected(DailyBoxOfficeList.self)
            .bind { value in
                tableViewItem.onNext(value.movieNm)
            }
            .disposed(by: disposeBag)
        
        output.movie
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.id, cellType: MovieTableViewCell.self)) { row, element, cell in
                cell.titleLabel.text = element.movieNm
                cell.openDateLabel.text = element.openDt
            }
            .disposed(by: disposeBag)
        
        output.selectItem
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.id, cellType: MovieCollectionViewCell.self)) { item, element, cell in
                cell.titleLabel.text = "\(element)"
            }
            .disposed(by: disposeBag)
        
        output.error
            .debug()
            .asDriver(onErrorJustReturn: APIError.unknownResponse)
        // catch로 error 전달받는데 bind로 받으니까 메인쓰레드 아니라고 오류남⚠️ -> 100% Main 보장인 drive로 변경해서 해결
        //, 아니먄 viewModel에서 구독할 때 observe(on:), subscribe(on:)로 메인쓰레드 지정
            .drive(with: self) { owner, _ in
                owner.showToast()
            }
            .disposed(by: disposeBag)
    }
}

extension MovieViewController {
    private func ConfigureView() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        navigationItem.titleView = searchBar
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.id)
        tableView.backgroundColor = .white
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        collectionView.backgroundColor = .white
        
        searchBar.placeholder = "날짜 검색"
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .horizontal
        return layout
    }
}
