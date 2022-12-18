//
//  LoginViewController.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 28.05.2022.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var loginWebView: WKWebView!
    
    private let session = Session.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.navigationDelegate = self
        
        loadAuth()
    }


}

// MARK: - private extension WebLoginViewController, WKNavigationDelegate

extension LoginViewController {
    func loadAuth() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8140202"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall, photos, friends, groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "0"),
        ]

        let request = URLRequest(url: urlComponents.url!)
        loginWebView.load(request)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        if let token = params["access_token"],
            let userId = params["user_id"] {
            
            session.token = token
            session.id = Int(userId)
            print(token)
            decisionHandler(.cancel)
            performSegue(withIdentifier: "toFeed", sender: self)
        }
    }
}
