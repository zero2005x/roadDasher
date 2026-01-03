//
//  UIViewController+Alert.swift
//  roadDasher
//
//  Created by GitHub Copilot on 2026/1/3.
//

import UIKit

extension UIViewController {
    
    // MARK: - Simple Alerts
    
    /// 顯示簡單提示框
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    /// 顯示錯誤提示
    func showError(_ message: String) {
        showAlert(title: "錯誤", message: message)
    }
    
    /// 顯示成功提示
    func showSuccess(_ message: String, completion: (() -> Void)? = nil) {
        showAlert(title: "成功", message: message, completion: completion)
    }
    
    // MARK: - Confirmation Alerts
    
    /// 顯示確認對話框
    func showConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "確定",
        cancelTitle: String = "取消",
        confirmStyle: UIAlertAction.Style = .default,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        })
        
        alert.addAction(UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            onConfirm()
        })
        
        present(alert, animated: true)
    }
    
    /// 顯示危險操作確認（紅色按鈕）
    func showDestructiveConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "確定",
        onConfirm: @escaping () -> Void
    ) {
        showConfirmation(
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            confirmStyle: .destructive,
            onConfirm: onConfirm
        )
    }
    
    // MARK: - Loading Indicator
    
    private static var loadingView: UIView?
    
    /// 顯示載入中指示器
    func showLoading(message: String = "載入中...") {
        DispatchQueue.main.async {
            // 移除已存在的 loading view
            UIViewController.loadingView?.removeFromSuperview()
            
            let containerView = UIView(frame: self.view.bounds)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            containerView.tag = 999
            
            let loadingBox = UIView()
            loadingBox.backgroundColor = .systemBackground
            loadingBox.layer.cornerRadius = 12
            loadingBox.translatesAutoresizingMaskIntoConstraints = false
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = message
            label.textColor = .label
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            loadingBox.addSubview(activityIndicator)
            loadingBox.addSubview(label)
            containerView.addSubview(loadingBox)
            self.view.addSubview(containerView)
            
            NSLayoutConstraint.activate([
                loadingBox.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                loadingBox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                loadingBox.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
                loadingBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
                
                activityIndicator.centerXAnchor.constraint(equalTo: loadingBox.centerXAnchor),
                activityIndicator.topAnchor.constraint(equalTo: loadingBox.topAnchor, constant: 20),
                
                label.centerXAnchor.constraint(equalTo: loadingBox.centerXAnchor),
                label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
                label.bottomAnchor.constraint(equalTo: loadingBox.bottomAnchor, constant: -16),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: loadingBox.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(lessThanOrEqualTo: loadingBox.trailingAnchor, constant: -16)
            ])
            
            UIViewController.loadingView = containerView
        }
    }
    
    /// 隱藏載入中指示器
    func hideLoading() {
        DispatchQueue.main.async {
            UIViewController.loadingView?.removeFromSuperview()
            UIViewController.loadingView = nil
        }
    }
    
    // MARK: - Action Sheet
    
    /// 顯示動作選單
    func showActionSheet(
        title: String?,
        message: String?,
        actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)],
        sourceView: UIView? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler()
            })
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        // iPad support
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sourceView ?? view
            popover.sourceRect = sourceView?.bounds ?? CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(alert, animated: true)
    }
}
