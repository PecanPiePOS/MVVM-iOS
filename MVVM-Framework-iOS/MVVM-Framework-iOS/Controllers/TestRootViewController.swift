//
//  TestRootViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit
import MyFramework

import Lottie
import RxCocoa
import RxSwift
import SnapKit
import Then

final class TestRootViewController: MailManager {
    
    private let testView = TestView()
    private let viewModel = CocoaTestViewModel()
    private var disposeBag = DisposeBag()
    private var count = 0
    private var isTrueObservable = BehaviorRelay(value: true)
    
    private let loadingView = LottieAnimationView(name: "testLottie")
    private lazy var toHomeButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        let vc = HomeViewController()
        self?.navigationController?.pushViewController(vc, animated: true)
        
        if let kkk = UserDefaults.standard.string(forKey: "Hi") {
            print(kkk)
        } else {
            print("nil")
        }
        
        if let ooo = UserDefaults.standard.string(forKey: "Hey") {
            print(ooo)
        } else {
            print("nilllll")
        }
        
    }))
    private lazy var toInstaShareButton = UIButton()
//        frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
//        let vc = InstagramShareViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .overFullScreen
//        self?.present(nav, animated: true)
        
//        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
//        let alert = UIAlertController(title: "기기의 Mail에 먼저 로그인 해주세요.", message: "설정에서 Apple 로그인을 해주세요.", preferredStyle: .alert)
//        let moveToDeviceSettingAction = UIAlertAction(title: "설정", style: .default) { _ in
//            UIApplication.shared.open(settingUrl)
//        }
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//        
//        alert.addAction(moveToDeviceSettingAction)
//        alert.addAction(cancelAction)
//        alert.preferredAction = moveToDeviceSettingAction
//        self?.present(alert, animated: true)
//        
//        if let bundleId = Bundle.main.bundleIdentifier {
//            print(bundleId)
//            UserDefaults.standard.removePersistentDomain(forName: bundleId)
//        } else {
//            print("Damn.")
//        }
        
//    }))
    private let testToggle = UISwitch()
    private lazy var emailButton = TestButtonForIncreaseTappingArea()
//    (frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
//        self?.sendFeedbackMail(userOf: "게일")
//    }))
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
        print(UIDevice.current.name)
        
        UserDefaults.standard.set("Hello", forKey: "Hi")
        
        bind()
        
        view.backgroundColor = .yellow
        
        loadingView.do {
            $0.loopMode = .autoReverse
            $0.play()
        }
        
        testToggle.rx.isOn
            .skip(1)
            .subscribe { response in
                print(response ? "ON: \(response)" : "OFF: \(response)")
            }
            .disposed(by: disposeBag)
        
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
        
        testToggle.do {
            $0.onTintColor = .blue
            $0.preferredStyle = .sliding
        }
        
        emailButton.do {
            $0.setImage(UIImage(systemName: "envelope.badge"), for: .normal)
            $0.tintColor = .blue
            $0.backgroundColor = .red
        }
        
//        view.addSubview(loadingView)
        view.addSubview(toHomeButton)
        view.addSubview(toInstaShareButton)
        view.addSubview(testToggle)
        view.addSubview(emailButton)
        view.addSubview(testView)

        testView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(500)
        }
        
        toHomeButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        toInstaShareButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(toHomeButton.snp.bottom).offset(30)
        }
        
        testToggle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(toInstaShareButton.snp.bottom).offset(30)
        }
        
        emailButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(testToggle.snp.bottom).offset(30)
        }
        
        checkAbnormalDevice()
        print("3️⃣")
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
//            DispatchQueue.main.async {
//                print("STOP!")
//                self?.loadingView.stop()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("AAAAAA")
    }
    
    private func printLALA() {
        print("aaaaaaa")
    }
    
    private func checkAbnormalDevice() {
        let userDefaults = UserDefaults.standard
        let deviceName = UIDevice.current.name
        let abnormalDeviceList = DeviceLiterals.allCases
        abnormalDeviceList.forEach { device in
            if deviceName == device.deviceName {
                userDefaults.set(true, forKey: "abnormalDevice")
                print("1️⃣")
                return
            }
        }
        print(deviceName)
        print("2️⃣")
        print(userDefaults.bool(forKey: "abnormalDevice"))
    }
    
    private func bind() {
        emailButton.rx.tap.asDriver()
//            .debounce(.seconds(2))
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { _ in
                self.count += 1
                print("🌸", self.count)
                self.testView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        Observable.zip(toInstaShareButton.rx.tap, self.isTrueObservable)
            .bind { [weak self] i, j in
                if j == false {
                    let vc = InstagramShareViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .overFullScreen
                    self?.present(nav, animated: true)
                }
                print(i, j)
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("IAP VC Out")
    }
}

enum DeviceLiterals: CaseIterable {
    case six
    case sixPlus
    case sixS
    case sixSPlus
    case seven
    case sevenPlus
    case eight
    case eightPlus
    case seOne
    case seTwo
    case seThree
    case iPadMiniFour
    case iPadMiniFive
    case iPadMiniSix
//    case iPadMiniSeven
    
    var deviceName: String {
        switch self {
        case .six:
            return "iPhone 6"
        case .sixPlus:
            return "iPhone 6 Plus"
        case .sixS:
            return "iPhone 6s"
        case .sixSPlus:
            return "iPhone 6s Plus"
        case .seven:
            return "iPhone 7"
        case .sevenPlus:
            return "iPhone 7 Plus"
        case .eight:
            return "iPhone 8"
        case .eightPlus:
            return "iPhone 8 Plus"
        case .seOne:
            return "iPhone SE (1st generation)"
        case .seTwo:
            return "iPhone SE (2nd generation)"
        case .seThree:
            return "iPhone SE (3rd generation)"
        case .iPadMiniFour:
            return "iPad mini 4"
        case .iPadMiniFive:
            return "iPad mini (5th generation)"
        case .iPadMiniSix:
            return "iPad mini (6th generation)"
        }
    }
}

class TestButtonForIncreaseTappingArea: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
