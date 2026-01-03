//
//  UIColor+Theme.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import UIKit

extension UIColor {
    
    // MARK: - Brand Colors
    
    /// 主題色 - 橘紅色（類似外送平台風格）
    static let rdPrimary = UIColor(red: 255/255, green: 90/255, blue: 50/255, alpha: 1.0)
    
    /// 次要主題色
    static let rdSecondary = UIColor(red: 255/255, green: 120/255, blue: 80/255, alpha: 1.0)
    
    /// 強調色 - 綠色（用於成功狀態）
    static let rdSuccess = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
    
    /// 警告色 - 黃色
    static let rdWarning = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
    
    /// 錯誤色 - 紅色
    static let rdError = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
    
    // MARK: - Status Colors
    
    /// 上線狀態綠色
    static let rdOnline = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
    
    /// 離線狀態灰色
    static let rdOffline = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
    
    /// 忙碌狀態橘色
    static let rdBusy = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
    
    // MARK: - Background Colors
    
    /// 淺灰背景
    static let rdLightBackground = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
    
    /// 卡片背景
    static let rdCardBackground = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
            : UIColor.white
    }
    
    // MARK: - Text Colors
    
    /// 主要文字顏色
    static let rdTextPrimary = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    
    /// 次要文字顏色
    static let rdTextSecondary = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
    
    // MARK: - Delivery Status Colors
    
    /// 根據配送狀態返回對應顏色
    static func color(for status: DeliveryStatus) -> UIColor {
        switch status {
        case .pending:
            return .rdWarning
        case .accepted:
            return .rdPrimary
        case .pickingUp:
            return .rdSecondary
        case .pickedUp:
            return .rdSuccess
        case .delivering:
            return .rdPrimary
        case .arrived:
            return .rdSuccess
        case .delivered:
            return .rdSuccess
        case .cancelled:
            return .rdError
        }
    }
}

// MARK: - UIColor Hex Support

extension UIColor {
    
    /// 從十六進位字串建立顏色
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
