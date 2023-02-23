//
//  MostSharedTableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 22.02.2023.
//

import UIKit

//Цей контролер дуже схожий на два інших, вони являють собою таблиці на які виводяться дані. З комірками можна взаємодіяти

class MostSharedTableViewController: UITableViewController {
    @IBOutlet var mostSharedTable: UITableView!
    var listOfSharedNews =  [News]()
    let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("cached").appendingPathExtension("webarchive")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Services.sharedInstance.getApiData(partPathApi: "shared") { apiData in
            self.listOfSharedNews = apiData
            
            DispatchQueue.main.async {
                self.mostSharedTable.reloadData()
            }
        }
        mostSharedTable.dataSource = self
        mostSharedTable.delegate = self
        self.mostSharedTable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSharedNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {return UITableViewCell()}
        cell.textLabel?.text = listOfSharedNews[indexPath.row].title
        return cell
    }

    // MARK: - Navigation

     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         var urlSend: String
         urlSend = listOfSharedNews[indexPath.row].url
         performSegue(withIdentifier: "showMostShared", sender: urlSend)

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
        if listOfSharedNews[indexPath.row].isFavorite(){
            Services().delete(object: listOfSharedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Remove Favorite"
            uploadedAction.backgroundColor = .systemYellow
            WebArchiverServices().delete(url: listOfSharedNews[indexPath.row].url)
        }
        else{
            Services().save(object: listOfSharedNews[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            uploadedAction.title = "Add Favorite"
            uploadedAction.backgroundColor = .systemBlue
            WebArchiver.archive(url: URL(string: listOfSharedNews[indexPath.row].url)!) { result in
                if let data = result.plistData {
                    do {
                        try data.write(to: self.archiveURL)
                        WebArchiverServices().save(url: self.listOfSharedNews[indexPath.row].url, archiveURL: self.archiveURL)
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

