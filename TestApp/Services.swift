//
//  Services.swift
//  TestApp
//
//  Created by Мельник Максим on 21.02.2023.
//

import Foundation
import Alamofire

class Services{
//    var array : [News] = []
//    func fin(apiPath: String){
//        Alamofire.request("https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=Di2u5Wdzh8DIRwrAJjU3tqTQxXhFefuI").response { response in
//            self.debugPrint(response: response)
//        }
//    }
//    func debugPrint (response: DefaultDataResponse){
//        let decoder = JSONDecoder()
//        let data = response.data!
//        let launch = try? decoder.decode(Api.self, from: data)
//        array = launch?.results as! [News]
//        print(launch!)
////            return launch
//
//    }
//    fin(apiPath: " ")
//    print(array)
    static let sharedInstance = Services()
    
    func getApiData(partPathApi: String, handler: @escaping (_ apiData:[News])->Void){
//        func getApiData(handler: @escaping (_ apiData:[News])->Void){

        let url = "https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=Di2u5Wdzh8DIRwrAJjU3tqTQxXhFefuI"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(Api.self, from: data!).results
                    handler(jsondata)
                }
                catch{
                    print("Error")
                }
            case .failure(_):
                print("Error")
            }
        }
    }
    
}
