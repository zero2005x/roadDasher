//
//  APIEndpoints.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import Foundation

/// API 端點配置
struct APIEndpoints {
    
    // MARK: - Base URL
    /// 基礎 API URL（請替換為實際的後端伺服器地址）
    static let baseURL = "https://api.example.com/api/v1"
    
    // MARK: - Authentication
    /// 登入端點
    static let login = "/auth/login"
    /// 登出端點
    static let logout = "/auth/logout"
    /// Facebook 登入
    static let facebookLogin = "/auth/facebook"
    /// 刷新 Token
    static let refreshToken = "/auth/refresh"
    
    // MARK: - Driver
    /// 外送員資訊
    static let driverProfile = "/driver/profile"
    /// 更新外送員位置
    static let updateLocation = "/driver/location"
    /// 外送員狀態（上線/離線）
    static let driverStatus = "/driver/status"
    
    // MARK: - Orders
    /// 取得可接訂單列表
    static let availableOrders = "/orders/available"
    /// 取得當前進行中的訂單
    static let currentOrder = "/orders/current"
    /// 接受訂單
    static let acceptOrder = "/orders/accept"
    /// 拒絕訂單
    static let rejectOrder = "/orders/reject"
    /// 更新訂單狀態
    static let updateOrderStatus = "/orders/status"
    /// 完成訂單
    static let completeOrder = "/orders/complete"
    /// 歷史訂單
    static let orderHistory = "/orders/history"
    
    // MARK: - Earnings
    /// 今日收入
    static let todayEarnings = "/earnings/today"
    /// 週收入
    static let weeklyEarnings = "/earnings/weekly"
    /// 月收入
    static let monthlyEarnings = "/earnings/monthly"
    /// 收入明細
    static let earningsHistory = "/earnings/history"
    /// 提款
    static let withdraw = "/earnings/withdraw"
    
    // MARK: - Helper Methods
    /// 組合完整 URL
    static func fullURL(for endpoint: String) -> String {
        return baseURL + endpoint
    }
    
    /// 帶有訂單 ID 的端點
    static func orderDetail(orderId: Int) -> String {
        return "/orders/\(orderId)"
    }
}
