//
//  TestView.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/09/23.
//

import UIKit

class TestView: BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
