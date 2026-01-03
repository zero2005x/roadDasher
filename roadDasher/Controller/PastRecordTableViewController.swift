//
//  PastRecordTableViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/25.
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit

class PastRecordTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// 歷史訂單列表
    private var orderHistory: [DriverOrder] = []
    
    /// 當前頁碼（分頁用）
    private var currentPage = 1
    
    /// 是否還有更多資料
    private var hasMoreData = true
    
    /// 是否正在載入
    private var isLoading = false
    
    /// 刷新控制器
    private let refreshCtrl = UIRefreshControl()
    
    /// 搜尋控制器
    private let searchController = UISearchController(searchResultsController: nil)
    
    /// 篩選後的訂單
    private var filteredOrders: [DriverOrder] = []
    
    /// 是否正在搜尋
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    /// 空狀態視圖
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView(image: UIImage(systemName: "clock.arrow.circlepath"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rdTextSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "沒有歷史訂單"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .rdTextPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "完成的訂單會顯示在這裡"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .rdTextSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
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
        setupSearchController()
        setupRefreshControl()
        loadOrderHistory()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "歷史紀錄"
        
        tableView.backgroundColor = .rdLightBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // 註冊 Cell
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        
        // 設定空狀態視圖
        tableView.backgroundView = emptyStateView
        emptyStateView.isHidden = true
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜尋餐廳或地址"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupRefreshControl() {
        refreshCtrl.addTarget(self, action: #selector(refreshHistory), for: .valueChanged)
        tableView.refreshControl = refreshCtrl
    }
    
    // MARK: - Data Loading
    
    @objc private func refreshHistory() {
        currentPage = 1
        hasMoreData = true
        orderHistory.removeAll()
        loadOrderHistory()
    }
    
    private func loadOrderHistory() {
        guard !isLoading && hasMoreData else {
            refreshCtrl.endRefreshing()
            return
        }
        
        isLoading = true
        
        APIService.shared.getOrderHistory(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.refreshCtrl.endRefreshing()
                
                switch result {
                case .success(let orders):
                    if orders.isEmpty {
                        self?.hasMoreData = false
                    } else {
                        self?.orderHistory.append(contentsOf: orders)
                        self?.currentPage += 1
                    }
                    self?.updateEmptyState()
                    self?.tableView.reloadData()
                    
                case .failure:
                    // Demo 模式：載入模擬資料
                    if self?.orderHistory.isEmpty ?? true {
                        self?.loadMockData()
                    }
                }
            }
        }
    }
    
    private func loadMockData() {
        let now = Date()
        
        for i in 0..<15 {
            let order = DriverOrder()
            order.id = 1000 - i
            order.orderNumber = "#RD\(1000 - i)"
            order.restaurantName = ["麥當勞 信義店", "星巴克 101店", "鼎泰豐 信義店", "肯德基 松山店", "摩斯漢堡 南港店"].randomElement()
            order.restaurantAddress = "台北市信義區信義路五段\(Int.random(in: 1...200))號"
            order.customerName = ["王小明", "李小華", "張大明", "陳美麗", "林志玲"].randomElement()
            order.customerAddress = "台北市信義區松仁路\(Int.random(in: 1...500))號"
            order.deliveryFee = Float([55, 60, 65, 70, 75, 80, 85].randomElement()!)
            order.status = .delivered
            order.createdAt = now.addingTimeInterval(TimeInterval(-86400 * i - 3600 * Int.random(in: 1...12)))
            
            orderHistory.append(order)
        }
        
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        let orders = isSearching ? filteredOrders : orderHistory
        emptyStateView.isHidden = !orders.isEmpty
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let orders = isSearching ? filteredOrders : orderHistory
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        
        let orders = isSearching ? filteredOrders : orderHistory
        
        if indexPath.row < orders.count {
            cell.configure(with: orders[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let orders = isSearching ? filteredOrders : orderHistory
        guard indexPath.row < orders.count else { return }
        
        let order = orders[indexPath.row]
        showOrderDetail(order)
    }
    
    // MARK: - Scroll view delegate (Pagination)
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // 當滾動到底部附近時載入更多
        if offsetY > contentHeight - height - 100 && !isSearching {
            loadOrderHistory()
        }
    }
    
    // MARK: - Actions
    
    private func showOrderDetail(_ order: DriverOrder) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let dateStr = order.createdAt != nil ? dateFormatter.string(from: order.createdAt!) : "未知"
        
        let message = """
        訂單編號：\(order.orderNumber ?? "#\(order.id ?? 0)")
        日期：\(dateStr)
        
        餐廳：\(order.restaurantName ?? "")
        
        送達地址：\(order.customerAddress ?? "")
        
        配送費：\(order.formattedDeliveryFee)
        狀態：\(order.status.displayText)
        """
        
        showAlert(title: "訂單詳情", message: message)
    }
}

// MARK: - UISearchResultsUpdating

extension PastRecordTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            filteredOrders = []
            updateEmptyState()
            tableView.reloadData()
            return
        }
        
        filteredOrders = orderHistory.filter { order in
            let restaurantMatch = order.restaurantName?.lowercased().contains(searchText) ?? false
            let addressMatch = order.customerAddress?.lowercased().contains(searchText) ?? false
            let orderNumberMatch = order.orderNumber?.lowercased().contains(searchText) ?? false
            return restaurantMatch || addressMatch || orderNumberMatch
        }
        
        updateEmptyState()
        tableView.reloadData()
    }
}
