//
//  ViewController.swift
//  MVVM-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/02.
//

import UIKit
import MyLibrary

import SnapKit
import Then

class ViewController: UIViewController {

    private let testLabel = UILabel()
    private let libraryTestModel = MyLibraryTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        let text: String = String(libraryTestModel.multiplyAndMinus(with: 4, times: 7, minus: 8))
        
        testLabel.text = text
        
        view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
