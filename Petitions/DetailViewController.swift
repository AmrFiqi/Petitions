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
        let petition = detailItem.title.uppercased()
        title = petition.components(separatedBy: " ").first
        let signatureCount = detailItem.signatureCount
        let html =
"""
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
font-size: 150%;
}
p {
  text-align: center;
  text-transform: uppercase;
  font-style: italic;
}
h5 {
    text-transform: uppercase;
    text-align: center;
}
</style>
</head>
<body>
<h5>\(petition)</h5>
\(detailItem.body)
<br>
<br>
<p> Signature Count: \(signatureCount) </p>

</body>
</html>
"""
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    


}
