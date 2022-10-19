//
//  WebVC.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 11.10.2022.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    var currentURL: URL?

    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        fechURL()
        view.addSubview(webView)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpWebView()
    }
    
    func setUpWebView(){
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fechURL(){
        guard let _ = currentURL else { return }
        let request = URLRequest(url: currentURL!)
        webView.load(request)
    }
    
     init (adress: String){
         super.init(nibName: nil, bundle: nil)
        if let safeURL = URL(string: adress.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!){
            self.currentURL = safeURL
        } else {
            self.currentURL = URL(string: "https://www.apple.com")!
        }
    }
    
        required init?(coder: NSCoder){
            fatalError("init(coder:) has not been implemented")
        }
        
    }

