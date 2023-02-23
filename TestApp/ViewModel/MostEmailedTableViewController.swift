//
//  TableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import UIKit
import CoreData

//Цей контролер дуже схожий на два інших, вони являють собою таблиці на які виводяться дані. З комірками можна взаємодіяти

class MostEmailedTableViewController: UITableViewController {
    @IBOutlet var mostEmailedTable: UITableView!
    var listOfMailedNews =  [News]()
    
    override func viewDidLoad() {
        WebArchiverServices().storeUpToDate()
        super.viewDidLoad()
        Services.sharedInstance.getApiData(partPathApi: "emailed") { apiData in
            self.listOfMailedNews = apiData
            
            DispatchQueue.main.async {
                self.mostEmailedTable.reloadData()
            }
        }
        mostEmailedTable.dataSource = self
        mostEmailedTable.delegate = self
        self.mostEmailedTable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMailedNews.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {return UITableViewCell()}
        cell.textLabel?.text = listOfMailedNews[indexPath.row].title
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var urlSend: String
        urlSend = listOfMailedNews[indexPath.row].url
        performSegue(withIdentifier: "showMostEmailed", sender: urlSend)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController, let urlSend = sender as? String {
            vc.url = urlSend
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uploadedAction = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in completionHandler(true)
        }
        )
        if listOfMailedNews[indexPath.row].isFavorite(){
            Services().delete(object: listOfMailedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Remove Favorite"
            uploadedAction.backgroundColor = .systemYellow
            WebArchiverServices().delete(url: listOfMailedNews[indexPath.row].url)
        }
        else{
            Services().save(object: listOfMailedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Add Favorite"
            uploadedAction.backgroundColor = .systemBlue
            let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(String(listOfMailedNews[indexPath.row].id)).appendingPathExtension("webarchive")
            WebArchiver.archive(url: URL(string: listOfMailedNews[indexPath.row].url)!) { result in
                if let data = result.plistData {
                    do {
                        try data.write(to: archiveURL)
                        WebArchiverServices().save(url: self.listOfMailedNews[indexPath.row].url, archiveURL: archiveURL)
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
