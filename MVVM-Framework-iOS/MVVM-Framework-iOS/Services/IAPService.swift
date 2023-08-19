//
//  IAPService.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/14.
//

import Foundation
import StoreKit

typealias ConsumableId = String
typealias SubsriptionId = String
typealias ProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void




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

    /// Will be joining Framework, and be using RxSwift afterwards.
final class IAPServie: NSObject {
    
    /// 앱스토어에서 Localized 정보를 가져온다.
    /// - Strong Reference 를 유지해야 한다. 그 이유는 request 가 완료되기 전에 메모리에서 해제되지 않게 하기 위함이다.
    private var request: SKProductsRequest!
    private var products: [SKProduct] = []
    private var productsRequestCompletionHandler: ProductRequestCompletionHandler?
    // 일단 받아오는 값을 계속 봐보자.
    private var productIds: [String]
    
    init(productIds: [String]) {
        self.productIds = productIds
        super.init()
        // SkPaymentTransactionObserver 를 채택하면 된다.
        SKPaymentQueue.default().add(self)
    }
    
    /// App Store Connect 에서 등록한 인앱 결제 상품들을 가져온다.
    func requestProducts(handler completionHadler: @escaping ProductRequestCompletionHandler) {
        let idSet = Set(productIds)
        request.cancel()
        request = SKProductsRequest(productIdentifiers: idSet)
        // Response 를 SKProductsRequestDelegate 를 사용하기 위함이다
        request.delegate = self
        request.start()
    }
    
    /// 인앱 상품을 구입한다.
    func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        // SKPaymentQueue: A queue of payment transactions to be processed by the App Store.
        SKPaymentQueue.default().add(payment)
    }
    
    /// 가장 최신의 구입 내역을 복원한다.
    func restorePreviousPurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    /// 해당 유저의 모든 구입 내역을 복원한다.
    func restoreAllPurchases(of user: String?) {
        SKPaymentQueue.default().restoreCompletedTransactions(withApplicationUsername: user)
    }
}

    /**
     `SKProductsRequestDelegate` 주의할 점:
     - [Warning]
     - Responses received by the SKProductsRequestDelegate may not be returned on a specific thread. If you make assumptions about which queue will handle delegate responses, you may encounter unintended performance and compatibility issues in the future.
     */
extension IAPServie: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            let products = response.products
            // 왜? 이걸 여기에 담고, 바로 clear 를 하면 무슨 의미가 없지?
            productsRequestCompletionHandler?(true, products)
            clearRequestAndHandler()
        }
        
        for invalidId in response.invalidProductIdentifiers {
            /*
             🚩 InvalidProductIdentifiers 핸들링 방법 -
             
             - invalidProductIdentifiers란? App Store Connect에서 상품 구성을 잘못한 경우 발생
             - Prod 빌드에서는 유효하지 않은 invalidID는 숨길 것
             - dev 빌드에서는 유효하지 않은 invalidID를 UI에 표출할 것 or 서버에 보낼 것
             */
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        request = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPServie: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        print(transactions)
//        for transaction in transactions {
//            let state = transaction.transactionState
//            switch state {
//            case .purchasing:
//
//            case .purchased:
//
//            case .failed:
//
//            case .restored:
//
//            case .deferred:
//
//            @unknown default:
//                print("New State has been added.")
//            }
//        }
    }
    
    private func completedPurchase(transaction: SKPaymentTransaction) {
        
    }
    
    private func failedPurchase(transaction: SKPaymentTransaction) {
        
    }
    
    private func restoredPurchases(transaction: SKPaymentTransaction) {
        
    }
    
    private func passPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
//        let dictionaryForProductInformation: ProductInfo
    }
}

extension IAPServie {
    
}

extension IAPServie {
    
}

extension IAPServie {
    
}

extension IAPServie {
    
}

extension IAPServie {
    
}
