//
//  OrderTableViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/25.
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// 可接訂單列表
    private var availableOrders: [DriverOrder] = []
    
    /// 是否正在載入
    private var isLoading = false
    
    /// 刷新控制器
    private let refreshCtrl = UIRefreshControl()
    
    /// 空狀態視圖
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView(image: UIImage(named: "EmptyOrderImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rdTextSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "目前沒有可接訂單"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .rdTextPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "新訂單將會自動顯示在這裡\n請保持上線狀態"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .rdTextSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次顯示時刷新訂單
        loadOrders()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "可接訂單"
        
        // 設定 TableView
        tableView.backgroundColor = .rdLightBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        
        // 註冊 Cell
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        
        // 設定空狀態視圖
        tableView.backgroundView = emptyStateView
        emptyStateView.isHidden = true
    }
    
    private func setupRefreshControl() {
        refreshCtrl.attributedTitle = NSAttributedString(string: "下拉刷新訂單")
        refreshCtrl.addTarget(self, action: #selector(refreshOrders), for: .valueChanged)
        tableView.refreshControl = refreshCtrl
    }
    
    // MARK: - Data Loading
    
    @objc private func refreshOrders() {
        loadOrders()
    }
    
    private func loadOrders() {
        guard !isLoading else { return }
        isLoading = true
        
        APIService.shared.getAvailableOrders { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.refreshCtrl.endRefreshing()
                
                switch result {
                case .success(let orders):
                    self?.availableOrders = orders
                    self?.updateEmptyState()
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    self?.showError("載入訂單失敗：\(error.localizedDescription)")
                    // 使用模擬資料（Demo 用）
                    self?.loadMockData()
                }
            }
        }
    }
    
    /// 載入模擬資料（Demo 用）
    private func loadMockData() {
        // 建立模擬訂單
        let mockOrder1 = DriverOrder()
        mockOrder1.id = 1001
        mockOrder1.orderNumber = "#RD1001"
        mockOrder1.restaurantName = "麥當勞 信義店"
        mockOrder1.restaurantAddress = "台北市信義區信義路五段7號"
        mockOrder1.customerName = "王小明"
        mockOrder1.customerAddress = "台北市信義區松仁路100號"
        mockOrder1.deliveryFee = 60
        mockOrder1.distance = 2.5
        mockOrder1.status = .pending
        
        let mockOrder2 = DriverOrder()
        mockOrder2.id = 1002
        mockOrder2.orderNumber = "#RD1002"
        mockOrder2.restaurantName = "星巴克 101店"
        mockOrder2.restaurantAddress = "台北市信義區市府路45號"
        mockOrder2.customerName = "李小華"
        mockOrder2.customerAddress = "台北市信義區基隆路一段333號"
        mockOrder2.deliveryFee = 55
        mockOrder2.distance = 1.8
        mockOrder2.status = .pending
        
        let mockOrder3 = DriverOrder()
        mockOrder3.id = 1003
        mockOrder3.orderNumber = "#RD1003"
        mockOrder3.restaurantName = "鼎泰豐 信義店"
        mockOrder3.restaurantAddress = "台北市信義區松高路12號"
        mockOrder3.customerName = "張大明"
        mockOrder3.customerAddress = "台北市大安區敦化南路二段201號"
        mockOrder3.deliveryFee = 85
        mockOrder3.distance = 4.2
        mockOrder3.status = .pending
        
        availableOrders = [mockOrder1, mockOrder2, mockOrder3]
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !availableOrders.isEmpty
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else {
            return UITableViewCell()
        }
        
        let order = availableOrders[indexPath.row]
        cell.configure(with: order)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = availableOrders[indexPath.row]
        showOrderActions(for: order, at: indexPath)
    }
    
    // MARK: - Actions
    
    private func showOrderActions(for order: DriverOrder, at indexPath: IndexPath) {
        let actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)] = [
            ("接受訂單", .default, { [weak self] in
                self?.acceptOrder(order, at: indexPath)
            }),
            ("查看詳情", .default, { [weak self] in
                self?.showOrderDetail(order)
            }),
            ("拒絕訂單", .destructive, { [weak self] in
                self?.rejectOrder(order, at: indexPath)
            })
        ]
        
        showActionSheet(
            title: order.restaurantName,
            message: "配送費：\(order.formattedDeliveryFee) | 距離：\(order.formattedDistance)",
            actions: actions,
            sourceView: tableView.cellForRow(at: indexPath)
        )
    }
    
    private func acceptOrder(_ order: DriverOrder, at indexPath: IndexPath) {
        showLoading(message: "接受訂單中...")
        
        guard let orderId = order.id else {
            hideLoading()
            showError("訂單資訊錯誤")
            return
        }
        
        APIService.shared.acceptOrder(orderId: orderId) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                
                switch result {
                case .success:
                    self?.showSuccess("已接受訂單！") {
                        // 從列表中移除
                        self?.availableOrders.remove(at: indexPath.row)
                        self?.tableView.deleteRows(at: [indexPath], with: .fade)
                        self?.updateEmptyState()
                        
                        // 跳轉到狀態頁面
                        if let tabBarController = self?.tabBarController {
                            tabBarController.selectedIndex = 1  // 假設狀態頁是第二個 tab
                        }
                    }
                    
                case .failure(let error):
                    self?.showError("接受訂單失敗：\(error.localizedDescription)")
                }
            }
        }
    }
    
    private func rejectOrder(_ order: DriverOrder, at indexPath: IndexPath) {
        showConfirmation(
            title: "確定拒絕訂單？",
            message: "拒絕後此訂單將從列表中移除",
            confirmTitle: "拒絕",
            confirmStyle: .destructive,
            onConfirm: { [weak self] in
                guard let orderId = order.id else { return }
                
                APIService.shared.rejectOrder(orderId: orderId, reason: nil) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self?.availableOrders.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .fade)
                            self?.updateEmptyState()
                            
                        case .failure:
                            // 即使 API 失敗，Demo 模式下也移除
                            self?.availableOrders.remove(at: indexPath.row)
                            self?.tableView.deleteRows(at: [indexPath], with: .fade)
                            self?.updateEmptyState()
                        }
                    }
                }
            }
        )
    }
    
    private func showOrderDetail(_ order: DriverOrder) {
        // TODO: 實作訂單詳情頁面
        let message = """
        餐廳：\(order.restaurantName ?? "")
        餐廳地址：\(order.restaurantAddress ?? "")
        
        客戶：\(order.customerName ?? "")
        送達地址：\(order.customerAddress ?? "")
        
        配送費：\(order.formattedDeliveryFee)
        距離：\(order.formattedDistance)
        餐點數量：\(order.itemCount) 件
        """
        
        showAlert(title: "訂單詳情", message: message)
    }
}
