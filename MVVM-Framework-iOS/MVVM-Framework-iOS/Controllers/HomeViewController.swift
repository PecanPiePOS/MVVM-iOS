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

extension NSObject {
    var className: String {
       NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
   }
}

final class HomeViewController: UIViewController {

    private var disposeBag = DisposeBag()
    private let viewModel: PhotoAlbumViewModelType = PhotoAlbumViewModel()
    
    private let refreshButton = UIButton(type: .system)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setFlowLayout())
    private let circle = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindStyles()
        bindViewModel()
        bindLayout()
        UserDefaults.standard.set("Helloooo", forKey: "Hey")
    }
    
    deinit {
        print(self.className)
        disposeBag = DisposeBag()
    }
}

extension HomeViewController {
    
    private func bindViewModel() {
        self.viewModel.outputs.photoAlbumLists
            .bind(to: collectionView.rx.items(cellIdentifier: "photoCell", cellType: PhotoCell.self))
            { row, element, cell in
                cell.configure(imageOf: element)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        self.refreshButton.rx.tap
            .bind { [weak self] in
                let vc = MoyaRxTestViewController()
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
        
        circle.do {
            $0.image = UIImage(systemName: "circle.fill")
            $0.tintColor = .red
        }
    }
    
    private func bindLayout() {
        view.addSubview(collectionView)
        view.addSubview(refreshButton)
        view.addSubview(circle)
        
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
        
        circle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(collectionView.snp.top)
            $0.size.equalTo(30)
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

extension HomeViewController: ShareButtonTappedProtocol {
    func openActivityVC(sharingView: UIView) {
        shareInstagram(sharingView: sharingView)
    }
    
    private func isInstagramInstalled() -> Bool {
        guard let instagramURL = URL(string: "instagram-stories://share") else {
            return false
        }
        return UIApplication.shared.canOpenURL(instagramURL)
    }
    
    public func shareInstagram(sharingView: UIView) {
                
        guard let instagramURL = URL(string: "instagram-stories://share?source_application=" + "314518827793677") else { return }

        print("Available URL")

        if isInstagramInstalled() != false {
//            let renderer = UIGraphicsImageRenderer(size: sharingView.bounds.size)
//
//            let renderImage = renderer.image { _ in
//                sharingView.drawHierarchy(in: sharingView.bounds, afterScreenUpdates: true)
//            }

            guard let imageData = sharingView.saveUIViewWithScale(with: 5) else { return }
//            guard let renderImage = UIImage(data: imageData) else { return }
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundTopColor" : "#F9F9F9",
                "com.instagram.sharedSticker.backgroundBottomColor" : "#F6F6F6"
            ]

            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
            ]

            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            
//            let activityViewController = UIActivityViewController(activityItems: [renderImage], applicationActivities: nil)
//            activityViewController.excludedActivityTypes = [.addToReadingList]
//            self.present(activityViewController, animated: true)
            
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            print("Unavailable URL")

            guard let instagramURL = URL(string: "https://apps.apple.com/kr/app/instagram/id389801252") else {
                return
            }
            return UIApplication.shared.open(instagramURL)
        }
    }
}
