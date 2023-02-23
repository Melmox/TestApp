//
//  MostViewedTableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 22.02.2023.
//

import UIKit

//Цей контролер дуже схожий на два інших, вони являють собою таблиці на які виводяться дані. З комірками можна взаємодіяти

class MostViewedTableViewController: UITableViewController {
    @IBOutlet var mostViewedTable: UITableView!
    var listOfViewedNews =  [News]()
    let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("cached").appendingPathExtension("webarchive")

    override func viewDidLoad() {
        super.viewDidLoad()
        Services.sharedInstance.getApiData(partPathApi: "viewed") { apiData in
            self.listOfViewedNews = apiData
            
            DispatchQueue.main.async {
                self.mostViewedTable.reloadData()
            }
        }
        mostViewedTable.dataSource = self
        mostViewedTable.delegate = self
        self.mostViewedTable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfViewedNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {return UITableViewCell()}
        cell.textLabel?.text = listOfViewedNews[indexPath.row].title
        return cell
    }

    // MARK: - Navigation

     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         var urlSend: String
//         Services().saveData(itemToSave: listOfViewedNews[indexPath.row].title)
         urlSend = listOfViewedNews[indexPath.row].url
         performSegue(withIdentifier: "showMostViewed", sender: urlSend)

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
        if listOfViewedNews[indexPath.row].isFavorite(){
            Services().delete(object: listOfViewedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Remove Favorite"
            uploadedAction.backgroundColor = .systemYellow
            WebArchiverServices().delete(url: listOfViewedNews[indexPath.row].url)
        }
        else{
            Services().save(object: listOfViewedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Add Favorite"
            uploadedAction.backgroundColor = .systemBlue
            WebArchiver.archive(url: URL(string: listOfViewedNews[indexPath.row].url)!) { result in
                if let data = result.plistData {
                    do {
                        try data.write(to: self.archiveURL)
                        WebArchiverServices().save(url: self.listOfViewedNews[indexPath.row].url, archiveURL: self.archiveURL)
                    } catch {
                        print("Error")
                    }
                }
            }        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
