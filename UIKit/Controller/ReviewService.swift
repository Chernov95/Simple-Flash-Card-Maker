//
//  ReviewService.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 29/08/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation
import StoreKit

class ReviewService {
    
    private init() {}
    static let shared = ReviewService()
    
    private let defaults = UserDefaults.standard
    
    
    private var lastRequest: Date? {
        get {
            return defaults.value(forKey: "ReviewService.lastRequest") as? Date
        }
        set {
            defaults.set(newValue, forKey: "ReviewService.lastRequest")
        }
    }
    
    private var oneWeekAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -120, to: Date())!
    }
    
    private var shouldRequestReview: Bool {
        if lastRequest == nil {
            return true
        } else if let lastRequest = self.lastRequest, lastRequest < oneWeekAgo {
            return true
        }
        return false
    }
    
    func requestReview() {
        guard shouldRequestReview else { return }
        SKStoreReviewController.requestReview()
        lastRequest = Date()
    }
}
