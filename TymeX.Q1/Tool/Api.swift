//
//  Api.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import Foundation

//URL string processing concatenation
let url:String = "https://api.exchangeratesapi.io/v1/latest?access_key="
let key:String = "db74bd22d3080f22215e049ea4b67688"
let urlAPI = URL(string: url+key)!

//Data child object
struct ErrorDetail: Codable {
    var code: Int
    var info: String
}

//Data Objects with API
struct DataAPI: Codable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: [String: Float]
    var error: ErrorDetail?
}

struct CurrencyAPI {
    //API handling method
    func currencyAPI(completion: @escaping(DataAPI)-> Void) async -> Void {
        var request = URLRequest(url: urlAPI)
        request.httpMethod = "GET"
        request.setValue("application/json; Charset=UTF-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                return
            }
            
            //Process and return desired value from API
            let decoder = JSONDecoder()
            do {
                let decodeData = try decoder.decode(DataAPI.self, from: data)
                if decodeData.success {
                    completion(decodeData)
                } else if let errorDetail = decodeData.error {
                    completion(DataAPI(success: false, timestamp: 0, base: "", date: "", rates: [:], error: .init(code: errorDetail.code, info: "\(errorDetail.info)")))
                }
            } catch {
                completion(DataAPI(success: false, timestamp: 0, base: "", date: "", rates: [:], error: .init(code: 0, info: "Error from the system cannot be used!")))
                return
            }
        }.resume()
    }
}
