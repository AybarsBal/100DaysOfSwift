//
//  DetailViewController.swift
//  Project16
//
//  Created by Yakup Aybars Bal on 24.01.2024.
//

import UIKit
import WebKit

// Challenge 3 
class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var currentCity = String()

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://en.wikipedia.org/wiki/" + currentCity)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    

    

}
