//
//  MoyaRxTestViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit
import MyFramework

import Moya
import RxCocoa
import RxMoya
import RxSwift
import SnapKit
import Then

final class MoyaRxTestViewController: UIViewController {

//    private let provider = MoyaProvider<NetworkApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private let provider = MoyaProvider<NetworkApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var disposeBag = DisposeBag()
    private let tableView = UITableView(frame: .zero)
    private let nameLabel = UILabel()
    private var requestFetched: Observable<[UserData]>?
    private var tableViewData: BehaviorSubject<[UserData]> = BehaviorSubject(value: [])
    private let cacheManager = ImageCacheManager.shared
    
    private lazy var button = UIButton(type: .custom, primaryAction: UIAction(handler: { [weak self] _ in
        self?.subscribeNetwork()
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        setStyles()
        setLayout()
    }
    
    deinit {
        print("MoyaRxTestVC OUT")
    }
    
    private func setViewModel() {
        // ⭐️⭐️⭐️ 왜 Moya 를 Rx 로 써야하는지... 참고: https://leejigun.github.io/Tayga-Moya,RxSwift
        let userFetchData = UserPageModel(page: 1, perPage: 10)
        
        /// 여기서 받은걸 Observable 로 만들기
        self.requestFetched = provider.rx.request(.fetchListOfUsers(userFetchData))
            .retry(3)
            .asObservable()
            .map { try JSONDecoder().decode(UsersModel.self, from: $0.data) }
            .catchAndReturn(nil)
            .map { $0?.data ?? [] }
        
        tableViewData
            .bind(to: tableView.rx.items(cellIdentifier: "tableView", cellType: MoyaTestTableViewCell.self)) { [weak self]
                index, data, cell in
                let firstName = data.firstName
                let lastName = data.lastName
                let imageUrl = data.avatar
                let cacheKey = NSString(string: imageUrl)
                
                if let cachedImage = self?.cacheManager.object(forKey: cacheKey) {
                    cell.configureWithCache(firstName: firstName, lastName: lastName, image: cachedImage)
                } else {
                    cell.configureWithoutCache(firstName: firstName, lastName: lastName, image: imageUrl)
                }
            }
            .disposed(by: disposeBag)
}
    
    private func setStyles() {
        view.backgroundColor = .blue
        
        button.do {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.tintColor = .green
            $0.setTitle("Fetch the observable", for: .normal)
        }
        
        tableView.do {
            $0.rowHeight = 80
            $0.register(MoyaTestTableViewCell.self, forCellReuseIdentifier: "tableView")
            $0.backgroundColor = .darkGray
        }
    }
    
    private func setLayout() {
        view.addSubview(button)
        view.addSubview(tableView)
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(200)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(button.snp.bottom).offset(30)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
}

extension MoyaRxTestViewController {
    private func subscribeNetwork() {
        requestFetched?.subscribe(
            onNext: { [weak self] data in
                self?.tableViewData.onNext(data)
                print("Connection is Good")
        },
            onError: { error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
}
