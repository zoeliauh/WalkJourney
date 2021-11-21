//
//  StartPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/31.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var appMandarinNameLabel: UILabel!
    
    @IBOutlet weak var appEnglishNameLabel: UILabel!
    
    lazy var policySettingLabel: UILabel = {
        let label = UILabel()
        label.text = "客戶註冊即表示您同意我們的"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()
    
    lazy var policySettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("隱私權政策", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(presentPolicy), for: .touchUpInside)
        return button
    }()
    
    lazy var andLabel: UILabel = {
        let label = UILabel()
        label.text = "及"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()
    
    lazy var LAEUButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple標準許可協議", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(presentLAEU), for: .touchUpInside)
        return button
    }()
    
    fileprivate var currentNonce: String?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    weak var sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        setUpSignInButton()
        
        setPolicySettingLabel()
        
        setPolicySettingButton()
        
        setAndLabel()
        
        setLAEUButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpSignInButton()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - presentPolicy
    @objc func presentPolicy() {
        let storyboard = UIStoryboard(name: "Position", bundle: nil)
        guard let policyVc = storyboard.instantiateViewController(
            withIdentifier: String(describing: PrivacyPolicyViewController.self)
        ) as? PrivacyPolicyViewController else { return }
        
        present(policyVc, animated: true, completion: nil)
    }
    
    @objc func presentLAEU() {
        let storyboard = UIStoryboard(name: "Position", bundle: nil)
        guard let LAEUvc = storyboard.instantiateViewController(
            withIdentifier: String(describing: LAEUViewController.self)
        ) as? LAEUViewController else { return }
        
        present(LAEUvc, animated: true, completion: nil)
    }
    
    private func setPolicySettingLabel() {
        view.addSubview(policySettingLabel)
        policySettingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            policySettingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            policySettingLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -110)
        ])
    }
    
    private func setPolicySettingButton() {
        view.addSubview(policySettingButton)
        policySettingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            policySettingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            policySettingButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func setAndLabel() {
        view.addSubview(andLabel)
        andLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            andLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            andLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -79)
        ])
    }
    
    private func setLAEUButton() {
        view.addSubview(LAEUButton)
        LAEUButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            LAEUButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LAEUButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
    
    func setUpSignInButton() {
        
        let button = ASAuthorizationAppleIDButton()
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            button.topAnchor.constraint(equalTo: appEnglishNameLabel.bottomAnchor, constant: 80),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
    }
    
    @objc func handleSignInWithAppleTapped() {
        
        performSignIn()
    }
    
    func performSignIn() {
        
        let request = createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        
        request.nonce = sha256(nonce)
        
        currentNonce = nonce
        
        return request
    }
    
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token")
                return
                
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
                
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // sign in with Firebase
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print("登入失敗")
                    print(error.localizedDescription)
                    return
                }
                
                if let additionalUserInfo = authResult?.additionalUserInfo,
                   let user = authResult?.user,
                   additionalUserInfo.isNewUser {
                    
                    print("Nice! You are now signed in as \(String(describing: user.email)), email: \(String(describing: user.email))")
                    
                    if let fullName = appleIDCredential.fullName,
                       let userName = fullName.givenName {
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        
                        changeRequest?.displayName = userName
                        changeRequest?.commitChanges { error in
                            print("can not change userName \(String(describing: error))")
                        }
                    }
                    
                    UserManager.shared.createUserInfo()
                    
                } else {
                    
                    UserManager.shared.uid = authResult?.user.uid
                
                    print("be a user already")
                }
                        
                    guard let window = self.sceneDelegate?.window else {
                        fatalError("Cannot get window")
                    }
                    
                    guard let tabBarVC = UIStoryboard
                            .main
                            .instantiateViewController(
                                withIdentifier: String(describing: TabBarController.self)
                            ) as? TabBarController else {
                                
                                return
                            }
                    
                    window.rootViewController = tabBarVC
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            
            print("Sign in with Apple errored: \(error)")
        }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let window = self.view.window else { fatalError() }
        
        return window
    }
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}
