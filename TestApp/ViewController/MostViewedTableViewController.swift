//
//  MostViewedTableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 22.02.2023.
//

import UIKit

class MostViewedTableViewController: UITableViewController {
    @IBOutlet var mostViewedTable: UITableView!
    var listOfViewedNews =  [News]()

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
         urlSend = listOfViewedNews[indexPath.row].url
         performSegue(withIdentifier: "showMostViewed", sender: urlSend)

     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController, let urlSend = sender as? String {
            vc.url = urlSend
            }
        }
}
