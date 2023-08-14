//
//  IAPService.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/14.
//

import Foundation
import StoreKit

public typealias ConsumableId = String
public typealias SubsriptionId = String

    /**
     Sets Ids and Store Information of In-App products.
     */
struct IAPProducts {
    
    /// #1 Consumable IAP product Identifier
    static let consumableProduct1: ConsumableId = "com.pecanpie.test.MALI"
    
    /// #1 Subscription IAP product Identifier
    static let subscriptionProduct1: SubsriptionId = "com.pecanpie.test.MALI.substription"
    
    private static let consumableProductIdentifiers: Set<ConsumableId> = [IAPProducts.consumableProduct1]
    private static let subscriptionProductIdentifiers: Set<SubsriptionId> = [IAPProducts.subscriptionProduct1]
    
//    static let comsumableStore = IAP
}

final class IAPServie: NSObject {
    /// 앱스토어에서 Localized 정보를 가져온다.
    /// - Strong Reference 를 유지해야 한다. 그 이유는 request 가 완료되기 전에 메모리에서 해제되지 않게 하기 위함이다.
    private var request: SKProductsRequest!
    
    private var products: [SKProduct] = []
    
    /// 지금 이 Ids 에서 Subscription 과 Consumable 이 나눠져 내려오는지 궁금하다.
    func request(ids: [String]) {
        let ids: Set<String> = Set(ids)
        request = SKProductsRequest(productIdentifiers: ids)
        
        // Response 를 SKProductsRequestDelegate 를 사용하기 위함이다
        request.delegate = self
        request.start()
    }
}

extension IAPServie: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            self.products = response.products
        }
        
        for invalidId in response.invalidProductIdentifiers {
            /**
             🚩 InvalidProductIdentifiers 핸들링 방법 -
             
             - invalidProductIdentifiers란? App Store Connect에서 상품 구성을 잘못한 경우 발생
             - Prod 빌드에서는 유효하지 않은 invalidID는 숨길 것
             - dev 빌드에서는 유효하지 않은 invalidID를 UI에 표출할 것 or 서버에 보낼 것
             */
        }
    }
}
