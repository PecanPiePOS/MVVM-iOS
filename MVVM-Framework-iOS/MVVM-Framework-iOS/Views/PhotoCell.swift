//
//  PhotoCell.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/12.
//

import UIKit

import SnapKit
import Then

final class PhotoCell: UICollectionViewCell {
    
    private let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindStyles()
        bindLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoCell {
    private func bindStyles() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        self.photoImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func bindLayout() {
        self.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }
}

extension PhotoCell {
    func configure(imageOf image: String) {
        self.photoImageView.image = UIImage(named: image)
    }
}
