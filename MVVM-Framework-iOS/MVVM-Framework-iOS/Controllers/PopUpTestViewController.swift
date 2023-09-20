//
//  PopUpTestViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/09/25.
//

import UIKit

import SnapKit
import Then

class BottomSheetVCTest: UIViewController {
    
    private let vieww = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        vieww.do {
            $0.backgroundColor = .green
        }
        
        view.addSubview(vieww)
        
        vieww.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
    }
    
}

class CustomPopupView: UIView {
    // Declare UI elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yes", for: .normal)
        button.backgroundColor = .green // Customize the button appearance
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .red // Customize the button appearance
        return button
    }()
    
    private let stackView = UIStackView()
    
    // Callback closures for button actions
    var yesButtonAction: (() -> Void)?
    var cancelButtonAction: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(yesButton)
        
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
//        yesButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.bottom.equalToSuperview().offset(-20)
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//        }
//
//        cancelButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-20)
//            make.bottom.equalToSuperview().offset(-20)
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//        }
    }
    
    // MARK: - Button Actions
    
    @objc private func yesButtonTapped() {
        yesButtonAction?()
    }
    
    @objc private func cancelButtonTapped() {
        cancelButtonAction?()
    }
}




class BlurBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5) // Adjust the alpha value for transparency
        
        let blurEffect = UIBlurEffect(style: .light) // You can adjust the blur style
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}










class PopUpTestViewController: UIViewController {
    private let customPopupView = CustomPopupView()
    private let backgroundBlurView = BlurBackgroundView()
    private let viewview = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown

        let showPopupButton = UIButton()
        showPopupButton.setTitle("Show Popup", for: .normal)
        showPopupButton.backgroundColor = .blue
        showPopupButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        
        viewview.do {
            $0.backgroundColor = .cyan
            $0.layer.cornerRadius = 15
        }
        
        view.addSubview(showPopupButton)
        view.addSubview(viewview)
        view.addSubview(backgroundBlurView)

        showPopupButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        viewview.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
            $0.bottom.equalTo(showPopupButton.snp.top).offset(-200)
        }

        // Customize the title and actions for the custom popup view
        customPopupView.titleLabel.text = "Custom Popup"
        customPopupView.yesButtonAction = { [weak self] in
            // Handle "Yes" button tap action here
            print("Yes button tapped")
            self?.backgroundBlurView.removeFromSuperview()
            self?.customPopupView.removeFromSuperview()
        }
        customPopupView.cancelButtonAction = { [weak self] in
            // Handle "Cancel" button tap action here
            print("Cancel button tapped")
//            self?.backgroundBlurView.removeFromSuperview()
//            self?.customPopupView.removeFromSuperview()
            fatalError("App CRASH!")
        }
        
        
//        backgroundBlurView.do {
//            $0.backgroundColor = .black.withAlphaComponent(0.4)
//            $0.
//        }
        
        
    }

    @objc private func showPopup() {
        view.addSubview(backgroundBlurView)
        view.addSubview(customPopupView)

        backgroundBlurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Set initial position off the screen
        customPopupView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(200)
        }
        
        customPopupView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.customPopupView.transform = .identity
        }
    }
    
   
}

