//
//  WebViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//


import UIKit
import WebKit


class WebViewController: UIViewController {

    var listOfFavoriteNews =  [NewsEntity]()

    @IBOutlet weak var webViewArticle: WKWebView!
    var url = ""
    let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("cached").appendingPathExtension("webarchive")
    
    override func viewDidLoad() {
        listOfFavoriteNews = Services().fetch()
        super.viewDidLoad()
        let urlReq = URLRequest(url: URL(string: url)!)
        webViewArticle.load(urlReq)
//        archive()
        for article in listOfFavoriteNews{
            if article.url == url{
                unarchive()
            }
            else
            {
                webViewArticle.load(urlReq)
            }
        }
    }
    

    

    // MARK: - WebArchiver
    func unarchive() {
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            webViewArticle.loadFileURL(archiveURL, allowingReadAccessTo: archiveURL)
        } else {
            print("No Archive")
        }
    }

}
