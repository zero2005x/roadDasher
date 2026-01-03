# English

## 📖 Project Overview

RoadDasher is an iOS application designed specifically for delivery drivers, serving as a demo project for iOS development courses. This app provides a complete delivery workflow including order acceptance, navigation, status updates, and earnings management.

## ✨ Features

### 🔐 Authentication

- Facebook OAuth social login
- Automatic token management and refresh
- User profile synchronization

### 🗺 Map & Location

- Real-time GPS tracking
- Background location support
- Online/Offline status toggle
- Order location markers
- Apple Maps / Google Maps navigation integration

### 📋 Order Management

- Available orders list display
- Order detail viewing
- Accept/Reject order functionality
- Pull-to-refresh orders

### 🚴 Delivery Status

- Order status flow management
  - Pending → Accepted → Heading to Restaurant → Picked Up → Delivering → Arrived → Delivered
- One-tap call to merchant/customer
- One-tap navigation

### 💰 Wallet & Earnings

- Today/Weekly/Monthly earnings statistics
- Earnings detail list (delivery fee, tips, bonus)
- Withdrawal function (simulated)

### 📜 Order History

- Completed orders list
- Search and filter functionality
- Pagination loading

## 📁 Project Structure

```
roadDasher/
├── AppDelegate.swift              # App lifecycle
├── SceneDelegate.swift            # Scene management
├── Info.plist                     # App configuration
│
├── Controller/                    # View Controllers
│   ├── LoginViewController.swift      # Login screen
│   ├── MapViewController.swift         # Map main screen
│   ├── OrderTableViewController.swift  # Order list
│   ├── StateTableViewController.swift  # Delivery status
│   ├── WalletTableViewController.swift # Wallet & earnings
│   ├── PastRecordTableViewController.swift # Order history
│   └── ViewController.swift            # Base controller
│
├── Model/                         # Data Models
│   ├── Driver/
│   │   ├── DriverOrder.swift          # Order model
│   │   ├── DeliveryStatus.swift       # Delivery status enum
│   │   └── Earnings.swift             # Earnings model
│   └── Customer/
│       ├── Cart.swift                 # Shopping cart
│       ├── Meal.swift                 # Meal
│       ├── Restaurant.swift           # Restaurant
│       └── User.swift                 # User
│
├── View/                          # View Components
│   ├── Base.lproj/
│   │   └── Main.storyboard            # Main Storyboard
│   └── CustomCells/
│       ├── OrderCell.swift            # Order list cell
│       ├── EarningsCell.swift         # Earnings record cell
│       └── HistoryCell.swift          # History order cell
│
├── Service/                       # Service Layer
│   ├── APIService.swift               # API request wrapper
│   └── APIEndpoints.swift             # API endpoint constants
│
├── Extensions/                    # Extensions
│   ├── UIViewController+Alert.swift   # Alert & Loading extension
│   └── UIColor+Theme.swift            # Theme color extension
│
└── Assets.xcassets/               # Asset files
```

## 🛠 Tech Stack

| Technology        | Purpose                      |
| ----------------- | ---------------------------- |
| **Swift 5**       | Primary development language |
| **UIKit**         | UI framework                 |
| **MapKit**        | Map display                  |
| **CoreLocation**  | GPS location                 |
| **Alamofire**     | Network requests             |
| **SwiftyJSON**    | JSON parsing                 |
| **FBSDKLoginKit** | Facebook login               |

## 📦 Installation

### Requirements

- macOS 12.0+
- Xcode 14.0+
- iOS 15.0+ (deployment target)
- CocoaPods or Swift Package Manager

### Setup Steps

1. **Clone the repository**

```bash
git clone https://github.com/your-username/roadDasher.git
cd roadDasher
```

2. **Install dependencies**

Using Swift Package Manager (recommended):

- Open Xcode
- File → Add Packages
- Add the following packages:
  - `https://github.com/Alamofire/Alamofire.git`
  - `https://github.com/SwiftyJSON/SwiftyJSON.git`
  - `https://github.com/facebook/facebook-ios-sdk.git`

Or using CocoaPods:

```bash
pod init
# Edit Podfile to add:
# pod 'Alamofire'
# pod 'SwiftyJSON'
# pod 'FBSDKLoginKit'
pod install
```

