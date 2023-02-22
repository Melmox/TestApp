//
//  WebViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import UIKit
import WebKit


class WebViewController: UIViewController {


    @IBOutlet weak var webViewArticle: WKWebView!
    
//    let url = URL(string: "https://www.google.com")
    var url = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlReq = URLRequest(url: URL(string: url)!)
        webViewArticle.load(urlReq)
//        webViewArticle.load(URLRequest(url: url))
//        webViewArticle.allowsBackForwardNavigationGestures = true
    }
    
//        override func loadView() {
//            webViewArticle = WKWebView()
////            webViewArticle.navigationDelegate = self
//            view = webViewArticle
//        }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
