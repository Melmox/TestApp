//
//  MostSharedTableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 22.02.2023.
//

import UIKit

class MostSharedTableViewController: UITableViewController {
    @IBOutlet var mostSharedTable: UITableView!
    var listOfSharedNews =  [News]()

    
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
}

