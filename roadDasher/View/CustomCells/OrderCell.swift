//
//  OrderCell.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import UIKit

/// 訂單列表 Cell
class OrderCell: UITableViewCell {
    
    static let identifier = "OrderCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .rdCardBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let restaurantLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .rdTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let restaurantAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down")
        imageView.tintColor = .rdPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let customerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .rdTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let customerAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .rdPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(restaurantLabel)
        containerView.addSubview(restaurantAddressLabel)
        containerView.addSubview(arrowImageView)
        containerView.addSubview(customerLabel)
        containerView.addSubview(customerAddressLabel)
        containerView.addSubview(dividerView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(distanceLabel)
        containerView.addSubview(itemCountLabel)
        containerView.addSubview(statusBadge)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Restaurant
            restaurantLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            restaurantLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            restaurantLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadge.leadingAnchor, constant: -8),
            
            restaurantAddressLabel.topAnchor.constraint(equalTo: restaurantLabel.bottomAnchor, constant: 4),
            restaurantAddressLabel.leadingAnchor.constraint(equalTo: restaurantLabel.leadingAnchor),
            restaurantAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Arrow
            arrowImageView.topAnchor.constraint(equalTo: restaurantAddressLabel.bottomAnchor, constant: 8),
            arrowImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Customer
            customerLabel.centerYAnchor.constraint(equalTo: arrowImageView.centerYAnchor),
            customerLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 12),
            customerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            customerAddressLabel.topAnchor.constraint(equalTo: customerLabel.bottomAnchor, constant: 4),
            customerAddressLabel.leadingAnchor.constraint(equalTo: customerLabel.leadingAnchor),
            customerAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Divider
            dividerView.topAnchor.constraint(equalTo: customerAddressLabel.bottomAnchor, constant: 12),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Price
            priceLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // Distance
            distanceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Item count
            itemCountLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            itemCountLabel.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -16),
            
            // Status badge
            statusBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            statusBadge.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with order: DriverOrder) {
        restaurantLabel.text = order.restaurantName ?? "餐廳"
        restaurantAddressLabel.text = order.restaurantAddress ?? ""
        customerLabel.text = order.customerName ?? "客戶"
        customerAddressLabel.text = order.customerAddress ?? ""
        priceLabel.text = order.formattedDeliveryFee
        distanceLabel.text = order.formattedDistance
        itemCountLabel.text = "\(order.itemCount) 件商品"
        
        // Status badge
        statusBadge.text = " \(order.status.displayText) "
        statusBadge.backgroundColor = UIColor.color(for: order.status)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantLabel.text = nil
        restaurantAddressLabel.text = nil
        customerLabel.text = nil
        customerAddressLabel.text = nil
        priceLabel.text = nil
        distanceLabel.text = nil
        itemCountLabel.text = nil
    }
}
