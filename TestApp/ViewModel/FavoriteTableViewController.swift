//
//  FavoriteTableViewController.swift
//  TestApp
//
//  Created by Мельник Максим on 22.02.2023.
//

import UIKit

    //Останній з вью контроллерів, також є таблицею але, на відміну від інших не підтягує дані з апі, а бере дані з інших контроллерів, для цього я використав NotificationCenter

class FavoriteTableViewController: UITableViewController {
    
    @IBOutlet var FavoriteTable: UITableView!
    var listOfFavoriteNews =  [NewsEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        listOfFavoriteNews = Services().fetch()
        FavoriteTable.dataSource = self
        FavoriteTable.delegate = self
        self.FavoriteTable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    @objc func refresh() {
       listOfFavoriteNews = Services().fetch()
       self.FavoriteTable.reloadData() // a refresh the tableView.

   }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfFavoriteNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {return UITableViewCell()}
        cell.textLabel?.text = listOfFavoriteNews[indexPath.row].title
        return cell
    }


    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var urlSend: String
        urlSend = listOfFavoriteNews[indexPath.row].url!
        performSegue(withIdentifier: "showFavorite", sender: urlSend)
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
        if listOfFavoriteNews[indexPath.row].toNews().isFavorite(){
            WebArchiverServices().delete(url: listOfFavoriteNews[indexPath.row].url!)
            Services().delete(object: listOfFavoriteNews[indexPath.row].toNews())
            listOfFavoriteNews.remove(at: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.FavoriteTable.reloadData()
            }
            uploadedAction.title = "Remove Favorite"
            uploadedAction.backgroundColor = .systemYellow
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }

}
