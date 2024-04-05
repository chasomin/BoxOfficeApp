//
//  MovieCollectionViewCell.swift
//  BoxOfficeApp
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let id = MovieCollectionViewCell.description()
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MovieCollectionViewCell {
    private func configureCell() {
        contentView.backgroundColor = .black    
        contentView.layer.cornerRadius = 15

        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        titleLabel.textColor = .white
    }
}