3. **Configure Facebook App**

- Set your Facebook App ID in `Info.plist`
- Configure `FacebookClientToken`

4. **Run the project**

```bash
open roadDasher.xcodeproj
# Or if using CocoaPods
open roadDasher.xcworkspace
```

## 🎨 Theme Colors

| Color             | Usage                    | Hex       |
| ----------------- | ------------------------ | --------- |
| 🔴 Primary        | Theme color (Orange-Red) | `#FF5A32` |
| 🟢 Success        | Success/Online           | `#34C759` |
| 🟡 Warning        | Warning                  | `#FFCC00` |
| 🔴 Error          | Error                    | `#FF3B30` |
| ⚫ Text Primary   | Primary text             | `#000000` |
| ⚪ Text Secondary | Secondary text           | `#8E8E93` |

## 📱 Screenshots

|      Map Home      |    Order List    |  Delivery Status   |     Wallet     |
| :----------------: | :--------------: | :----------------: | :------------: |
| Real-time location | Available orders |   Status updates   | Earnings stats |
|   Online toggle    |  Accept/Reject   | One-tap navigation |   Withdrawal   |

## 🔧 API Endpoints

| Endpoint            | Method | Description          |
| ------------------- | ------ | -------------------- |
| `/auth/facebook`    | POST   | Facebook login       |
| `/driver/location`  | POST   | Update location      |
| `/driver/status`    | POST   | Update online status |
| `/orders/available` | GET    | Get available orders |
| `/orders/accept`    | POST   | Accept order         |
| `/orders/status`    | POST   | Update order status  |
| `/earnings/today`   | GET    | Today's earnings     |
| `/earnings/history` | GET    | Earnings history     |

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

# 🚴 RoadDasher - 外送員專屬 APP

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS-blue.svg" alt="Platform iOS">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift 5.0+">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License MIT">
</p>

