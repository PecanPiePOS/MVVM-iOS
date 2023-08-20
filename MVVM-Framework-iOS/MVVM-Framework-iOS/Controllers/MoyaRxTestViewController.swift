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
    private let provider = MoyaProvider<NetworkApi>()
    private var disposeBag = DisposeBag()
    private let tableView = UITableView(frame: .zero)
    private let nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        setStyles()
        setLayout()
    }
    
    private func setViewModel() {
        let userFetchData = UserPageModel(page: 2, perPage: 3)
        
        // ⭐️⭐️⭐️ 왜 Moya 를 Rx 로 써야하는지... 참고: https://leejigun.github.io/Tayga-Moya,RxSwift
        let requestFetchingList =  provider.rx.request(.fetchListOfUsers(userFetchData)).asObservable()
        
        
//        requestFetchingList.subscribe { event in
//            switch event {
//            case .success(let response):
//                guard let data = try? response.map(GeneralResponse<[UserData]>.self).data else { return }
//                print("⭐️⭐️⭐️⭐️⭐️⭐️")
//                print(data)
//                print("⭐️⭐️⭐️⭐️⭐️⭐️")
//
//                /// 1. 여기서 받은걸 Observable 로 만들기
//                /// 2. Framework 에 넣을 수 없는 이유
//                ///     a. Computed Property 를 사용하면, Dynamic Framework 에서는 Build 오류가 발생
//                ///  - https://hururuek-chapchap.tistory.com/230
//
//            case .failure(_):
//                print("⚠️⚠️⚠️⚠️")
//            }
//        }
//        .disposed(by: self.disposeBag)
    }
    
    private func setStyles() {
        view.backgroundColor = .blue

    }
    
    private func setLayout() {
        
    }
}
