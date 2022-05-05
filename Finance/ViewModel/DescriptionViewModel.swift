//
//  DescriptionViewModel.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import Foundation
import RxSwift

struct DescriptionViewModel {
    
    weak var delegate : loaderDelegate?
    
    var items = PublishSubject<Array<Any>>()
    
    func fetchItems(symbol : String){
        delegate?.showLoading()
        let headers = [
            "X-RapidAPI-Host": "yh-finance.p.rapidapi.com",
            "X-RapidAPI-Key": "68b915acfdmsh1e045479fee2690p11482bjsn7359ec2c1257"
        ]

        if verifyUrl(urlString: "https://yh-finance.p.rapidapi.com/stock/v2/get-summary?symbol=\(symbol)&region=US"){
            let request = NSMutableURLRequest(url: NSURL(string: "https://yh-finance.p.rapidapi.com/stock/v2/get-summary?symbol=\(symbol)&region=US")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
    //                print(error)
                } else {
                    if let jsonResponse = String(data: data!, encoding: String.Encoding.utf8) {
                        print(jsonResponse)
                        let blogPost: DescriptionModel = try! JSONDecoder().decode(DescriptionModel.self, from: data!)
                        let encodedData = try! JSONEncoder().encode(blogPost.quoteType)
                        let jsonString  = String(data: encodedData,encoding: .utf8)
                        let dict : Dictionary = convertToDictionary(text: jsonString!)!
                        var arr = [String]()
                        for (key, value) in dict {
                            arr.append("\(key)  \(value)")
                        }
                        items.onNext(arr)
                        items.onCompleted()
                    }
                }
                delegate?.stopLoading()
            })
            dataTask.resume()
        }else{
            delegate?.ShowToast?(msg: "Sorry url is not valid")
            print("Sorry url is not valid")
        }
    }
}

func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
