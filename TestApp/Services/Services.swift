//
//  Services.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import Foundation
import Alamofire
import CoreData

class Services{
    static let sharedInstance = Services()
    
    func getApiData(partPathApi: String, handler: @escaping (_ apiData:[News])->Void){
        let apiKey = "Di2u5Wdzh8DIRwrAJjU3tqTQxXhFefuI"
        let url = "https://api.nytimes.com/svc/mostpopular/v2/\(partPathApi)/30.json?api-key=\(apiKey)"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(Api.self, from: data!).results
                    handler(jsondata)
                }
                catch{
                    print("Error decoding")
                }
            case .failure(_):
                print("Error api response")
            }
        }
    }
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    func save(object: News) {
        let news = NSEntityDescription.insertNewObject(forEntityName: "NewsEntity", into: context) as!NewsEntity
        news.id = Int64(exactly: object.id)!
        news.title = object.title
        news.url = object.url
        do {
            try context.save()
            print("Successfully saved")
        } catch {
            print("Could not save")
        }
    }
    
    func fetch() -> [NewsEntity] {
        var newsData = [NewsEntity]()
        do {
            newsData =
                try context.fetch(NewsEntity.fetchRequest())
        } catch {
            print("Couldnt fetch")
        }
        return newsData
    }
    
    func delete(object: News){
        let favNews = fetch()
        for favArticle in favNews{
            if object.id == favArticle.id{
                context.delete(favArticle)
            }
        }
        do {
            try context.save()
            print("Successfully deleted")
        } catch {
            print("Could not delete: \(error)")
        }
    }
}
