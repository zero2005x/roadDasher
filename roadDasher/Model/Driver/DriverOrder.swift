//
//  DriverOrder.swift
//  roadDasher
//
//  Created by Alvaro Gonzalez on 11/4/21.
//  Updated by GitHub Copilot on 2026/1/3.
//

import Foundation
import SwiftyJSON
import CoreLocation

class DriverOrder {
    
    // MARK: - Properties
    var id: Int?
    var orderNumber: String?
    
    // Customer Info
    var customerName: String?
    var customerAddress: String?
    var customerAvatar: String?
    var customerPhone: String?
    var customerLatitude: Double?
    var customerLongitude: Double?
    
    // Restaurant Info
    var restaurantId: Int?
    var restaurantName: String?
    var restaurantAddress: String?
    var restaurantPhone: String?
    var restaurantLatitude: Double?
    var restaurantLongitude: Double?
    
    // Order Details
    var items: [OrderItem]?
    var subtotal: Float?
    var deliveryFee: Float?
    var tip: Float?
    var total: Float?
    var note: String?
    
    // Status
    var status: DeliveryStatus = .pending
    var createdAt: Date?
    var estimatedDeliveryTime: Date?
    var distance: Double?  // 公里
    
    // MARK: - Initializers
    
    init(json: JSON) {
        self.id = json["id"].int
        self.orderNumber = json["order_number"].string
        
        // Customer
        self.customerName = json["customer"]["name"].string
        self.customerAddress = json["address"].string ?? json["customer"]["address"].string
        self.customerAvatar = json["customer"]["avatar"].string
        self.customerPhone = json["customer"]["phone"].string
        self.customerLatitude = json["customer"]["latitude"].double
        self.customerLongitude = json["customer"]["longitude"].double
        
        // Restaurant
        self.restaurantId = json["restaurant"]["id"].int
        self.restaurantName = json["restaurant"]["name"].string
        self.restaurantAddress = json["restaurant"]["address"].string
        self.restaurantPhone = json["restaurant"]["phone"].string
        self.restaurantLatitude = json["restaurant"]["latitude"].double
        self.restaurantLongitude = json["restaurant"]["longitude"].double
        
        // Order Details
        self.items = json["items"].arrayValue.map { OrderItem(json: $0) }
        self.subtotal = json["subtotal"].float
        self.deliveryFee = json["delivery_fee"].float
        self.tip = json["tip"].float
        self.total = json["total"].float
        self.note = json["note"].string
        
        // Status
        if let statusStr = json["status"].string {
            self.status = DeliveryStatus(rawValue: statusStr) ?? .pending
        }
        
        // Dates
        let dateFormatter = ISO8601DateFormatter()
        if let createdStr = json["created_at"].string {
            self.createdAt = dateFormatter.date(from: createdStr)
        }
        if let estimatedStr = json["estimated_delivery_time"].string {
            self.estimatedDeliveryTime = dateFormatter.date(from: estimatedStr)
        }
        
        self.distance = json["distance"].double
    }
    
    /// 初始化空訂單（用於測試）
    init() {}
    
    // MARK: - Computed Properties
    
    /// 餐廳位置座標
    var restaurantLocation: CLLocationCoordinate2D? {
        guard let lat = restaurantLatitude, let lon = restaurantLongitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    /// 客戶位置座標
    var customerLocation: CLLocationCoordinate2D? {
        guard let lat = customerLatitude, let lon = customerLongitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    /// 格式化總金額
    var formattedTotal: String {
        guard let total = total else { return "NT$ 0" }
        return String(format: "NT$ %.0f", total)
    }
    
    /// 格式化配送費
    var formattedDeliveryFee: String {
        guard let fee = deliveryFee else { return "NT$ 0" }
        return String(format: "NT$ %.0f", fee)
    }
    
    /// 格式化小費
    var formattedTip: String {
        guard let tip = tip else { return "NT$ 0" }
        return String(format: "NT$ %.0f", tip)
    }
    
    /// 格式化距離
    var formattedDistance: String {
        guard let distance = distance else { return "" }
        if distance < 1 {
            return String(format: "%.0f 公尺", distance * 1000)
        }
        return String(format: "%.1f 公里", distance)
    }
    
    /// 餐點數量
    var itemCount: Int {
        return items?.reduce(0) { $0 + ($1.quantity ?? 1) } ?? 0
    }
    
    /// 訂單摘要（餐點列表）
    var itemsSummary: String {
        guard let items = items, !items.isEmpty else { return "無餐點資訊" }
        return items.map { "\($0.name ?? "餐點") x\($0.quantity ?? 1)" }.joined(separator: ", ")
    }
}

// MARK: - Order Item Model

class OrderItem {
    var id: Int?
    var name: String?
    var quantity: Int?
    var price: Float?
    var note: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.quantity = json["quantity"].int ?? 1
        self.price = json["price"].float
        self.note = json["note"].string
    }
    
    var formattedPrice: String {
        guard let price = price else { return "" }
        return String(format: "NT$ %.0f", price)
    }
}
