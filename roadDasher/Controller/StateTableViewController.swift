//
//  StateTableViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/25.
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit
import MapKit

class StateTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// 當前進行中的訂單
    private var currentOrder: DriverOrder?
    
    /// 是否正在載入
    private var isLoading = false
    
    /// 刷新控制器
    private let refreshCtrl = UIRefreshControl()
    
    // MARK: - Section Types
    
    private enum Section: Int, CaseIterable {
        case status = 0
        case orderInfo = 1
        case restaurant = 2
        case customer = 3
        case actions = 4
    }
    
    /// 空狀態視圖
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView(image: UIImage(systemName: "bicycle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rdTextSecondary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "目前沒有進行中的訂單"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .rdTextPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "接受新訂單後會顯示在這裡"
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
        setupRefreshControl()
        loadCurrentOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCurrentOrder()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "配送狀態"
        
        tableView.backgroundColor = .rdLightBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // 設定空狀態視圖
        tableView.backgroundView = emptyStateView
    }
    
    private func setupRefreshControl() {
        refreshCtrl.addTarget(self, action: #selector(refreshOrder), for: .valueChanged)
        tableView.refreshControl = refreshCtrl
    }
    
    // MARK: - Data Loading
    
    @objc private func refreshOrder() {
        loadCurrentOrder()
    }
    
    private func loadCurrentOrder() {
        guard !isLoading else { return }
        isLoading = true
        
        APIService.shared.getCurrentOrder { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.refreshCtrl.endRefreshing()
                
                switch result {
                case .success(let order):
                    self?.currentOrder = order
                    self?.updateEmptyState()
                    self?.tableView.reloadData()
                    
                case .failure:
                    // Demo 模式：載入模擬資料
                    self?.loadMockData()
                }
            }
        }
    }
    
    private func loadMockData() {
        let mockOrder = DriverOrder()
        mockOrder.id = 1001
        mockOrder.orderNumber = "#RD1001"
        mockOrder.restaurantName = "麥當勞 信義店"
        mockOrder.restaurantAddress = "台北市信義區信義路五段7號"
        mockOrder.restaurantPhone = "02-2345-6789"
        mockOrder.restaurantLatitude = 25.0330
        mockOrder.restaurantLongitude = 121.5654
        mockOrder.customerName = "王小明"
        mockOrder.customerAddress = "台北市信義區松仁路100號12樓"
        mockOrder.customerPhone = "0912-345-678"
        mockOrder.customerLatitude = 25.0360
        mockOrder.customerLongitude = 121.5680
        mockOrder.deliveryFee = 60
        mockOrder.tip = 20
        mockOrder.total = 350
        mockOrder.distance = 2.5
        mockOrder.status = .accepted
        mockOrder.note = "請走大門，管理員會放行"
        
        currentOrder = mockOrder
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = currentOrder != nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentOrder != nil ? Section.allCases.count : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard currentOrder != nil else { return 0 }
        
        switch Section(rawValue: section) {
        case .status:
            return 1
        case .orderInfo:
            return 3  // 訂單編號、金額、備註
        case .restaurant:
            return 2  // 餐廳名稱、地址
        case .customer:
            return 2  // 客戶名稱、地址
        case .actions:
            return 2  // 下一步按鈕、導航按鈕
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .status:
            return nil
        case .orderInfo:
            return "訂單資訊"
        case .restaurant:
            return "餐廳資訊"
        case .customer:
            return "客戶資訊"
        case .actions:
            return nil
        case .none:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let order = currentOrder else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        switch Section(rawValue: indexPath.section) {
        case .status:
            return createStatusCell(for: order)
            
        case .orderInfo:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "訂單編號"
                cell.detailTextLabel?.text = order.orderNumber ?? "#\(order.id ?? 0)"
            case 1:
                cell.textLabel?.text = "配送費"
                cell.detailTextLabel?.text = order.formattedDeliveryFee
                cell.detailTextLabel?.textColor = .rdSuccess
            case 2:
                cell.textLabel?.text = "備註"
                cell.detailTextLabel?.text = order.note ?? "無"
                cell.detailTextLabel?.textColor = order.note != nil ? .rdWarning : .rdTextSecondary
            default:
                break
            }
            
        case .restaurant:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "餐廳"
                cell.detailTextLabel?.text = order.restaurantName
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            case 1:
                cell.textLabel?.text = "地址"
                cell.detailTextLabel?.text = order.restaurantAddress
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            default:
                break
            }
            
        case .customer:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "客戶"
                cell.detailTextLabel?.text = order.customerName
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            case 1:
                cell.textLabel?.text = "送達地址"
                cell.detailTextLabel?.text = order.customerAddress
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            default:
                break
            }
            
        case .actions:
            return createActionCell(for: order, at: indexPath)
            
        case .none:
            break
        }
        
        return cell
    }
    
    // MARK: - Custom Cells
    
    private func createStatusCell(for order: DriverOrder) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.color(for: order.status)
        
        let statusLabel = UILabel()
        statusLabel.text = order.status.displayText
        statusLabel.font = .boldSystemFont(ofSize: 24)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: order.status.iconName)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(iconImageView)
        cell.contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            statusLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return cell
    }
    
    private func createActionCell(for order: DriverOrder, at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .default
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        if indexPath.row == 0 {
            // 下一步按鈕
            if let nextAction = order.status.nextActionText {
                button.setTitle(nextAction, for: .normal)
                button.backgroundColor = .rdPrimary
                button.setTitleColor(.white, for: .normal)
                button.tag = 100
                button.addTarget(self, action: #selector(nextStatusTapped), for: .touchUpInside)
            } else {
                button.setTitle("訂單已完成", for: .normal)
                button.backgroundColor = .rdSuccess
                button.setTitleColor(.white, for: .normal)
                button.isEnabled = false
            }
        } else {
            // 導航按鈕
            button.setTitle("🗺 開啟導航", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.tag = 101
            button.addTarget(self, action: #selector(openNavigationTapped), for: .touchUpInside)
        }
        
        cell.contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let order = currentOrder else { return }
        
        switch Section(rawValue: indexPath.section) {
        case .restaurant:
            if indexPath.row == 0, let phone = order.restaurantPhone {
                callPhone(phone)
            } else if indexPath.row == 1, let location = order.restaurantLocation {
                openMapNavigation(to: location, name: order.restaurantName ?? "餐廳")
            }
            
        case .customer:
            if indexPath.row == 0, let phone = order.customerPhone {
                callPhone(phone)
            } else if indexPath.row == 1, let location = order.customerLocation {
                openMapNavigation(to: location, name: order.customerAddress ?? "客戶")
            }
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @objc private func nextStatusTapped() {
        guard let order = currentOrder,
              let nextStatus = order.status.nextStatus,
              let orderId = order.id else { return }
        
        showConfirmation(
            title: "確認更新狀態",
            message: "將狀態更新為「\(nextStatus.displayText)」？",
            onConfirm: { [weak self] in
                self?.updateOrderStatus(orderId: orderId, to: nextStatus)
            }
        )
    }
    
    private func updateOrderStatus(orderId: Int, to status: DeliveryStatus) {
        showLoading(message: "更新中...")
        
        APIService.shared.updateOrderStatus(orderId: orderId, status: status) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                
                switch result {
                case .success:
                    self?.currentOrder?.status = status
                    self?.tableView.reloadData()
                    
                    if status.isFinal {
                        self?.showSuccess("訂單已完成！") {
                            self?.currentOrder = nil
                            self?.updateEmptyState()
                            self?.tableView.reloadData()
                        }
                    }
                    
                case .failure:
                    // Demo 模式：直接更新本地狀態
                    self?.currentOrder?.status = status
                    self?.tableView.reloadData()
                    
                    if status.isFinal {
                        self?.showSuccess("訂單已完成！") {
                            self?.currentOrder = nil
                            self?.updateEmptyState()
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func openNavigationTapped() {
        guard let order = currentOrder else { return }
        
        // 根據狀態決定導航目的地
        let destination: CLLocationCoordinate2D?
        let destinationName: String
        
        if order.status == .pickedUp || order.status == .delivering || order.status == .arrived {
            destination = order.customerLocation
            destinationName = order.customerAddress ?? "客戶位置"
        } else {
            destination = order.restaurantLocation
            destinationName = order.restaurantName ?? "餐廳"
        }
        
        if let location = destination {
            openMapNavigation(to: location, name: destinationName)
        } else {
            showError("無法取得目的地位置")
        }
    }
    
    private func callPhone(_ phone: String) {
        let cleanedPhone = phone.replacingOccurrences(of: "-", with: "")
        if let url = URL(string: "tel://\(cleanedPhone)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openMapNavigation(to coordinate: CLLocationCoordinate2D, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