> 🇹🇼 **[繁體中文](#繁體中文)** | 🇺🇸 **[English](#english)**

---

# 繁體中文

## 📖 專案簡介

RoadDasher 是一款專為外送員設計的 iOS 應用程式，用於 iOS 開發課程的 Demo 展示專案。此應用程式提供完整的外送員工作流程，包括接單、導航、狀態更新、收入管理等核心功能。

## ✨ 功能特點

### 🔐 登入模組

- Facebook OAuth 社群登入
- Token 自動管理與刷新
- 使用者資訊同步

### 🗺 地圖與定位

- 即時 GPS 定位追蹤
- 背景定位支援
- 上線/離線狀態切換
- 訂單位置標記顯示
- 整合 Apple Maps / Google Maps 導航

### 📋 訂單管理

- 可接訂單列表展示
- 訂單詳情查看
- 接受/拒絕訂單功能
- 下拉刷新訂單

### 🚴 配送狀態

- 訂單狀態流程管理
  - 待接單 → 已接單 → 前往餐廳 → 已取餐 → 配送中 → 已到達 → 已送達
- 一鍵撥號聯繫商家/客戶
- 一鍵開啟導航

### 💰 錢包與收入

- 今日/本週/本月收入統計
- 收入明細列表（配送費、小費、獎金）
- 提款功能（模擬）

### 📜 歷史紀錄

- 已完成訂單列表
- 搜尋與篩選功能
- 分頁載入更多

## 📁 專案結構

```
roadDasher/
├── AppDelegate.swift              # App 生命週期
├── SceneDelegate.swift            # Scene 管理
├── Info.plist                     # App 配置
│
├── Controller/                    # 視圖控制器
│   ├── LoginViewController.swift      # 登入頁面
│   ├── MapViewController.swift         # 地圖主頁
│   ├── OrderTableViewController.swift  # 訂單列表
│   ├── StateTableViewController.swift  # 配送狀態
│   ├── WalletTableViewController.swift # 錢包收入
│   ├── PastRecordTableViewController.swift # 歷史紀錄
│   └── ViewController.swift            # 基礎控制器
│
├── Model/                         # 資料模型
│   ├── Driver/
│   │   ├── DriverOrder.swift          # 訂單模型
│   │   ├── DeliveryStatus.swift       # 配送狀態枚舉
│   │   └── Earnings.swift             # 收入模型
│   └── Customer/
│       ├── Cart.swift                 # 購物車
│       ├── Meal.swift                 # 餐點
│       ├── Restaurant.swift           # 餐廳
│       └── User.swift                 # 使用者
│
├── View/                          # 視圖元件
│   ├── Base.lproj/
│   │   └── Main.storyboard            # 主要 Storyboard
│   └── CustomCells/
│       ├── OrderCell.swift            # 訂單列表 Cell
│       ├── EarningsCell.swift         # 收入記錄 Cell
│       └── HistoryCell.swift          # 歷史訂單 Cell
│
├── Service/                       # 服務層
│   ├── APIService.swift               # API 請求封裝
│   └── APIEndpoints.swift             # API 端點常數
│
├── Extensions/                    # 擴展
│   ├── UIViewController+Alert.swift   # Alert 與 Loading 擴展
│   └── UIColor+Theme.swift            # 主題色彩擴展
│
└── Assets.xcassets/               # 資源檔案
```

## 🛠 技術棧

| 技術              | 用途          |
| ----------------- | ------------- |
| **Swift 5**       | 主要開發語言  |
| **UIKit**         | UI 框架       |
| **MapKit**        | 地圖顯示      |
| **CoreLocation**  | GPS 定位      |
| **Alamofire**     | 網路請求      |
| **SwiftyJSON**    | JSON 解析     |
| **FBSDKLoginKit** | Facebook 登入 |

## 📦 安裝與執行

### 環境需求

- macOS 12.0+
- Xcode 14.0+
- iOS 15.0+ (部署目標)
- CocoaPods 或 Swift Package Manager

### 安裝步驟

1. **複製專案**

```bash
git clone https://github.com/your-username/roadDasher.git
cd roadDasher
```

2. **安裝依賴套件**

使用 Swift Package Manager (推薦):

- 開啟 Xcode
- File → Add Packages
- 加入以下套件：
  - `https://github.com/Alamofire/Alamofire.git`
  - `https://github.com/SwiftyJSON/SwiftyJSON.git`
  - `https://github.com/facebook/facebook-ios-sdk.git`

或使用 CocoaPods:

```bash
pod init
# 編輯 Podfile 加入：
# pod 'Alamofire'
# pod 'SwiftyJSON'
# pod 'FBSDKLoginKit'
pod install
```

3. **設定 Facebook App**

- 在 `Info.plist` 中設定您的 Facebook App ID
- 設定 `FacebookClientToken`

4. **執行專案**

```bash
open roadDasher.xcodeproj
# 或如果使用 CocoaPods
open roadDasher.xcworkspace
```

## 🎨 主題色彩

| 顏色              | 用途           | Hex       |
| ----------------- | -------------- | --------- |
| 🔴 Primary        | 主題色（橘紅） | `#FF5A32` |
| 🟢 Success        | 成功/上線      | `#34C759` |
| 🟡 Warning        | 警告           | `#FFCC00` |
| 🔴 Error          | 錯誤           | `#FF3B30` |
| ⚫ Text Primary   | 主要文字       | `#000000` |
| ⚪ Text Secondary | 次要文字       | `#8E8E93` |

## 📱 畫面預覽

| 地圖主頁 | 訂單列表  | 配送狀態 | 錢包收入 |
| :------: | :-------: | :------: | :------: |
| 即時定位 | 可接訂單  | 狀態更新 | 收入統計 |
| 上線切換 | 接單/拒絕 | 一鍵導航 | 提款功能 |

## 🔧 API 端點

| 端點                | 方法 | 說明          |
| ------------------- | ---- | ------------- |
| `/auth/facebook`    | POST | Facebook 登入 |
| `/driver/location`  | POST | 更新位置      |
| `/driver/status`    | POST | 更新上線狀態  |
| `/orders/available` | GET  | 取得可接訂單  |
| `/orders/accept`    | POST | 接受訂單      |
| `/orders/status`    | POST | 更新訂單狀態  |
| `/earnings/today`   | GET  | 今日收入      |
| `/earnings/history` | GET  | 收入歷史      |

---

<p align="center">
  Made with ❤️ for iOS Development Course
</p>
