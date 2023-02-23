//
//  WebArchiverServices.swift
//  TestApp
//
//  Created by Мельник Максим on 23.02.2023.
//

import Foundation
import Alamofire
import CoreData

class WebArchiverServices{//Допоміжний клас що використовується для обробки запитів до CoreData
    static let sharedInstance = WebArchiverServices()
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    func save(url: String, archiveURL: URL) {//Збереження
        let archiveHTML = NSEntityDescription.insertNewObject(forEntityName: "SaveHTML", into: context) as!SaveHTML
        archiveHTML.archiveURL = archiveURL
        archiveHTML.url = url
        do {
            try context.save()
            print("Successfully saved")
        } catch {
            print("Could not save")
        }
    }
    
    func fetch() -> [SaveHTML] {//Показ усіх
        var saveHTMLData = [SaveHTML]()
        do {
            saveHTMLData =
            try context.fetch(SaveHTML.fetchRequest())
        } catch {
            print("Couldnt fetch")
        }
        return saveHTMLData
    }
    
    func delete(url: String){//Видалення
        let favArchive = fetch()
        for favHTML in favArchive{
            if url == favHTML.url{
                context.delete(favHTML)
            }
        }
        do {
            try context.save()
            print("Successfully deleted")
        } catch {
            print("Could not delete: \(error)")
        }
    }
    func storeUpToDate(){
        let saveHTMLData = fetch()
        for data in saveHTMLData{
            let dataURL = data.url!
            let idURL = data.archiveURL?.deletingPathExtension().pathComponents
            let archiveURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(idURL![idURL!.count - 1]).appendingPathExtension("webarchive")
            delete(url: dataURL)
            save(url: dataURL, archiveURL: archiveURL)
        }
    }
//        На відміну від файлу Services.swift містить лише функції для обробки сутності SaveHTML
}
