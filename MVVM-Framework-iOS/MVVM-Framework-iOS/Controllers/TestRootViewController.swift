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
    
    private let versionManager = VersionManager()
    private let viewModel = CocoaTestViewModel()
    private var disposeBag = DisposeBag()
    private var count = 0
    private var isTrueObservable = BehaviorRelay(value: true)
    private let latestVersionLabel = UILabel()
    private let gerwhngreg = UIView()
    
    private let loadingView = LottieAnimationView(name: "testLottie")
    private lazy var toHomeButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        let vc = HomeViewController()
        let vcNavi = UINavigationController(rootViewController: vc)
//        self?.navigationController?.initRootViewController(vc: vc)
//        
//        self?.navigationController?.pushViewController(vc, animated: true)

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        sceneDelegate.window?.rootViewController = vcNavi
        sceneDelegate.window?.makeKeyAndVisible()
        
    }))
    private lazy var toInstaShareButton = UIButton()
//        frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
//        let vc = InstagramShareViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .overFullScreen
//        self?.present(nav, animated: true)

    private let testToggle = UISwitch()
    private lazy var emailButton = TestButtonForIncreaseTappingArea()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        view.backgroundColor = .yellow
        
        latestVersionLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
        }
        
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
        
        view.addSubview(latestVersionLabel)
        view.addSubview(toHomeButton)
        view.addSubview(toInstaShareButton)
        view.addSubview(testToggle)
        view.addSubview(emailButton)
        
        latestVersionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(200)
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
        Task {
            guard let pp = await versionManager.shouldUpdate() else { return }
            self.latestVersionLabel.text = pp.latestVersion
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
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
            .debounce(.seconds(2))
            .drive(onNext: { _ in
                self.count += 1
                print("🌸", self.count)
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
        print("IAP VC Out ❗️❗️❗️❗️❗️❗️")
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

extension UINavigationController {
/**
 It removes all view controllers from navigation controller then set the new root view controller and it pops.
 
 - parameter vc: root view controller to set a new
 */
func initRootViewController(vc: UIViewController, transitionType type: String = kCATransition, duration: CFTimeInterval = 0.3) {
    self.addTransition(transitionType: type, duration: duration)
    self.viewControllers.removeAll()
    self.pushViewController(vc, animated: false)
    self.popToRootViewController(animated: false)
}

/**
 It adds the animation of navigation flow.
 
 - parameter type: kCATransitionType, it means style of animation
 - parameter duration: CFTimeInterval, duration of animation
 */
private func addTransition(transitionType type: String = kCATransition, duration: CFTimeInterval = 0.1) {
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    transition.type = CATransitionType.moveIn
    
    self.view.layer.add(transition, forKey: nil)
}}
