//
//  Earnings.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import Foundation
import SwiftyJSON

/// 收入統計模型
class Earnings {
    var totalAmount: Float
    var deliveryFee: Float
    var tips: Float
    var bonus: Float
    var orderCount: Int
    var periodType: EarningsPeriod
    var startDate: Date?
    var endDate: Date?
    
    init(json: JSON) {
        self.totalAmount = json["total_amount"].floatValue
        self.deliveryFee = json["delivery_fee"].floatValue
        self.tips = json["tips"].floatValue
        self.bonus = json["bonus"].floatValue
        self.orderCount = json["order_count"].intValue
        self.periodType = EarningsPeriod(rawValue: json["period"].stringValue) ?? .today
        
        let dateFormatter = ISO8601DateFormatter()
        if let startStr = json["start_date"].string {
            self.startDate = dateFormatter.date(from: startStr)
        }
        if let endStr = json["end_date"].string {
            self.endDate = dateFormatter.date(from: endStr)
        }
    }
    
    /// 初始化空收入
    init() {
        self.totalAmount = 0
        self.deliveryFee = 0
        self.tips = 0
        self.bonus = 0
        self.orderCount = 0
        self.periodType = .today
    }
    
    /// 格式化金額顯示
    var formattedTotal: String {
        return String(format: "NT$ %.0f", totalAmount)
    }
    
    var formattedDeliveryFee: String {
        return String(format: "NT$ %.0f", deliveryFee)
    }
    
    var formattedTips: String {
        return String(format: "NT$ %.0f", tips)
    }
    
    var formattedBonus: String {
        return String(format: "NT$ %.0f", bonus)
    }
}

/// 收入週期類型
enum EarningsPeriod: String {
    case today = "today"
    case weekly = "weekly"
    case monthly = "monthly"
    case all = "all"
    
    var displayText: String {
        switch self {
        case .today:
            return "今日"
        case .weekly:
            return "本週"
        case .monthly:
            return "本月"
        case .all:
            return "全部"
        }
    }
}

/// 單筆收入紀錄
class EarningRecord {
    var id: Int
    var orderId: Int
    var amount: Float
    var type: EarningType
    var description: String?
    var createdAt: Date?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.orderId = json["order_id"].intValue
        self.amount = json["amount"].floatValue
        self.type = EarningType(rawValue: json["type"].stringValue) ?? .delivery
        self.description = json["description"].string
        
        let dateFormatter = ISO8601DateFormatter()
        if let dateStr = json["created_at"].string {
            self.createdAt = dateFormatter.date(from: dateStr)
        }
    }
    
    /// 格式化金額
    var formattedAmount: String {
        return String(format: "NT$ %.0f", amount)
    }
    
    /// 格式化日期
    var formattedDate: String {
        guard let date = createdAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

/// 收入類型
enum EarningType: String {
    case delivery = "delivery"      // 配送費
    case tip = "tip"                // 小費
    case bonus = "bonus"            // 獎金
    case adjustment = "adjustment"  // 調整
    
    var displayText: String {
        switch self {
        case .delivery:
            return "配送費"
        case .tip:
            return "小費"
        case .bonus:
            return "獎金"
        case .adjustment:
            return "調整"
        }
    }
    
    var iconName: String {
        switch self {
        case .delivery:
            return "bicycle"
        case .tip:
            return "heart.fill"
        case .bonus:
            return "star.fill"
        case .adjustment:
            return "arrow.up.arrow.down"
        }
    }
}
