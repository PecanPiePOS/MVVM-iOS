//
//  IAPService.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/14.
//

import Foundation
import StoreKit

    /**
     Sets Ids and Store Information of In-App products.
     - Contains Ids
     */
struct IAPProducts {
    typealias ConsumableId = String
    typealias SubsriptionId = String
    
    /// #1 Consumable IAP product Identifier
    static let consumableProduct1: ConsumableId = "com.pecanpie.test.MALI"
    
    /// #1 Subscription IAP product Identifier
    static let subscriptionProduct1: SubsriptionId = "com.pecanpie.test.MALI.substription"
    
    private static let consumableProductIdentifiers: Set<ConsumableId> = [IAPProducts.consumableProduct1]
    private static let subscriptionProductIdentifiers: Set<SubsriptionId> = [IAPProducts.subscriptionProduct1]
    
//    static let comsumableStore = IAP
}

