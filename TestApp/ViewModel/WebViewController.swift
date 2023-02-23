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
