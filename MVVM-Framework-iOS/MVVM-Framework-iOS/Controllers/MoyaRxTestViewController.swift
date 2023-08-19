//
//  IAPViewController.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/13.
//

import UIKit

import Moya
import MyFramework

final class MoyaRxTestViewController: UIViewController {

    let provider = MoyaProvider<NetworkApi>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }
}
