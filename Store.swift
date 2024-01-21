//
//  Store.swift
//  StoreTemplate
//
//  Created by Nicola Kaleta on 21/01/2024.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

public enum SubscriptionTier: Int, Comparable {
    case none = 0
    case monthly = 1
    case yearly = 2
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class Store: ObservableObject {
    @Published private(set) var lifetime: [Product]
    @Published private(set) var subscriptions: [Product]
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var purchasedLifetime: Bool = false
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    private let productIds: [String: String]
    
    init() {
        productIds = Store.loadProductIdData()
        
        subscriptions = []
        lifetime = []
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    static func loadProductIdData() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "SampleStore", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String : String] else {
            return [:]
        }
        return data
    }
    
    func listenForTransactions() -> Task<Void,Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updateCustomerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    
}
