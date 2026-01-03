//
//  DeliveryStatus.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import Foundation

/// 外送狀態枚舉
enum DeliveryStatus: String, CaseIterable {
    case pending = "pending"           // 待接單
    case accepted = "accepted"         // 已接單
    case pickingUp = "picking_up"      // 前往餐廳取餐中
    case pickedUp = "picked_up"        // 已取餐
    case delivering = "delivering"     // 配送中
    case arrived = "arrived"           // 已到達
    case delivered = "delivered"       // 已送達
    case cancelled = "cancelled"       // 已取消
    
    /// 狀態顯示文字（中文）
    var displayText: String {
        switch self {
        case .pending:
            return "待接單"
        case .accepted:
            return "已接單"
        case .pickingUp:
            return "前往餐廳"
        case .pickedUp:
            return "已取餐"
        case .delivering:
            return "配送中"
        case .arrived:
            return "已到達"
        case .delivered:
            return "已送達"
        case .cancelled:
            return "已取消"
        }
    }
    
    /// 狀態圖示名稱
    var iconName: String {
        switch self {
        case .pending:
            return "clock"
        case .accepted:
            return "checkmark.circle"
        case .pickingUp:
            return "arrow.right.circle"
        case .pickedUp:
            return "bag.fill"
        case .delivering:
            return "bicycle"
        case .arrived:
            return "mappin.and.ellipse"
        case .delivered:
            return "checkmark.seal.fill"
        case .cancelled:
            return "xmark.circle"
        }
    }
    
    /// 下一個狀態（流程控制用）
    var nextStatus: DeliveryStatus? {
        switch self {
        case .pending:
            return .accepted
        case .accepted:
            return .pickingUp
        case .pickingUp:
            return .pickedUp
        case .pickedUp:
            return .delivering
        case .delivering:
            return .arrived
        case .arrived:
            return .delivered
        case .delivered:
            return nil
        case .cancelled:
            return nil
        }
    }
    
    /// 下一步按鈕文字
    var nextActionText: String? {
        switch self {
        case .pending:
            return "接受訂單"
        case .accepted:
            return "前往餐廳"
        case .pickingUp:
            return "確認取餐"
        case .pickedUp:
            return "開始配送"
        case .delivering:
            return "已到達"
        case .arrived:
            return "完成配送"
        case .delivered:
            return nil
        case .cancelled:
            return nil
        }
    }
    
    /// 是否為進行中狀態
    var isInProgress: Bool {
        switch self {
        case .accepted, .pickingUp, .pickedUp, .delivering, .arrived:
            return true
        default:
            return false
        }
    }
    
    /// 是否為最終狀態
    var isFinal: Bool {
        return self == .delivered || self == .cancelled
    }
}

/// 外送員上線狀態
enum DriverOnlineStatus: String {
    case online = "online"
    case offline = "offline"
    case busy = "busy"  // 正在配送中
    
    var displayText: String {
        switch self {
        case .online:
            return "上線中"
        case .offline:
            return "離線"
        case .busy:
            return "配送中"
        }
    }
}
