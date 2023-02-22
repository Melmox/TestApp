//
//  TableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import UIKit

class MostEmailedTableViewController: UITableViewController {
    @IBOutlet var mostEmailedTable: UITableView!
    var listOfMailedNews =  [News]()
    
    override func viewDidLoad() {
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
}