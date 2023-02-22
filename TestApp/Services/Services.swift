//
//  Services.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import Foundation
import Alamofire

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
    
}
