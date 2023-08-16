//
//  TestRootViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit

import SnapKit
import Then

final class TestRootViewController: UIViewController {

    private lazy var toHomeButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        let vc = HomeViewController()
        self?.navigationController?.pushViewController(vc, animated: true)
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        toHomeButton.do {
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "house", withConfiguration: configuration), for: .normal)
        }
        
        view.addSubview(toHomeButton)
        
        toHomeButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
    }
    
    deinit {
        print("IAP VC Out")
    }
}
