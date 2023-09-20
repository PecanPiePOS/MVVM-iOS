//
//  PhotoCell.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/12.
//

import UIKit
import MyFramework

import SnapKit
import Then

protocol ShareButtonTappedProtocol: AnyObject {
    func openActivityVC(sharingView: UIView)
}

final class PhotoCell: UICollectionViewCell {
    
    private let photoImageView = UIImageView()
    private let photoShareButton = UIButton()
    private let viewModel = PhotoAlbumViewModel()
    weak var delegate: ShareButtonTappedProtocol?
    
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
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        
        photoImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
        }
        
        photoShareButton.do {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
            $0.setImage(UIImage(systemName: "die.face.6", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(shareInstagram), for: .touchUpInside)
        }
    }
    
    private func bindLayout() {
        self.addSubview(photoImageView)
        self.addSubview(photoShareButton)
        
        photoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        photoShareButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(12)
        }
    }
}

extension PhotoCell {
    func configure(imageOf image: String) {
        self.photoImageView.image = UIImage(named: image)
    }
    
    func removeImageFromTheSuperViewForSharing() {
        self.photoShareButton.removeFromSuperview()
    }
    
    func reappearImageForConfiguring() {
        self.addSubview(photoShareButton)
        
        photoShareButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(12)
        }
    }
    
    @objc
    private func shareInstagram() {
        removeImageFromTheSuperViewForSharing()
        self.delegate?.openActivityVC(sharingView: self)
//        viewModel.shareInstagram(sharingView: self)
        reappearImageForConfiguring()
    }
}
