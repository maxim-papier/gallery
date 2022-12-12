//
//  WebViewViewController.swift
//  Gallery
//
//  Created by Maxim V. Brykov on 12.12.2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        loadWebView(url: composeAuthorizationURL())

    }
    
    
    // Compose a URL for a further request
    
    private func composeAuthorizationURL() -> URL {
        
        var urlComponents = URLComponents(string: K.authURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: K.accessKey),
            URLQueryItem(name: "redirect_uri", value: K.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: K.accessScope)
        ]
        
        let url = urlComponents.url!
        return url
        
    }
    
    
    // Load authorization page
    
    private func loadWebView(url: URL) {
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    
    
    
}


