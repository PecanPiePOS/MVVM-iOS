//
//  TestFramework.swift
//  MyFramework
//
//  Created by KYUBO A. SHIM on 2023/08/09.
//

import Foundation

public class FrameworkTestClass {
    public private(set) var embedValue: Int = 0
    
    public func setRandomEmbedValue(as value: Int) {
        let randomValueForCalculating = [3,6,7]
        self.embedValue = value * (randomValueForCalculating.randomElement() ?? 1)
    }
}
