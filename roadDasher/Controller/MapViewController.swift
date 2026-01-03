//
//  MapViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/17.
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit
import CoreLocation
import MapKit
import CoreData


class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var manager: CLLocationManager = CLLocationManager()
    var latitude: Double = 25.03407286999999
    var longitude: Double = 121.54360960999996
    
    /// 外送員上線狀態
    private var isOnline: Bool = false {
        didSet {
            updateOnlineStatusUI()
        }
    }
    
    /// 當前訂單（如果有）
    private var currentOrder: DriverOrder?
    
    /// 位置更新計時器
    private var locationUpdateTimer: Timer?
    
    // MARK: - UI Components
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showLocationBtnPressed: UIButton!
    
    /// 上線狀態按鈕
    private lazy var onlineStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("上線接單", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .rdSuccess
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleOnlineStatus), for: .touchUpInside)
        return button
    }()
    
    /// 狀態指示標籤
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "離線中"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .rdTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// 訂單資訊卡片
    private lazy var orderInfoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .rdCardBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    @IBAction func showLocationBtnPressed(_ sender: Any) {
        centerMapOnUserLocation()
        print("Start Showing and Reporting my location")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCurrentOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationUpdateTimer?.invalidate()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // 定位按鈕樣式
        showLocationBtnPressed.contentVerticalAlignment = .fill
        showLocationBtnPressed.contentHorizontalAlignment = .fill
        showLocationBtnPressed.layer.cornerRadius = 25
        showLocationBtnPressed.layer.shadowColor = UIColor.black.cgColor
        showLocationBtnPressed.layer.shadowOffset = CGSize(width: 0, height: 2)
        showLocationBtnPressed.layer.shadowRadius = 4
        showLocationBtnPressed.layer.shadowOpacity = 0.2
        
        // 加入上線按鈕
        view.addSubview(onlineStatusButton)
        view.addSubview(statusLabel)
        view.addSubview(orderInfoCard)
        
        NSLayoutConstraint.activate([
            // 上線按鈕
            onlineStatusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onlineStatusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            onlineStatusButton.widthAnchor.constraint(equalToConstant: 160),
            onlineStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 狀態標籤
            statusLabel.centerXAnchor.constraint(equalTo: onlineStatusButton.centerXAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: onlineStatusButton.topAnchor, constant: -8),
            
            // 訂單資訊卡片
            orderInfoCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderInfoCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            orderInfoCard.bottomAnchor.constraint(equalTo: onlineStatusButton.topAnchor, constant: -60),
            orderInfoCard.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        setupOrderInfoCard()
    }
    
    private func setupOrderInfoCard() {
        let titleLabel = UILabel()
        titleLabel.text = "進行中的訂單"
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .rdTextSecondary
        titleLabel.tag = 201
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let restaurantLabel = UILabel()
        restaurantLabel.font = .boldSystemFont(ofSize: 16)
        restaurantLabel.textColor = .rdTextPrimary
        restaurantLabel.tag = 202
        restaurantLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let addressLabel = UILabel()
        addressLabel.font = .systemFont(ofSize: 13)
        addressLabel.textColor = .rdTextSecondary
        addressLabel.tag = 203
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let navigateButton = UIButton(type: .system)
        navigateButton.setTitle("導航", for: .normal)
        navigateButton.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill"), for: .normal)
        navigateButton.tintColor = .rdPrimary
        navigateButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        navigateButton.addTarget(self, action: #selector(navigateToDestination), for: .touchUpInside)
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        
        orderInfoCard.addSubview(titleLabel)
        orderInfoCard.addSubview(restaurantLabel)
        orderInfoCard.addSubview(addressLabel)
        orderInfoCard.addSubview(navigateButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: orderInfoCard.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: orderInfoCard.leadingAnchor, constant: 16),
            
            restaurantLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            restaurantLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            restaurantLabel.trailingAnchor.constraint(lessThanOrEqualTo: navigateButton.leadingAnchor, constant: -8),
            
            addressLabel.topAnchor.constraint(equalTo: restaurantLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: restaurantLabel.trailingAnchor),
            
            navigateButton.centerYAnchor.constraint(equalTo: orderInfoCard.centerYAnchor),
            navigateButton.trailingAnchor.constraint(equalTo: orderInfoCard.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupLocationManager() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func toggleOnlineStatus() {
        isOnline.toggle()
        
        // 通知伺服器狀態變更
        APIService.shared.updateDriverStatus(isOnline: isOnline) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Status updated successfully")
                case .failure:
                    // Demo 模式：忽略錯誤
                    print("Demo mode: Status update simulated")
                }
                
                if self?.isOnline == true {
                    self?.startLocationUpdates()
                } else {
                    self?.stopLocationUpdates()
                }
            }
        }
    }
    
    private func updateOnlineStatusUI() {
        UIView.animate(withDuration: 0.3) {
            if self.isOnline {
                self.onlineStatusButton.setTitle("離線", for: .normal)
                self.onlineStatusButton.backgroundColor = .rdError
                self.statusLabel.text = "🟢 上線中 - 等待訂單"
                self.statusLabel.textColor = .rdSuccess
            } else {
                self.onlineStatusButton.setTitle("上線接單", for: .normal)
                self.onlineStatusButton.backgroundColor = .rdSuccess
                self.statusLabel.text = "離線中"
                self.statusLabel.textColor = .rdTextSecondary
            }
        }
    }
    
    private func startLocationUpdates() {
        // 每 30 秒更新一次位置到伺服器
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.sendLocationToServer()
        }
        sendLocationToServer()
    }
    
    private func stopLocationUpdates() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    private func sendLocationToServer() {
        APIService.shared.updateLocation(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success:
                print("Location updated: \(self.latitude), \(self.longitude)")
            case .failure:
                print("Demo mode: Location update simulated")
            }
        }
    }
    
    private func centerMapOnUserLocation() {
        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }
    
    // MARK: - Order Management
    
    private func checkCurrentOrder() {
        APIService.shared.getCurrentOrder { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self?.currentOrder = order
                    self?.updateOrderUI()
                case .failure:
                    // Demo: 沒有當前訂單
                    self?.currentOrder = nil
                    self?.updateOrderUI()
                }
            }
        }
    }
    
    private func updateOrderUI() {
        if let order = currentOrder {
            orderInfoCard.isHidden = false
            
            if let restaurantLabel = orderInfoCard.viewWithTag(202) as? UILabel {
                restaurantLabel.text = order.restaurantName
            }
            if let addressLabel = orderInfoCard.viewWithTag(203) as? UILabel {
                // 根據狀態顯示不同地址
                if order.status == .pickedUp || order.status == .delivering {
                    addressLabel.text = "送達：\(order.customerAddress ?? "")"
                } else {
                    addressLabel.text = "取餐：\(order.restaurantAddress ?? "")"
                }
            }
            
            // 在地圖上顯示標記
            showOrderAnnotations(for: order)
        } else {
            orderInfoCard.isHidden = true
            mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        }
    }
    
    private func showOrderAnnotations(for order: DriverOrder) {
        // 移除舊的標記（保留用戶位置）
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        // 餐廳標記
        if let restaurantLocation = order.restaurantLocation {
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = restaurantLocation
            restaurantAnnotation.title = order.restaurantName
            restaurantAnnotation.subtitle = "餐廳"
            mapView.addAnnotation(restaurantAnnotation)
        }
        
        // 客戶標記
        if let customerLocation = order.customerLocation {
            let customerAnnotation = MKPointAnnotation()
            customerAnnotation.coordinate = customerLocation
            customerAnnotation.title = order.customerName
            customerAnnotation.subtitle = "送達地址"
            mapView.addAnnotation(customerAnnotation)
        }
        
        // 調整地圖顯示範圍
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @objc private func navigateToDestination() {
        guard let order = currentOrder else { return }
        
        let destination: CLLocationCoordinate2D?
        let destinationName: String
        
        // 根據訂單狀態決定目的地
        if order.status == .pickedUp || order.status == .delivering || order.status == .arrived {
            destination = order.customerLocation
            destinationName = order.customerAddress ?? "客戶位置"
        } else {
            destination = order.restaurantLocation
            destinationName = order.restaurantName ?? "餐廳"
        }
        
        guard let coord = destination else {
            showError("無法取得目的地位置")
            return
        }
        
        openMapNavigation(to: coord, name: destinationName)
    }
    
    private func openMapNavigation(to coordinate: CLLocationCoordinate2D, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        // 提供選項
        let alert = UIAlertController(title: "選擇導航方式", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Apple 地圖", style: .default) { _ in
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        })
        
        // Google Maps
        if let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            alert.addAction(UIAlertAction(title: "Google 地圖", style: .default) { _ in
                UIApplication.shared.open(googleMapsURL)
            })
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @IBAction func showRightView(_ sender: Any) {
        // TODO: 顯示側邊選單
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let fetchLocation = locations.first(where: { $0.horizontalAccuracy >= 0 }) else {
            return
        }
        
        self.latitude = fetchLocation.coordinate.latitude
        self.longitude = fetchLocation.coordinate.longitude
        print("Lat: \(self.latitude) Lon:\(self.longitude)")
        
        // 首次定位時置中地圖
        if mapView.userLocation.location == nil {
            centerMapOnUserLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 不自訂用戶位置標記
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "OrderAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        // 根據類型設定顏色
        if annotation.subtitle == "餐廳" {
            annotationView?.markerTintColor = .rdPrimary
            annotationView?.glyphImage = UIImage(systemName: "fork.knife")
        } else {
            annotationView?.markerTintColor = .rdSuccess
            annotationView?.glyphImage = UIImage(systemName: "house.fill")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        openMapNavigation(to: annotation.coordinate, name: annotation.title ?? "目的地")
    }
}

