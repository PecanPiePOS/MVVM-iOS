//
//  TestRootViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit

import FirebaseAnalytics
//import Firebase
import SnapKit
import Then

final class TestRootViewController: UIViewController {
    
    private lazy var toHomeButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        let vc = HomeViewController()
        self?.navigationController?.pushViewController(vc, animated: true)
    }))
    
    private lazy var toInstaShareButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        let vc = InstagramShareViewController()
        vc.initlll()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self?.present(nav, animated: true)
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        toHomeButton.do {
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "house", withConfiguration: configuration), for: .normal)
        }
        
        toInstaShareButton.do {
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            $0.tintColor = .systemMint
            $0.setImage(UIImage(systemName: "lasso.and.sparkles", withConfiguration: configuration), for: .normal)
        }
        
        view.addSubview(toHomeButton)
        view.addSubview(toInstaShareButton)

        toHomeButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        toInstaShareButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(toHomeButton.snp.bottom).offset(40)
        }
    }
    
    deinit {
        print("IAP VC Out")
    }
}
