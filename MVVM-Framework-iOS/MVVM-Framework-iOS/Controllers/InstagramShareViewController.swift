//
//  InstagramShareViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/31.
//

import UIKit

import SnapKit
import Then

final class InstagramShareViewController: UIViewController {

    private let sharingView = UIView()
    private let stickerImageView = UIImageView()
    private lazy var shareButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.shareInstagram()
    }))
    private lazy var pushOnPresentButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.pushOnPresentVC()
    }))
    private lazy var dismissButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.dismiss(animated: true)
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setStyles()
    }

    deinit {
        print(self.className)
    }
}

extension InstagramShareViewController {
    
    private func setStyles() {
        view.backgroundColor = .black
                
        sharingView.do {
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 3
            $0.backgroundColor = .systemPink
        }
        
        stickerImageView.do {
            $0.image = UIImage(named: "MVVMIcon")
            $0.contentMode = .scaleAspectFit
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        
        shareButton.do {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 34)
            $0.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfiguration), for: .normal)
            $0.tintColor = .white
        }
        
        pushOnPresentButton.do {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 34)
            $0.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill", withConfiguration: imageConfiguration), for: .normal)
            $0.tintColor = .green
        }
        
        dismissButton.do {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
            $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfiguration), for: .normal)
            $0.tintColor = .white
        }
    }
    
    private func setLayout() {
        sharingView.addSubview(stickerImageView)
        view.addSubview(sharingView)
        view.addSubview(shareButton)
        view.addSubview(pushOnPresentButton)
        view.addSubview(dismissButton)
        
        stickerImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        sharingView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(80)
            $0.height.equalTo(400)
            $0.top.equalToSuperview().inset(100)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(sharingView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        pushOnPresentButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(25)
            $0.size.equalTo(30)
        }
    }
}

extension InstagramShareViewController {
    private func pushOnPresentVC() {
        let vc = PoPTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func isInstagramInstalled() -> Bool {
        guard let instagramURL = URL(string: "instagram-stories://share") else {
            return false
        }
        return UIApplication.shared.canOpenURL(instagramURL)
    }
    
    private func shareInstagram() {
        guard let instagramURL = URL(string: "instagram-stories://share?source_application=" + "314518827793677") else { return }
        
        print("Available URL")
        
        if isInstagramInstalled() != false {
            let renderer = UIGraphicsImageRenderer(size: sharingView.bounds.size)
            
            let renderImage = renderer.image { _ in
                sharingView.drawHierarchy(in: sharingView.bounds, afterScreenUpdates: true)
            }
            
            guard let imageData = renderImage.pngData() else { return }
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundTopColor" : "#FC5555",
                "com.instagram.sharedSticker.backgroundBottomColor" : "#176AB7"
            ]
            
            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
            ]
            
            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            print("HEY!")
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
            print("NOPE")
        } else {
            print("Unavailable URL")
            
            guard let instagramURL = URL(string: "https://apps.apple.com/kr/app/instagram/id389801252") else {
                return
            }
            return UIApplication.shared.open(instagramURL)
        }
    }
}
