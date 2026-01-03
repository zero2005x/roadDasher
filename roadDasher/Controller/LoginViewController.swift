//
//  LoginViewController.swift
//  roadDasher
//
//  Updated by GitHub Copilot on 2026/1/3.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, LoginButtonDelegate {
   
    // MARK: - UI Components
    
    @IBOutlet weak var facebookLoginBtn: FBButton!
    
    /// Logo 圖片
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bicycle.circle.fill")
        imageView.tintColor = .rdPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// App 名稱標籤
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "RoadDasher"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .rdTextPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// 副標題
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "外送員專屬 APP"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .rdTextSecondary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// 載入指示器
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .rdPrimary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    @IBAction func facebookLoginBtn(_ sender: Any) {
        // 手動觸發登入（如果需要）
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkExistingToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 加入 Logo 和標題
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40)
        ])
    }
    
    // MARK: - Authentication
    
    private func checkExistingToken() {
        if let token = AccessToken.current, !token.isExpired {
            // 已有有效 Token，直接取得用戶資訊
            activityIndicator.startAnimating()
            fetchUserInfo(token: token.tokenString)
        } else {
            // 顯示登入按鈕
            setupFacebookLoginButton()
        }
    }
    
    private func setupFacebookLoginButton() {
        let facebookLoginBtn = FBLoginButton()
        facebookLoginBtn.center = view.center
        facebookLoginBtn.delegate = self
        facebookLoginBtn.permissions = ["public_profile", "email"]
        
        // 調整位置到畫面下方
        facebookLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facebookLoginBtn)
        
        NSLayoutConstraint.activate([
            facebookLoginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookLoginBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            facebookLoginBtn.widthAnchor.constraint(equalToConstant: 280),
            facebookLoginBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func fetchUserInfo(token: String) {
        let request = FBSDKLoginKit.GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, name, picture.type(large)"],
            tokenString: token,
            version: nil,
            httpMethod: .get
        )
        
        request.start { [weak self] connection, result, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    self?.handleLoginError(error)
                    return
                }
                
                if let userData = result as? [String: Any] {
                    print("User data: \(userData)")
                    
                    // 更新用戶資訊
                    if let name = userData["name"] as? String {
                        User.currenUser.name = name
                    }
                    if let email = userData["email"] as? String {
                        User.currenUser.email = email
                    }
                    if let picture = userData["picture"] as? [String: Any],
                       let data = picture["data"] as? [String: Any],
                       let url = data["url"] as? String {
                        User.currenUser.pictureURL = url
                    }
                    
                    // 將 Token 發送到後端
                    self?.authenticateWithBackend(fbToken: token)
                }
            }
        }
    }
    
    private func authenticateWithBackend(fbToken: String) {
        APIService.shared.loginWithFacebook(accessToken: fbToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    // 儲存後端 Token
                    if let token = json["access_token"].string {
                        APIService.shared.setAccessToken(token)
                    }
                    self?.jumpSegue()
                    
                case .failure:
                    // Demo 模式：直接跳轉
                    print("Demo mode: Skipping backend authentication")
                    self?.jumpSegue()
                }
            }
        }
    }
    
    private func handleLoginError(_ error: Error) {
        let alert = UIAlertController(
            title: "登入失敗",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "重試", style: .default) { [weak self] _ in
            self?.setupFacebookLoginButton()
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - LoginButtonDelegate
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            handleLoginError(error)
            return
        }
        
        guard let result = result, !result.isCancelled else {
            print("Login cancelled")
            return
        }
        
        guard let token = result.token?.tokenString else {
            handleLoginError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "無法取得 Token"]))
            return
        }
        
        activityIndicator.startAnimating()
        fetchUserInfo(token: token)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // 清除用戶資訊
        User.currenUser.resetInfo()
        APIService.shared.clearToken()
        print("User logged out")
    }
    
    // MARK: - Navigation
    
    func jumpSegue() {
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") else {
            print("Error: Could not find mainVC in storyboard")
            return
        }
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        present(mainVC, animated: true) {
            print("Successfully navigated to main screen")
        }
    }
}
