
import FBSDKLoginKit
class LoginViewController: UIViewController, LoginButtonDelegate{
   
    @IBOutlet weak var facebookLoginBtn: FBButton!
    
    @IBAction func facebookLoginBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        if let token = AccessToken.current, !token.isExpired {
            
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["field": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connect, result, error in
                print("\(result)")
                
            }
            self.jumpSegue()
        }
        else{
            
            let facebookLoginBtn = FBLoginButton()
            facebookLoginBtn.center = view.center
            facebookLoginBtn.delegate = self
            facebookLoginBtn.permissions = ["public_profile", "email"]
            view.addSubview(facebookLoginBtn)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
     

    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
       
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["field": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start {connect, result, error in
            
            print("\(result.debugDescription)")
            
            if let error = error {
                print("\(error)")
            }
            
        }
        self.jumpSegue()
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    func  jumpSegue(){
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "mainVC")
        //let loginVC = storyboard?.instantiateInitialViewController()
        loginVC!.modalPresentationStyle = .overCurrentContext
        self.present(loginVC!, animated: true, completion: nil)
    }
 
}
