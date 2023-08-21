//
//  MoyaTestTableViewCell.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/21.
//

import UIKit

import SnapKit
import Then

final class MoyaTestTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .systemCyan
        
        nameLabel.do {
            $0.font = .boldSystemFont(ofSize: 15)
            $0.textColor = .blue
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        
        avatarImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        
        avatarImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(40)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        avatarImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellHeight = self.frame.height
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height/2
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(cellHeight/1.3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoyaTestTableViewCell {
    func configureWithoutCache(firstName: String, lastName: String, image: String) {
        nameLabel.text = firstName + " " + lastName
        avatarImageView.load(url: image)
    }
    
    func configureWithCache(firstName: String, lastName: String, image: UIImage) {
        nameLabel.text = firstName + " " + lastName
        avatarImageView.image = image
    }
}
