//
//  APIService.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import Foundation
import Alamofire
import SwiftyJSON

/// API 服務單例
class APIService {
    
    // MARK: - Singleton
    static let shared = APIService()
    private init() {}
    
    // MARK: - Properties
    private var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }
    
    // MARK: - Headers
    private var authHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let token = accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    // MARK: - Token Management
    func setAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    func clearToken() {
        self.accessToken = nil
    }
    
    // MARK: - Authentication
    
    /// Facebook 登入
    func loginWithFacebook(accessToken: String, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.facebookLogin)
        let params: Parameters = ["access_token": accessToken]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 登出
    func logout(completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.logout)
        
        AF.request(url, method: .post, headers: authHeaders)
            .validate()
            .responseData { response in
                self.clearToken()
                self.handleResponse(response, completion: completion)
            }
    }
    
    // MARK: - Driver
    
    /// 更新外送員位置
    func updateLocation(latitude: Double, longitude: Double, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.updateLocation)
        let params: Parameters = [
            "latitude": latitude,
            "longitude": longitude
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 更新外送員上線狀態
    func updateDriverStatus(isOnline: Bool, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.driverStatus)
        let params: Parameters = ["is_online": isOnline]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    // MARK: - Orders
    
    /// 取得可接訂單列表
    func getAvailableOrders(completion: @escaping (Result<[DriverOrder], Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.availableOrders)
        
        AF.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let orders = json["orders"].arrayValue.map { DriverOrder(json: $0) }
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 取得當前訂單
    func getCurrentOrder(completion: @escaping (Result<DriverOrder?, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.currentOrder)
        
        AF.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if json["order"].exists() {
                        let order = DriverOrder(json: json["order"])
                        completion(.success(order))
                    } else {
                        completion(.success(nil))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 接受訂單
    func acceptOrder(orderId: Int, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.acceptOrder)
        let params: Parameters = ["order_id": orderId]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 拒絕訂單
    func rejectOrder(orderId: Int, reason: String?, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.rejectOrder)
        var params: Parameters = ["order_id": orderId]
        if let reason = reason {
            params["reason"] = reason
        }
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 更新訂單狀態
    func updateOrderStatus(orderId: Int, status: DeliveryStatus, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.updateOrderStatus)
        let params: Parameters = [
            "order_id": orderId,
            "status": status.rawValue
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 完成訂單
    func completeOrder(orderId: Int, completion: @escaping (Result<JSON, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.completeOrder)
        let params: Parameters = ["order_id": orderId]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseData { response in
                self.handleResponse(response, completion: completion)
            }
    }
    
    /// 取得歷史訂單
    func getOrderHistory(page: Int = 1, limit: Int = 20, completion: @escaping (Result<[DriverOrder], Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.orderHistory)
        let params: Parameters = [
            "page": page,
            "limit": limit
        ]
        
        AF.request(url, method: .get, parameters: params, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let orders = json["orders"].arrayValue.map { DriverOrder(json: $0) }
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Earnings
    
    /// 取得今日收入
    func getTodayEarnings(completion: @escaping (Result<Earnings, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.todayEarnings)
        
        AF.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let earnings = Earnings(json: json)
                    completion(.success(earnings))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 取得週收入
    func getWeeklyEarnings(completion: @escaping (Result<Earnings, Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.weeklyEarnings)
        
        AF.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let earnings = Earnings(json: json)
                    completion(.success(earnings))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 取得收入歷史
    func getEarningsHistory(page: Int = 1, completion: @escaping (Result<[EarningRecord], Error>) -> Void) {
        let url = APIEndpoints.fullURL(for: APIEndpoints.earningsHistory)
        let params: Parameters = ["page": page]
        
        AF.request(url, method: .get, parameters: params, headers: authHeaders)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let records = json["records"].arrayValue.map { EarningRecord(json: $0) }
                    completion(.success(records))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Private Helpers
    
    private func handleResponse(_ response: AFDataResponse<Data>, completion: @escaping (Result<JSON, Error>) -> Void) {
        switch response.result {
        case .success(let data):
            let json = JSON(data)
            completion(.success(json))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
