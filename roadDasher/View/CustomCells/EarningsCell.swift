//
//  EarningsCell.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import UIKit

/// 收入記錄 Cell
class EarningsCell: UITableViewCell {
    
    static let identifier = "EarningsCell"
    
    // MARK: - UI Components
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rdPrimary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdPrimary.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .rdTextPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .rdSuccess
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .rdTextSecondary
        label.textAlignment = .right
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
        
        contentView.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            // Icon background
            iconBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon
            iconView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Amount
            amountLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Date
            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with record: EarningRecord) {
        titleLabel.text = record.type.displayText
        subtitleLabel.text = record.description ?? "訂單 #\(record.orderId)"
        amountLabel.text = "+\(record.formattedAmount)"
        dateLabel.text = record.formattedDate
        iconView.image = UIImage(systemName: record.type.iconName)
        
        // 根據類型設定顏色
        switch record.type {
        case .tip:
            iconView.tintColor = .systemPink
            iconBackgroundView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        case .bonus:
            iconView.tintColor = .systemYellow
            iconBackgroundView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        case .adjustment:
            iconView.tintColor = .systemBlue
            iconBackgroundView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            if record.amount < 0 {
                amountLabel.text = record.formattedAmount
                amountLabel.textColor = .rdError
            }
        default:
            iconView.tintColor = .rdPrimary
            iconBackgroundView.backgroundColor = UIColor.rdPrimary.withAlphaComponent(0.1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        amountLabel.textColor = .rdSuccess
    }
}
