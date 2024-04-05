//
//  MovieTableViewCell.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {

    static let id = MovieTableViewCell.description()

    let titleLabel = UILabel()
    let openDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MovieTableViewCell {
    private func configureView() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(openDateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        openDateLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .black
        
        openDateLabel.font = .systemFont(ofSize: 15)
        openDateLabel.textColor = .gray
    }
}
