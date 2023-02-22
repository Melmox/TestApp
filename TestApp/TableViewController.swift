//
//  TableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    @IBOutlet var mostEmailedTable: UITableView!
    var listOfMailedNews =  [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Services.sharedInstance.getApiData(partPathApi: "") { apiData in
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
         if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController{
             vc.url = listOfMailedNews[indexPath.row].url
             self.navigationController?.pushViewController(vc, animated: true)
         }
         performSegue(withIdentifier: "showMostEmailed", sender: self)

     }

}
