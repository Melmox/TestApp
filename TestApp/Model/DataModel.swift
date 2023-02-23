//
//  DataModel.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import Foundation

struct Api : Codable{
    var num_results : Int
    var results : [News]
}
//    Структури за допомогою яких було декодоване API, саме тому вони наслідують Codable
struct News : Codable{
    var url, title : String
    var id : Int
}

extension News{ //Метод класу News, використовується для визначення чи була додана новина до списку обраних
    func isFavorite() -> Bool{
        let allFavorites = Services().fetch()
        for article in allFavorites{
            if article.id == self.id{
                return true
            }
        }
        return false
    }
}
