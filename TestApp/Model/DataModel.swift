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

struct News : Codable{
    var url, title : String
    var id : Int
}
