//
//  TestFramework.swift
//  MyFramework
//
//  Created by KYUBO A. SHIM on 2023/08/09.
//

import Foundation

import RxSwift
import RxRelay

public class FrameworkTestClass {
    public private(set) var embedValue: Int = 0
    public var disposeBag = DisposeBag()
    public var testObservable: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public init() {}
    
    public func setRandomEmbedValue(as value: Int) {
        let randomValueForCalculating = [3,6,7]
        self.embedValue = value * (randomValueForCalculating.randomElement() ?? 1)
    }
}
