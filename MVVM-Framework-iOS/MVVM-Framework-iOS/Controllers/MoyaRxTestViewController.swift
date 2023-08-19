//
//  MoyaRxTestViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit
import MyFramework

import Moya
import SnapKit
import Then

final class MoyaRxTestViewController: UIViewController {

    private let provider = MoyaProvider<NetworkApi>()
    
    private let tableView = UITableView(frame: .zero)
    private let nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }
}
