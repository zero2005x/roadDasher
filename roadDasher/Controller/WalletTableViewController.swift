//
//  WalletTableViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/25.
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit

class WalletTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// 今日收入
    private var todayEarnings: Earnings = Earnings()
    
    /// 本週收入
    private var weeklyEarnings: Earnings = Earnings()
    
    /// 收入記錄列表
    private var earningRecords: [EarningRecord] = []
    
    /// 是否正在載入
    private var isLoading = false
    
    /// 刷新控制器
    private let refreshCtrl = UIRefreshControl()
    
    // MARK: - Section Types
    
    private enum Section: Int, CaseIterable {
        case summary = 0
        case statistics = 1
        case history = 2
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        loadEarningsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEarningsData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "我的錢包"
        
        tableView.backgroundColor = .rdLightBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // 註冊 Cell
        tableView.register(EarningsCell.self, forCellReuseIdentifier: EarningsCell.identifier)
        
        // 右上角提款按鈕
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "提款",
            style: .plain,
            target: self,
            action: #selector(withdrawTapped)
        )
    }
    
    private func setupRefreshControl() {
        refreshCtrl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshCtrl
    }
    
    // MARK: - Data Loading
    
    @objc private func refreshData() {
        loadEarningsData()
    }
    
    private func loadEarningsData() {
        guard !isLoading else { return }
        isLoading = true
        
        let group = DispatchGroup()
        
        // 載入今日收入
        group.enter()
        APIService.shared.getTodayEarnings { [weak self] result in
            if case .success(let earnings) = result {
                self?.todayEarnings = earnings
            }
            group.leave()
        }
        
        // 載入週收入
        group.enter()
        APIService.shared.getWeeklyEarnings { [weak self] result in
            if case .success(let earnings) = result {
                self?.weeklyEarnings = earnings
            }
            group.leave()
        }
        
        // 載入收入歷史
        group.enter()
        APIService.shared.getEarningsHistory { [weak self] result in
            if case .success(let records) = result {
                self?.earningRecords = records
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            self?.refreshCtrl.endRefreshing()
            
            // 如果沒有資料，載入模擬資料
            if self?.todayEarnings.totalAmount == 0 {
                self?.loadMockData()
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func loadMockData() {
        // 模擬今日收入
        todayEarnings.totalAmount = 580
        todayEarnings.deliveryFee = 480
        todayEarnings.tips = 60
        todayEarnings.bonus = 40
        todayEarnings.orderCount = 8
        todayEarnings.periodType = .today
        
        // 模擬週收入
        weeklyEarnings.totalAmount = 3250
        weeklyEarnings.deliveryFee = 2800
        weeklyEarnings.tips = 280
        weeklyEarnings.bonus = 170
        weeklyEarnings.orderCount = 45
        weeklyEarnings.periodType = .weekly
        
        // 模擬收入記錄
        earningRecords = createMockRecords()
    }
    
    private func createMockRecords() -> [EarningRecord] {
        var records: [EarningRecord] = []
        let now = Date()
        
        for i in 0..<10 {
            let record = MockEarningRecord(
                id: i + 1,
                orderId: 1000 + i,
                amount: Float([55, 60, 65, 70, 75, 80].randomElement()!),
                type: i % 5 == 0 ? .tip : (i % 7 == 0 ? .bonus : .delivery),
                description: nil,
                createdAt: now.addingTimeInterval(TimeInterval(-3600 * i))
            )
            records.append(record)
        }
        
        return records
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .summary:
            return 1
        case .statistics:
            return 4  // 配送費、小費、獎金、訂單數
        case .history:
            return earningRecords.count
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .summary:
            return nil
        case .statistics:
            return "本週統計"
        case .history:
            return "收入明細"
        case .none:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .summary:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .summary:
            return createSummaryCell()
            
        case .statistics:
            return createStatisticsCell(at: indexPath)
            
        case .history:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EarningsCell.identifier, for: indexPath) as? EarningsCell else {
                return UITableViewCell()
            }
            
            if indexPath.row < earningRecords.count {
                cell.configure(with: earningRecords[indexPath.row])
            }
            
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    // MARK: - Custom Cells
    
    private func createSummaryCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .rdPrimary
        
        // 標題
        let titleLabel = UILabel()
        titleLabel.text = "今日收入"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 金額
        let amountLabel = UILabel()
        amountLabel.text = todayEarnings.formattedTotal
        amountLabel.font = .boldSystemFont(ofSize: 42)
        amountLabel.textColor = .white
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 訂單數
        let ordersLabel = UILabel()
        ordersLabel.text = "完成 \(todayEarnings.orderCount) 筆訂單"
        ordersLabel.font = .systemFont(ofSize: 14)
        ordersLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        ordersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 週收入卡片
        let weeklyCard = createWeeklyCard()
        
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(amountLabel)
        cell.contentView.addSubview(ordersLabel)
        cell.contentView.addSubview(weeklyCard)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ordersLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            ordersLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            weeklyCard.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            weeklyCard.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            weeklyCard.widthAnchor.constraint(equalToConstant: 120),
            weeklyCard.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return cell
    }
    
    private func createWeeklyCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        card.layer.cornerRadius = 8
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "本週"
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = weeklyEarnings.formattedTotal
        amountLabel.font = .boldSystemFont(ofSize: 18)
        amountLabel.textColor = .white
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let ordersLabel = UILabel()
        ordersLabel.text = "\(weeklyEarnings.orderCount) 筆"
        ordersLabel.font = .systemFont(ofSize: 11)
        ordersLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        ordersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        card.addSubview(amountLabel)
        card.addSubview(ordersLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            amountLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            ordersLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 2),
            ordersLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
        
        return card
    }
    
    private func createStatisticsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "statsCell")
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "bicycle")
            cell.imageView?.tintColor = .rdPrimary
            cell.textLabel?.text = "配送費"
            cell.detailTextLabel?.text = weeklyEarnings.formattedDeliveryFee
        case 1:
            cell.imageView?.image = UIImage(systemName: "heart.fill")
            cell.imageView?.tintColor = .systemPink
            cell.textLabel?.text = "小費"
            cell.detailTextLabel?.text = weeklyEarnings.formattedTips
        case 2:
            cell.imageView?.image = UIImage(systemName: "star.fill")
            cell.imageView?.tintColor = .systemYellow
            cell.textLabel?.text = "獎金"
            cell.detailTextLabel?.text = weeklyEarnings.formattedBonus
        case 3:
            cell.imageView?.image = UIImage(systemName: "doc.text")
            cell.imageView?.tintColor = .systemBlue
            cell.textLabel?.text = "訂單數"
            cell.detailTextLabel?.text = "\(weeklyEarnings.orderCount) 筆"
        default:
            break
        }
        
        cell.detailTextLabel?.textColor = .rdTextPrimary
        cell.detailTextLabel?.font = .boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    // MARK: - Actions
    
    @objc private func withdrawTapped() {
        let totalBalance = weeklyEarnings.totalAmount
        
        if totalBalance <= 0 {
            showAlert(title: "無法提款", message: "您的餘額為 NT$ 0")
            return
        }
        
        let alert = UIAlertController(
            title: "提款",
            message: "您的可提款餘額為 \(weeklyEarnings.formattedTotal)\n\n提款將在 1-3 個工作天內匯入您的帳戶",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "確認提款", style: .default) { [weak self] _ in
            self?.processWithdraw()
        })
        
        present(alert, animated: true)
    }
    
    private func processWithdraw() {
        showLoading(message: "處理中...")
        
        // 模擬提款處理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.hideLoading()
            self?.showSuccess("提款申請已送出！\n預計 1-3 個工作天內入帳")
        }
    }
}

// MARK: - Mock Earning Record Helper

private class MockEarningRecord: EarningRecord {
    init(id: Int, orderId: Int, amount: Float, type: EarningType, description: String?, createdAt: Date?) {
        let json = SwiftyJSON.JSON([
            "id": id,
            "order_id": orderId,
            "amount": amount,
            "type": type.rawValue,
            "description": description as Any
        ])
        super.init(json: json)
        self.createdAt = createdAt
    }
}

import SwiftyJSON
