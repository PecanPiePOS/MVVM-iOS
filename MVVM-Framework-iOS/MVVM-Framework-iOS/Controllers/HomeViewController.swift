//
//  HomeViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit
import MyFramework

import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeViewController: UIViewController {

    private var disposeBag = DisposeBag()
    private let viewModel: PhotoAlbumViewModelType = PhotoAlbumViewModel()
    
    private let refreshButton = UIButton(type: .system)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindStyles()
        bindViewModel()
        bindLayout()
    }
    
    deinit {
        print("HomeVC OUT")
    }
}

extension HomeViewController {
    
    private func bindViewModel() {
        self.viewModel.outputs.photoAlbumLists
            .bind(to: collectionView.rx.items(cellIdentifier: "photoCell", cellType: PhotoCell.self))
            { row, element, cell in
                cell.configure(imageOf: element)
            }
            .disposed(by: disposeBag)
        
        self.refreshButton.rx.tap
            .bind { [weak self] in
                let vc = TestViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindStyles() {
        view.backgroundColor = .orange
        
        refreshButton.do {
            let symbolCofiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
            $0.setImage(UIImage(systemName: "arrow.clockwise.circle.fill", withConfiguration: symbolCofiguration), for: .normal)
            $0.tintColor = .white
        }
        
        collectionView.do {
            $0.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
    }
    
    private func bindLayout() {
        view.addSubview(collectionView)
        view.addSubview(refreshButton)
        
        refreshButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.5)
        }
    }
    
    private func setFlowLayout() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 15
        flowlayout.minimumInteritemSpacing = 15
        return flowlayout
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width / 2.5
        let height: CGFloat = view.frame.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        self.viewModel.inputs.updatePhotos(index: indexPath.item)
    }
}

extension HomeViewController {
    
}
