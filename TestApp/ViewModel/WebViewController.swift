//
//  WebViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//


import UIKit
import WebKit

    //Цей контролер використовується для відображення даних з веб версії сайту NYT

class WebViewController: UIViewController {

    var listOfFavoriteNews =  [NewsEntity]()
    var listOfArchive = [SaveHTML]()

    @IBOutlet weak var webViewArticle: WKWebView!
    var url = ""
    let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("cached").appendingPathExtension("webarchive")
    
    
    override func viewDidLoad() {
        listOfFavoriteNews = Services().fetch()
        listOfArchive = WebArchiverServices().fetch()
        super.viewDidLoad()
        let urlReq = URLRequest(url: URL(string: url)!)
        webViewArticle.load(urlReq)
        for archive in listOfArchive{
            if archive.url == url{
                unarchive(archiveURL: archive.archiveURL!)
            }
        }
    }
    

    // MARK: - WebArchiver
    func unarchive(archiveURL: URL) {
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            webViewArticle.loadFileURL(archiveURL, allowingReadAccessTo: archiveURL)
        } else {
            print("No Archive")
        }
    }

}
