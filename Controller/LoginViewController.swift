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
    
    fileprivate var currentNonce: String?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    weak var sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        setUpSignInButton()
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
    
    func setUpSignInButton() {
        
        let button = ASAuthorizationAppleIDButton()
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            button.bottomAnchor.constraint(equalTo: appEnglishNameLabel.bottomAnchor, constant: 100),
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
                
                if let user = authResult?.user {
                    print("Nice! You are now signed in as \(user.uid), email: \(user.email)")
                    
                    if let fullName = appleIDCredential.fullName,
                       let userName = fullName.givenName {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                   
                    changeRequest?.displayName = userName
                    changeRequest?.commitChanges { error in
                      print("can not change userName")
                    }
                    }
                    
                    UserManager.shared.createUserInfo()
                        
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
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
