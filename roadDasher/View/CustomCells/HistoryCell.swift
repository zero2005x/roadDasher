//
//  HistoryCell.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import UIKit

/// 歷史訂單 Cell
class HistoryCell: UITableViewCell {
    
    static let identifier = "HistoryCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .rdCardBackground
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let restaurantLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .rdTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .rdTextSecondary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let earningsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .rdSuccess
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .rdTextSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        containerView.addSubview(dateLabel)
        containerView.addSubview(orderNumberLabel)
        containerView.addSubview(restaurantLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(earningsLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Date
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            // Order number
            orderNumberLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            orderNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Restaurant
            restaurantLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            restaurantLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            restaurantLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            
            // Status
            statusLabel.centerYAnchor.constraint(equalTo: restaurantLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Address
            addressLabel.topAnchor.constraint(equalTo: restaurantLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            addressLabel.trailingAnchor.constraint(equalTo: earningsLabel.leadingAnchor, constant: -8),
            addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // Earnings
            earningsLabel.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor),
            earningsLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Chevron
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with order: DriverOrder) {
        restaurantLabel.text = order.restaurantName ?? "餐廳"
        addressLabel.text = order.customerAddress ?? ""
        orderNumberLabel.text = order.orderNumber ?? "#\(order.id ?? 0)"
        earningsLabel.text = order.formattedDeliveryFee
        
        // Date
        if let date = order.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm"
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        // Status
        statusLabel.text = " \(order.status.displayText) "
        statusLabel.backgroundColor = UIColor.color(for: order.status)
        statusLabel.textColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantLabel.text = nil
        addressLabel.text = nil
        dateLabel.text = nil
        orderNumberLabel.text = nil
        earningsLabel.text = nil
    }
}
