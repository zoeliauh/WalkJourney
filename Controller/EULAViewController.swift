//
//  EULAViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/19.
//
//

import UIKit
import WebKit

class LAEUViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        loadURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - method
    private func loadURL() {
        
        let LAEUURL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
        
        if let url = URL(string: LAEUURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - UI properties
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        web.navigationDelegate = self
        return web
    }()
}

// MARK: - conform to WKNavigationDelegate
extension LAEUViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
}

// MARK: - config UI method
extension LAEUViewController {
    
    private func setWebView() {
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
