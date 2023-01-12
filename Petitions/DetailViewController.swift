//
//  DetailViewController.swift
//  Petitions
//
//  Created by Amr El-Fiqi on 11/01/2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else{return}
        let petition = detailItem.title
        title = petition.components(separatedBy: " ").first
        let html =
"""
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style> body { font-size: 150%; } </style>
</head>
<body>
<h4>\(petition)</h4>
\(detailItem.body)
</body>
</html>
"""
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    


}
